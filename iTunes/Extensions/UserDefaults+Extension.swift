//
//  UserDefaults+Extension.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/7/24.
//

import Foundation

import Foundation

extension UserDefaults {
    enum Key: String {
        case recentKeywordList
    }
    
    var recentKeywordList: [String] {
        get {
            guard let recentKeywordList = UserDefaults.standard.stringArray(forKey: UserDefaults.Key.recentKeywordList.rawValue) else { return []}
            return recentKeywordList
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Key.recentKeywordList.rawValue)
        }
    }
    
}
