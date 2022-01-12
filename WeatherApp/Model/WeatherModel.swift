//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation

struct WeatherModel {

    let temperature: Double
    let sunrise: Int
    let sunset: Int
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let windSpeed: Double
    let description: String?
    let hourlyID: [Int]
    let hourlyDT: [Int]
    let hourlyTemp: [Double]
    let dailyMin: [Double]
    let dailyMax: [Double]
    let dailyDT: [Int]
    let dailyID: [Int]
    let timeZoneOffset: Int
    let currentTime: Int
    
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
        return description!.capitalizingFirstLetter()
    }
    
    var sunsriseString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: timeZoneOffset) as TimeZone
        let sunriseString = dateFormatter.string(from: date)
        return sunriseString
    }
    
    var sunsetString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(sunset))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: timeZoneOffset) as TimeZone
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

struct Homie {
    let cry: WeatherModel
    let pipi: Int
}
