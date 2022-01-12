//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func setWeather(with model: WeatherModel)
}

struct WeatherManager {
    private let url = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=3d4c8200225ab2d654954da00a1d1907&lang=ru&units=metric"
    let sem = DispatchSemaphore.init(value: 0)
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherWith(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        if UserDefaultsModel.shared.degrees == 1 {
            let urlF = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=3d4c8200225ab2d654954da00a1d1907&lang=ru&units=imperial"
            let urlWithCoordinates = "\(urlF)&lat=\(lat)&lon=\(lon)"
            fetchWeather(with: urlWithCoordinates)
        } else {
            let urlWithCoordinates = "\(url)&lat=\(lat)&lon=\(lon)"
            fetchWeather(with: urlWithCoordinates)
        }
    }
    
    func fetchWeather(with url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            defer { sem.signal() }
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
        sem.wait()
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
            let hourlyID = decodedData.hourly.map { $0.weather[0].id }
            let hourlyDT = decodedData.hourly.map { $0.dt }
            let hourlyTemp = decodedData.hourly.map { $0.temp }
            let dailyDT = decodedData.daily.map { $0.dt }
            let dailyID = decodedData.daily.map { $0.weather[0].id }
            let timeZoneOffset = decodedData.timezone_offset
            let currentTime = decodedData.current.dt
            let weather = WeatherModel(temperature: temperature, sunrise: sunrise, sunset: sunset, feelsLike: feelsLike, pressure: pressure, humidity: humidity, visibility: visibility, windSpeed: windSpeed, description: description, hourlyID: hourlyID, hourlyDT: hourlyDT, hourlyTemp: hourlyTemp, dailyMin: dailyMin, dailyMax: dailyMax, dailyDT: dailyDT, dailyID: dailyID, timeZoneOffset: timeZoneOffset, currentTime: currentTime)
            return weather
        }
        catch {
            print(error)
            return nil
        }
    }
}
