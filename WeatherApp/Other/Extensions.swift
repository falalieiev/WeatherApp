//
//  Extensions.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 11.01.2022.
//

import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

extension WeeklyCell {
    func getWeeklyHeader() {
    self.conditionLabel.image = .none
    self.dayLabel.text = ""
    self.minMaxTemp.text = ""
    self.maxMinTemp.text = ""

    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(systemName: "calendar")?.withTintColor(.lightGray)
    let imageOffsetY: CGFloat = -2.5
    imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
    let attachmentString = NSAttributedString(attachment: imageAttachment)
    let completeText = NSMutableAttributedString(string: "")
    completeText.append(attachmentString)
    let textAfterIcon = NSAttributedString(string: "Прогноз на неделю")
    completeText.append(textAfterIcon)
    
    self.textLabel?.textColor = .lightGray
    self.textLabel?.font = .systemFont(ofSize: 17)
    self.textLabel?.attributedText = completeText
    }
}

extension UITableViewCell {
    func getHourlyHeader() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(.lightGray)
        let imageOffsetY: CGFloat = -2.5
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "Прогноз на 24 часа")
        completeText.append(textAfterIcon)
        
        self.textLabel?.textColor = .lightGray
        self.textLabel?.font = .systemFont(ofSize: 17)
        self.textLabel?.attributedText = completeText
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Double {
    func getTemp(_ type: String) -> String{
        let number = String(format: "%.0f", self)
        return "\(type)\(number)°"
    }
    
    func convertToFahrenheit() -> Double {
        if UserDefaultsModel.shared.degrees == 1 {
            let temp = self * 1.8 + 32
            return temp
        } else {
            return self
        }
    }
}

extension Int {
    func getData(_ timeoffset: Int, _ dateFormat: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: timeoffset) as TimeZone
        return dateFormatter.string(from: date)
    }
}

