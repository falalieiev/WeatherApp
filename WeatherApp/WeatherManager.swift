//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func setWeather(with weather: WeatherModel)
}

struct WeatherManager {
    private let url = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=9dff569ec193332c7f258874b970b261&lang=ru&units=metric"
    var delegate: WeatherManagerDelegate?

    func fetchWeatherWith(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlWithCoordinates = "\(url)&lat=\(lat)&lon=\(lon)"
        fetchWeather(with: urlWithCoordinates)
        print(urlWithCoordinates)
    }
    
    func fetchWeather(with url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                if let weather = parseJson(safeData) {
                    DispatchQueue.main.async {
                        delegate?.setWeather(with: weather)
                    }
                }
            }
        }
        .resume()
    }
    
    func parseJson(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let temperature = decodedData.current.temp
            let sunrise = decodedData.current.sunrise
            let sunset = decodedData.current.sunset
            let feelsLike = decodedData.current.feels_like
            let pressure = decodedData.current.pressure
            let humidity = decodedData.current.humidity
            let visibility = decodedData.current.visibility
            let windSpeed = decodedData.current.wind_speed
            let dailyMin = decodedData.daily.map { $0.temp.min }
            let dailyMax = decodedData.daily.map { $0.temp.max }
            let description = decodedData.current.weather[0].description
            let hourlyID: [Int] = decodedData.hourly.map { $0.weather[0].id }
            let hourlyDT: [Int] = decodedData.hourly.map { $0.dt }
            let hourlyTemp: [Double] = decodedData.hourly.map { $0.temp }
            let dailyDT: [Int] = decodedData.daily.map { $0.dt }
            let daylyID: [Int] = decodedData.daily.map { $0.weather[0].id }
            let timeZoneOffset = decodedData.timezone_offset
            let weather = WeatherModel(temperature, sunrise, sunset, feelsLike, pressure, humidity, visibility, windSpeed, dailyMin, dailyMax, description, hourlyID, hourlyDT, hourlyTemp, dailyDT, daylyID, timeZoneOffset)
            return weather
        }
        catch {
            print(error)
            return nil
        }
    }
}
