//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import UIKit
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, WeatherManagerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 8
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyWeather", for: indexPath) as! WeeklyCell
            if dailyMax.isEmpty == false {
                if indexPath.row == 0 {
                    cell.conditionLabel.image = .none
                    cell.dayLabel.text = ""
                    cell.minMaxTemp.text = ""
                    cell.maxMinTemp.text = ""
                    
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = UIImage(systemName: "calendar")?.withTintColor(.lightGray)
                    let imageOffsetY: CGFloat = -2.5
                    imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                    let attachmentString = NSAttributedString(attachment: imageAttachment)
                    let completeText = NSMutableAttributedString(string: "")
                    completeText.append(attachmentString)
                    let textAfterIcon = NSAttributedString(string: "Прогноз на неделю")
                    completeText.append(textAfterIcon)
                    
                    cell.textLabel?.textColor = .lightGray
                    cell.textLabel?.font = .systemFont(ofSize: 17)
                    cell.textLabel?.attributedText = completeText
                } else {
                    //tableView.rowHeight = 44
                    cell.textLabel?.attributedText = nil
                    let min = String(format: "%.0f", dailyMin[indexPath.row])
                    let minSign = "Мин: \(min)°"
                    let max = String(format: "%.0f", dailyMax[indexPath.row])
                    let maxSign = "Макс: \(max)°"
                    cell.maxMinTemp.text = minSign
                    cell.minMaxTemp.text = maxSign
                    cell.conditionLabel.image = UIImage(systemName: weatherConditions.getWeatherCondition(id: dailyID[indexPath.row]))
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(dailyDT[indexPath.row]))
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    dateFormatter.dateFormat = "E"
                    dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: timeZoneOffset) as TimeZone
                    let dayString = dateFormatter.string(from: date)
                    cell.dayLabel.text = dayString
                }
            }
            return cell
        } else {
            let infoCell = infoTableView.dequeueReusableCell(withIdentifier: "info", for: indexPath)
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(.lightGray)
            let imageOffsetY: CGFloat = -2.5
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            let completeText = NSMutableAttributedString(string: "")
            completeText.append(attachmentString)
            let textAfterIcon = NSAttributedString(string: "Прогноз на 24 часа")
            completeText.append(textAfterIcon)
            
            infoCell.textLabel?.textColor = .lightGray
            infoCell.textLabel?.font = .systemFont(ofSize: 17)
            infoCell.textLabel?.attributedText = completeText
            return infoCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourlyWeatherCollection.dequeueReusableCell(withReuseIdentifier: "hourlyWeather", for: indexPath) as! HourlyWeatherCell
        if hourlyID.isEmpty == false {
            let temp = String(format: "%.0f", hourlyTemp[indexPath.row])
            let tempWithSign = "\(temp)°"
            cell.temperatureLabel.text = tempWithSign
            
            cell.conditionImage.image = UIImage(systemName: weatherConditions.getWeatherCondition(id: hourlyID[indexPath.row]))
            
            if indexPath.row == 0 {
                cell.timeLabel.text = "Сейчас"
            } else {
                let date = Date(timeIntervalSince1970: TimeInterval(hourlyDT[indexPath.row]))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH"
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: timeZoneOffset) as TimeZone
                let sunriseString = dateFormatter.string(from: date)
                cell.timeLabel.text = sunriseString
            }
        }
        return cell
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var hourlyWeatherCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    
    private let weatherConditions = WeatherConditions()
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private var didFindLocation: Bool?
    private var hourlyTemp: [Double] = []
    private var hourlyID: [Int] = []
    private var hourlyDT: [Int] = []
    private var dailyMax: [Double] = []
    private var dailyMin: [Double] = []
    private var dailyDT: [Int] = []
    private var dailyID: [Int] = []
    private var timeZoneOffset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        didFindLocation = false
    }
    
    @IBAction func searchForCityButtonPressed(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autoCompleteController.autocompleteFilter = filter
        present(autoCompleteController, animated: true, completion: nil)
    }
    
    func setWeather(with weather: WeatherModel) {
        windSpeedLabel.text = weather.windSpeedString
        pressureLabel.text = weather.pressureString
        humidityLabel.text = weather.humidityString
        minTempLabel.text = weather.dailyMinString
        maxTempLabel.text = weather.dailyMaxString
        feelsLikeLabel.text = weather.feelsLikeString
        visibilityLabel.text = weather.visibilityString
        sunsetLabel.text = weather.sunsetString
        sunriseLabel.text = weather.sunsriseString
        descriptionLabel.text = weather.descriptionString
        currentTempLabel.text = weather.temperatureString
        hourlyDT = weather.hourlyDT
        hourlyID = weather.hourlyID
        hourlyTemp = weather.hourlyTemp
        dailyMax = weather.dailyMax
        dailyMin = weather.dailyMin
        dailyDT = weather.dailyDT
        dailyID = weather.dailyID
        timeZoneOffset = weather.timeZoneOffset
        tableView.reloadData()
        hourlyWeatherCollection.reloadData()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        didFindLocation = false
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFindLocation == false {
            if let location = locations.last {
                didFindLocation = true
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeatherWith(lat, lon)
                fetchCityAndCountry(from: location) { city in
                    self.cityLabel.text = city
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality)
        }
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        weatherManager.fetchWeatherWith(lat, lon)
        cityLabel.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            if indexPath.row == 0 {
                return 34.0
            } else {
                return 44.0
            }
        } else {
            print("df")
            return 34.0
        }
    }
}
