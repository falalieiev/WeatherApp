//
//  Protocols.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 11.01.2022.
//

import Foundation

protocol CityOverviewDelegate {
    func passUrl(_ url: String?, _ cityName: String?)
    func updateDegrees()
}

protocol WeatherManagerDelegate {
    func setWeather(with model: WeatherForecast)
}
