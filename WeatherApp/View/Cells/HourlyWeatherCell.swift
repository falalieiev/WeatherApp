//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 23.12.2021.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configureCell(_ model: WeatherForecast?,
                       _ indexPath: Int,
                       _ weatherConition: WeatherConditions) {
        
        if let weather = model {
            temperatureLabel.text = weather.hourlyForecast.temperature[indexPath].getTemp("")
            conditionImage.image = weatherConition.getWeatherCondition(id: weather.hourlyForecast.conditionID[indexPath])
            timeLabel.text = weather.hourlyForecast.time[indexPath].getData(weather.currentForecast.timezoneOffset, "HH")
        }
    }
}
