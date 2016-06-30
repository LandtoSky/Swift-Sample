//
//  SWBAuthOperations.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Alamofire

private let SCOPE = "properties:read,properties:write,contacts:read,contacts:write"
extension SWBAuthenticationService {
    /**

     Check if the user is authenticated based on the token.
     - returns: If the user is authenticated or not
     */
    func userIsAuthenticated() -> Bool {
        if let _ = SWBKeychain.get(.AccessToken), let _ = SWBKeychain.get(.RefreshToken) {
            return true
        }
        return false
    }

    /**
     Check if access token is valid.

     This method will calculate the last time that the token was updated and, based on the expires in value, return true when is valid and false when it's not.
     - returns: If access token is expired or not
    */
    func tokenIsValid() -> Bool {
        let dateFormatter = Formatter.jsonDateTimeFormatter

        //1: Verify if there are an refresh_token, lastTimeTokenWasUpdated and access_token in the SWBKeychain
        let access_token = SWBKeychain.get(.AccessToken)
        let refresh_token = SWBKeychain.get(.RefreshToken)
        let lastTimeTokenWasUpdated = SWBKeychain.get(.TokenUpdatedAt)
        let expires_in: NSTimeInterval = Double(SWBKeychain.get(.ExpiresIn) ?? "0") ?? 0.0

        let listOfTokens = [access_token, refresh_token, lastTimeTokenWasUpdated]
        let listOfNilTokens = listOfTokens.filter({$0 == nil})

        if listOfNilTokens.count == 0 {
            //2: Check if the access token is expired
            if let lastUpdate = dateFormatter.dateFromString(lastTimeTokenWasUpdated!) {
                let deadline = lastUpdate.dateByAddingTimeInterval(expires_in)

                //If token is not expired, do not update it
                if deadline.compare(NSDate()) == .OrderedDescending {
                    NSLog("access token: Finished by using keychain's value")
                    return true
                }
            }
        }
        return false
    }

    /**
     Logout authenticated user.

     This method will remove all the credentials and delete the database content.
    */
    func logout() {
        SWBKeychain.clear()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    /**

     Update tokens.

     - parameter json: The JSON response from the server
    */
    private func updateAccessToken(json: JSON) {
        SWBKeychain.set(json["access_token"].stringValue, forKey: .AccessToken)
        SWBKeychain.set(json["refresh_token"].stringValue, forKey: .RefreshToken)
        SWBKeychain.set(json["expires_in"].stringValue, forKey: .ExpiresIn)
        SWBKeychain.set(NSDate(), forKey: .TokenUpdatedAt)
    }

    /**
     Alamofire request used when get the access token or refresh it.
     */
    private var handlerUpdateToken: Response<AnyObject, NSError> -> Void {
        return {
            response in
            debugPrint(response)
            let statusCode = response.response?.statusCode ?? 0
            switch statusCode {
            case 200...299:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.updateAccessToken(json)
                }
            default:
                NSLog("Couldn't get the access token, status code: \(statusCode)")
                break
            }
        }
    }

    /**
     Update the RegisterToken value on the keychain.

     This method will update the register token in the keychain, which gonna be used on the signIn method to get the user access token.
     - returns: An NSOperation object
     */

    func getRegisterToken() -> NSOperation {
        return NSBlockOperation {
            let parameters = [
                "client_id": SWBRoutes.SWBCLIENTID,
                "client_secret":SWBRoutes.SWBCLIENTSECRET,
                "scope":"register",
                "grant_type": "client_credentials"
            ]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.POST, url: "\(SWBRoutes.SWBSERVERURL)/auth/access_token", parameters: parameters, completionHandler: {
                response in

                let statusCode = response.response?.statusCode ?? 0
                switch statusCode {
                case 200...299:
                    if let value = response.result.value {
                        let json = JSON(value)
                        SWBKeychain.set(json["access_token"].stringValue, forKey: .RegisterToken)
                    }
                default:
                    break
                }
            })
        }
    }

    func signIn(withEmail email: String ) -> NSOperation {
        return NSBlockOperation {

            let parameters = [
                "email": email,
                "base_url": "swb://",
                "grant_type": "email",
                "scope": SCOPE
            ]

            let headers = [
                "content-type": "application/json",
                "Authorization": "Bearer \(SWBKeychain.get(.RegisterToken) ?? "")",
                "accept": "application/vnd.sweepbright.v1+json",
                "cache-control": "no-cache"
            ]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.POST, url: "\(SWBRoutes.SWBSERVERURL)/auth/email_access_token", parameters: parameters, headers: headers, completionHandler: {
                response in
                let statusCode = response.response?.statusCode ?? 0
                statusCode == 204 ? self.delegate.successfulSignIn() : self.delegate.unsuccessfulSignIn(nil)
            })
        }
    }

    func refreshAccessToken() -> NSOperation {
        return NSBlockOperation {
            let refresh_token = SWBKeychain.get(.RefreshToken)

            let parameters = [
                "refresh_token":refresh_token ?? "",
                "grant_type":"refresh_token",
                "client_id": SWBRoutes.SWBCLIENTID,
                "client_secret":SWBRoutes.SWBCLIENTSECRET
            ]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.POST, url: "\(SWBRoutes.SWBSERVERURL)/auth/refresh_token", parameters: parameters, completionHandler: self.handlerUpdateToken)
        }
    }
}
