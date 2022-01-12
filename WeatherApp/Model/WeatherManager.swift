//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import Foundation
import CoreLocation

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
    
    func parseJson(_ data: Data) -> WeatherForecast? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
        
            let currentTemperature = decodedData.current.temp
            let currentSunrise = decodedData.current.sunrise
            let currentSunset = decodedData.current.sunset
            let currentFeelsLikeTemp = decodedData.current.feels_like
            let currentPressure = decodedData.current.pressure
            let currentHumidity = decodedData.current.humidity
            let currentVisibility = decodedData.current.visibility
            let currentWindSpeed = decodedData.current.wind_speed
            let currentDescription = decodedData.current.weather[0].description
            let currentTime = decodedData.current.dt
            let currentTimezoneOffset = decodedData.timezone_offset
            
            let hourlyConditionID = decodedData.hourly.map { $0.weather[0].id }
            let hourlyTime = decodedData.hourly.map { $0.dt }
            let hourlyTemperature = decodedData.hourly.map { $0.temp }
            
            let dailyMaxTemperature = decodedData.daily.map { $0.temp.max }
            let dailyMinTemperature = decodedData.daily.map { $0.temp.min }
            let dailyTime = decodedData.daily.map { $0.dt }
            let dailyConditionID = decodedData.daily.map { $0.weather[0].id }
            
            let currentForecast = WeatherForecast.CurrentForecast(temperature: currentTemperature, sunrise: currentSunrise, sunset: currentSunset, feelsLikeTemp: currentFeelsLikeTemp, pressure: currentPressure, humidity: currentHumidity, visibility: currentVisibility, windSpeed: currentWindSpeed, description: currentDescription, time: currentTime, timezoneOffset: currentTimezoneOffset)
            
            let hourlyForecast = WeatherForecast.HourlyForecast(conditionID: hourlyConditionID, time: hourlyTime, temperature: hourlyTemperature)
            
            let dailyForecast = WeatherForecast.DailyForecast(maxTemperature: dailyMaxTemperature, minTemperature: dailyMinTemperature, time: dailyTime, conditionID: dailyConditionID)
            
            let weather = WeatherForecast(currentForecast: currentForecast, hourlyForecast: hourlyForecast, dailyForecast: dailyForecast)
            
            return weather
        }
        catch {
            print(error)
            return nil
        }
    }
}
