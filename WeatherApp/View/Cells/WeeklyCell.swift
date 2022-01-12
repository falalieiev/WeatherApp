//
//  WeeklyCell.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 23.12.2021.
//

import UIKit

class WeeklyCell: UITableViewCell {

    @IBOutlet weak var maxMinTemp: UILabel!
    @IBOutlet weak var minMaxTemp: UILabel!
    @IBOutlet weak var conditionLabel: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    func configureCell(_ model: WeatherForecast?,
                       _ indexPath: Int,
                       _ weatherCondition: WeatherConditions) {
        
        if let weather = model {
            if indexPath == 0 {
                getWeeklyHeader()
            } else {
                textLabel?.attributedText = nil
                maxMinTemp.text = weather.dailyForecast.minTemperature[indexPath].getTemp("Мин: ")
                minMaxTemp.text = weather.dailyForecast.maxTemperature[indexPath].getTemp("Макс: ")
                conditionLabel.image = weatherCondition.getWeatherCondition(id: weather.dailyForecast.conditionID[indexPath])
                dayLabel.text = weather.dailyForecast.time[indexPath].getData(weather.currentForecast.timezoneOffset, "E")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

