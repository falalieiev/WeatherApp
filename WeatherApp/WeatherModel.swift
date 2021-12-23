//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

import Foundation
import UIKit

struct WeatherModel {
    private let temperature: Double
    private let sunrise: Int
    private let sunset: Int
    private let feelsLike: Double
    private let pressure: Int
    private let humidity: Int
    private let visibility: Int
    private let windSpeed: Double
    private let description: String
    let hourlyID: [Int]
    let hourlyDT: [Int]
    let hourlyTemp: [Double]
    let dailyMin: [Double]
    let dailyMax: [Double]
    let dailyDT: [Int]
    let dailyID: [Int]
    
    init(_ temperature: Double, _ sunrise: Int, _ sunset: Int, _ feelsLike: Double, _ pressure: Int, _ humidity: Int, _ visibility: Int, _ windSpeed: Double, _ dailyMin: [Double], _ dailyMax: [Double], _ description: String, _ hourlyID: [Int], _ hourlyDT: [Int], _ hourlyTemp: [Double], _ dailyDT: [Int], _ dailyID: [Int]){
        self.temperature = temperature
        self.sunrise = sunrise
        self.sunset = sunset
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.dailyMin = dailyMin
        self.dailyMax = dailyMax
        self.description = description
        self.hourlyID = hourlyID
        self.hourlyDT = hourlyDT
        self.hourlyTemp = hourlyTemp
        self.dailyDT = dailyDT
        self.dailyID = dailyID
    }
    
    var temperatureString: String {
        let temp = String(format: "%.0f", temperature)
        let tempWithSign = "\(temp)°"
        return tempWithSign
    }
    
    var feelsLikeString: String {
        let temp = String(format: "%.0f", feelsLike)
        let tempWithSign = "\(temp)°"
        return tempWithSign
    }
    
    var dailyMinString: String {
        let temp = String(format: "%.0f", dailyMin[0])
        let tempWithSign = "\(temp)°"
        return tempWithSign
    }
    
    var dailyMaxString: String {
        let temp = String(format: "%.0f", dailyMax[0])
        let tempWithSign = "\(temp)°"
        return tempWithSign
    }
    
    var descriptionString: String {
        return description.capitalizingFirstLetter()
    }
    
    var sunsriseString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let sunriseString = dateFormatter.string(from: date)
        return sunriseString
    }
    
    var sunsetString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(sunset))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let sunsetString = dateFormatter.string(from: date)
        return sunsetString
    }
    
    var windSpeedString: String {
        let windSpeed = String(format: "%.0f", windSpeed)
        let windSpeedString = "\(windSpeed) км/час"
        return windSpeedString
    }
    
    var pressureString: String {
        return "\(pressure) гПа"
    }
    
    var visibilityString: String {
        return "\(visibility / 1000) км"
    }
    
    var humidityString: String {
        return "\(humidity) %"
    }
}
