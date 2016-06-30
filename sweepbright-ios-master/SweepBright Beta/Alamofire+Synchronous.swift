//
//  Alamofire+Synchronous.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire
import Crashlytics

class SWBSynchronousRequestFactory {
    static let sharedInstance: SWBSynchronousRequestFactory = SWBSynchronousRequestFactory()

    private init() {

        self.configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 10 // seconds

        self.manager = Alamofire.Manager(configuration: self.configuration)
    }

    var configuration: NSURLSessionConfiguration
    var manager: Alamofire.Manager
    static var globalResponserHandler: (Response<AnyObject, NSError> -> Void)? = nil
    func requestSynchronous(method: Alamofire.Method, url: URLStringConvertible, body: NSData?, headers: [String:String]?=["Content-Type": "application/json"], completionHandler: Response<AnyObject, NSError> -> Void) {

        //Create request
        let request = NSMutableURLRequest(URL: NSURL(string: url.URLString)!)
        request.HTTPMethod = method.rawValue

        //Populating the header
        for (key, value) in headers! {
            request.setValue(value, forHTTPHeaderField: key)
        }

        //set the body (JSON in NSData)
        request.HTTPBody = body

        //Create a request with timeout
        let alamofireRequest = self.manager.request(request)
        debugPrint(alamofireRequest)

        //Execute the request
        self.semaphoreRequest(alamofireRequest, completionHandler: completionHandler)

    }

    func requestSynchronous(method: Alamofire.Method, url: URLStringConvertible, parameters: [String:AnyObject]?, headers: [String:String]? = nil, completionHandler: Response<AnyObject, NSError> -> Void) {
        var headers = headers
        if headers == nil {
            headers = ["Content-Type": "application/json",
                        "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"
            ]
        }
        var body: NSData? = nil

        //Create a request
        if let _ = parameters {
           body = (try! NSJSONSerialization.dataWithJSONObject(parameters!, options: []))
        }

        //Execute the request
        self.requestSynchronous(method, url: url, body: body, headers: headers, completionHandler: completionHandler)
    }

    // semaphoreRequest prevents a synchronous request on the server
    private func semaphoreRequest(request: Alamofire.Request, completionHandler: Response<AnyObject, NSError> -> Void) {
        //Create a semaphore
        let sema = dispatch_semaphore_create(0)

        request.responseJSON(completionHandler: {
            response in
            //Store on Answers the user gets a bad request
            let statusCode = response.response?.statusCode ?? 0
            if statusCode > 399 {
                Answers.logCustomEventWithName("Bad request",
                    customAttributes: [
                        "URL": request.request?.URLString ?? "",
                        "cURL": String(request),
                        "StatusCode": statusCode
                    ])
            }
            //Execute the completionHandler
            completionHandler(response)
            SWBSynchronousRequestFactory.globalResponserHandler?(response)
            //Release the semaphore
            dispatch_semaphore_signal(sema)
        })

        //Wait for a response
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
    }

    func safeSynchronousRequest(method: Alamofire.Method, url: URLStringConvertible, parameters: AnyObject? = [:], headers: [String:String]?=["Content-Type": "application/json"], completionHandler: Response<AnyObject, NSError> -> Void) {

        //convert the paramters to a serialized json object
        let body = (try! NSJSONSerialization.dataWithJSONObject(parameters!, options: []))

        //Offline block: This will handle the response and add the request on the offline queue if it's needed
        let completionBlock: Response<AnyObject, NSError> -> Void = {
            response in

            if response.response == nil {
                NSLog("No connection")

                // Sends to Answer the URL that the user is trying to access offline
                Answers.logCustomEventWithName("Offline access",
                                               customAttributes: [
                                                "URL": response.request?.URLString ?? ""
                    ])

                let request = SWBOfflineRequest(value:["url":url.URLString])

                //Storing the parameters of the request
                request.body = body

                //Storing the header
                for (key, value) in headers! {
                    let parameter = SWBParameter(value:["key":key, "value":value])
                    request.headers.append(parameter)
                }
                request.method = method.rawValue
                SWBOfflineQueue.sharedInstance.addRequest(request)
            }
            completionHandler(response)
        }

        self.requestSynchronous(method, url: url, body: body, headers: headers, completionHandler: completionBlock)
    }

    /**
     Update an image using multi-part/form-data.

     This progress runs async.

     - parameter url: URL that will be request
     - parameter headers: header of the request
     - parameter image: image that will be uploaded
     - parameter progress:
        - parameter: percentage of the uploading
     - parameter response: response of the request
     - returns: a photo upload progress object
     */
    func imageUpload(url: String, headers: [String: String], image: UIImage, response: Response<AnyObject, NSError> -> Void) -> PhotoUploadProgress? {
        //Create a semaphore
        let sema = dispatch_semaphore_create(0)
        var newUploadProgress: PhotoUploadProgress?

        Alamofire.upload(
            .POST, url, headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: image.asData(), name: "file", fileName: "image.png", mimeType: "image/png")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):

                    newUploadProgress = PhotoUploadProgress(url: upload.request?.URL?.absoluteString, image: image, request: upload)
                    PhotoUploader.addProgress(newUploadProgress!)
                    upload.responseJSON(completionHandler: response)
                case .Failure(let encodingError):
                    print(encodingError)
                }

                //Release the semaphore
                dispatch_semaphore_signal(sema)
            }
        )

        //Wait for a response
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER)
        return newUploadProgress
    }
}
