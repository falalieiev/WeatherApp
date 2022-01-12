//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation

struct WeatherData: Codable {
    let timezone_offset: Int
    let hourly: [Hourly]
    let daily: [Daily]
    let current: Current
}

struct Weather: Codable {
    let description: String?
    let id: Int
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let sunrise: Int
    let sunset: Int
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Hourly: Codable {
    let temp: Double
    let dt: Int
    let weather: [Weather]
}

struct Daily: Codable {
    let temp: Temp
    let weather: [Weather]
    let dt: Int
}

struct Temp: Codable {
    let min: Double
    let max: Double
}


