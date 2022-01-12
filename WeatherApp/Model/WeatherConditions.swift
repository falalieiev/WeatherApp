//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 23.12.2021.
//

import UIKit

struct WeatherConditions {
    
    func getWeatherCondition(id: Int) -> UIImage? {
        switch id {
        case 200...232:
            return UIImage(systemName: "cloud.bolt")
        case 300...321:
            return UIImage(systemName: "cloud.drizzle")
        case 500...531:
            return UIImage(systemName: "cloud.rain")
        case 600...622:
            return UIImage(systemName: "cloud.snow")
        case 701...781:
            return UIImage(systemName: "cloud.fog")
        case 800:
            return UIImage(systemName: "sun.max")
        case 801...804:
            return UIImage(systemName: "cloud.bolt")
        default:
            return UIImage(systemName: "cloud")
        }
    }
}
