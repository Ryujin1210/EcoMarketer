//
//  TokenManager.swift
//  EcoMarketer
//
//  Created by YU WONGEUN on 7/10/24.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() {}
    
    private let keychainService = String(describing: Bundle.main.bundleIdentifier)
    private let keychainAccount = "userData"
    
    
    func getRefreshToken() -> String? {
        if let userData = loadToken() {
            return userData.data.refreshToken
        }
        return nil
    }
    
    func getAccessToken() -> String? {
           if let userData = loadToken() {
               return userData.data.accessToken
           }
           return nil
       }
    
    func saveToken(_ userData: UserData) {
        do {
            let data = try JSONEncoder().encode(userData)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: keychainAccount,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                print("Token successfully saved to Keychain")
            } else {
                print("Failed to save token to Keychain: \(status)")
            }
        } catch {
            print("Failed to encode token: \(error)")
        }
    }
    
    func loadToken() -> UserData? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            do {
                return try JSONDecoder().decode(UserData.self, from: data)
            } catch {
                print("Failed to decode token from Keychain: \(error)")
            }
        }
        return nil
    }
    
    func clearToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Token successfully removed from Keychain")
        } else {
            print("Failed to remove token from Keychain: \(status)")
        }
    }
}
