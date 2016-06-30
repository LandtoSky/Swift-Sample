//
//  KeychainSwift+Enum.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import KeychainSwift

enum SWBKeychainKey: String {
    case AccessToken = "ACCESS_TOKEN"
    case UserAccessToken = "UACCESS_TOKEN"
    case RefreshToken = "REFRESH_TOKEN"
    case RegisterToken = "REGISTER"
    case ExpiresIn = "EXPIRES_IN"
    case TokenUpdatedAt = "TOKEN_UPDATED_AT"
}

class SWBKeychain {
    private static let keychain = KeychainSwift(keyPrefix: "SWB")

    class func set(value: String, forKey key: SWBKeychainKey) -> Bool {
        return self.keychain.set(value, forKey: key.rawValue)
    }

    class func get(key: SWBKeychainKey) -> String? {
        return self.keychain.get(key.rawValue)
    }

    class func delete(key: SWBKeychainKey) -> Bool {
        return self.keychain.delete(key.rawValue)
    }

    class func clear() {
        self.keychain.clear()
    }
}

extension SWBKeychain {
    class func set(date: NSDate, forKey key: SWBKeychainKey) -> Bool {
        let dateFormatter = Formatter.jsonDateTimeFormatter
        return self.set(dateFormatter.stringFromDate(NSDate()), forKey: key)
    }
}
