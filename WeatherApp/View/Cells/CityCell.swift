//
//  CityCell.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 27.12.2021.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var minMaxTemp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentPlaceLabel: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.height -= 10
            super.frame = frame
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 9
        layer.masksToBounds = false
    }
}
