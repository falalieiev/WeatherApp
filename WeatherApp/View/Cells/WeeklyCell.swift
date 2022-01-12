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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

