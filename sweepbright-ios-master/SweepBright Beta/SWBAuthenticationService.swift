//
//  SWBAuthenticationService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//
import Foundation

protocol SWBAuthenticationServiceDelegate {
    func successfulSignIn()
    func unsuccessfulSignIn(error: NSError?)
}
protocol SWBAuthenticationService {
    var delegate: SWBAuthenticationServiceDelegate! { get set }
    func signIn(withEmail email: String)
}

class SWBAuthService: NSObject, SWBAuthenticationService {
    var delegate: SWBAuthenticationServiceDelegate!
    let queue = NSOperationQueue()

    func signIn(withEmail email: String) {
        //Register token is required to sent the sign in request, check https://api.sweepbright.mwlhq.com/docs/#oauth-access-token-endpoint-1
        let accessOp = SWBRoutes.getRegisterToken()
        let signInOp: NSOperation = self.signIn(withEmail: email)
        signInOp.addDependency(accessOp)
        self.queue.addOperations([accessOp, signInOp], waitUntilFinished: false)
    }
}
