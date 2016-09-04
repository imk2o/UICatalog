//
//  UserDefaultsManager.swift
//  UICatalog
//
//  Created by k2o on 2016/09/04.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private var userDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    private init() {
    }

    func set<V where V: NSCoding>(value value: V, for key: String) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(value)
        self.userDefaults.setObject(data, forKey: key)
        self.userDefaults.synchronize()
    }
    
    func value<V where V: NSCoding>(for key: String) -> V? {
        let data = self.userDefaults.dataForKey(key)
        return data.flatMap {
            NSKeyedUnarchiver.unarchiveObjectWithData($0) as? V
        }
    }
    
    func contains(for key: String) -> Bool {
        return self.userDefaults.objectForKey(key) != nil
    }
    
    func remove(for key: String) {
        self.userDefaults.removeObjectForKey(key)
    }
    
    func clear() {
        for key in self.userDefaults.dictionaryRepresentation().keys {
            self.remove(for: key)
        }
    }
}
