//
//  UserDefaults.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 09.01.2022.
//

import Foundation

struct UserDefaultsModel {
    static let shared = UserDefaultsModel()
    
    var degrees: Int {
        get {
            return UserDefaults.standard.integer(forKey: "degreesMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "degreesMode")
        }
    }
}
