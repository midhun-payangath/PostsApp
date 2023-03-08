//
//  Configuration.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation

enum EnvConfig: String {
    case HOST
    case CLIENT_ID
    
    static func value(_ key: EnvConfig) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
        else {
            return nil
        }
        return value
    }
}
