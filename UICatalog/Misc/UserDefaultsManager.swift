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

    fileprivate var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    fileprivate init() {
    }

    func set<V>(value: V, for key: String) where V: NSCoding {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        self.userDefaults.set(data, forKey: key)
        self.userDefaults.synchronize()
    }
    
    func value<V>(for key: String) -> V? where V: NSCoding {
        let data = self.userDefaults.data(forKey: key)
        return data.flatMap {
            NSKeyedUnarchiver.unarchiveObject(with: $0) as? V
        }
    }
    
    func contains(for key: String) -> Bool {
        return self.userDefaults.object(forKey: key) != nil
    }
    
    func remove(for key: String) {
        self.userDefaults.removeObject(forKey: key)
    }
    
    func clear() {
        for key in self.userDefaults.dictionaryRepresentation().keys {
            self.remove(for: key)
        }
    }
}
