//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation

struct WeatherForecast {

    var currentForecast: CurrentForecast
    var hourlyForecast: HourlyForecast
    var dailyForecast: DailyForecast
    
    struct CurrentForecast {
        var temperature: Double
        var sunrise: Int
        var sunset: Int
        var feelsLikeTemp: Double
        var pressure: Int
        var humidity: Int
        var visibility: Int
        var windSpeed: Double
        var description: String?
        var time: Int
        var timezoneOffset: Int
        
        var pressureString: String {
            return "\(pressure) гПа"
        }
        
        var visibilityString: String {
            return "\(visibility / 1000) км"
        }
        
        var humidityString: String {
            return "\(humidity) %"
        }
        
        var windSpeedString: String {
            let windSpeed = String(format: "%.0f", windSpeed)
            let windSpeedString = "\(windSpeed) км/час"
            return windSpeedString
        }
    }

    struct HourlyForecast {
        var conditionID: [Int]
        var time: [Int]
        var temperature: [Double]
    }

    struct DailyForecast {
        var maxTemperature: [Double]
        var minTemperature: [Double]
        var time: [Int]
        var conditionID: [Int]
    }

}
