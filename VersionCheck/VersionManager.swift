//
//  VersionManager.swift
//  VersionCheck
//
//  Created by Priyal on 15/01/20.
//  Copyright © 2020 Priyal. All rights reserved.
//

import Foundation

class VersionManager {
    
    static let sharedVersionManager = VersionManager()
    
    private init() {
        
    }
    
     func isUpdateAvailable() -> Bool {
        guard let currentVersionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        guard let appVersion = getUpdatedVersion() else {
            return false
        }
        
        return appVersion != currentVersionStr
    }
    
     private func getUpdatedVersion() -> String? {
        
        guard let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
                return nil
        }
        
        let itunesAppURL = "http://itunes.apple.com/in/lookup?bundleId=\(bundleID)"
        
        guard let url = URL(string: itunesAppURL) else {
            return nil
        }
        
        
        guard let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let lookupResults = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions()) as? [String:Any] else {
            return nil
        }
        
        guard let resultCount = lookupResults["resultCount"] as? Int, resultCount == 1 else {
            return nil
        }
        
        guard let results = lookupResults["results"] as? [[String:Any]] else {
            return nil
        }
        
        guard let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        
        return appStoreVersion
    }
    
}
