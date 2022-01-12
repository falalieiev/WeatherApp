//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 21.12.2021.
//

import UIKit
import GooglePlaces
import CoreLocation

class MainVC: UIViewController {
    
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
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private var weatherForecast: WeatherForecast?
    private let weatherConditions = WeatherConditions()
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    private var didFindLocation: Bool?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        didFindLocation = false
        
        backgroundImage.image = UIImage(named: "background")?.resizeImage(targetSize: backgroundImage.bounds.size)
    }
    
    @IBAction func searchForCityButtonPressed(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autoCompleteController.autocompleteFilter = filter
        present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func toCitiesOverview(_ sender: UIButton) {
        performSegue(withIdentifier: "goCitiesOverview", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCitiesOverview" {
            let destinationVC = segue.destination as! CityOverviewVC
            destinationVC.delegate = self
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        didFindLocation = false
    }
}

//MARK: - CityOverviewDelegate

extension MainVC: CityOverviewDelegate {
    
    func updateDegrees() {
        weatherManager.fetchWeatherWith(lat!, lon!)
    }
    
    func passUrl(_ url: String?, _ cityName: String?) {
        
        if cityName?.isEmpty == false {
            weatherManager.fetchWeather(with: url!)
            cityLabel.text = cityName
        } else {
            tableView.reloadData()
        }
    }
}

//MARK: - WeatherManagerDelegate

extension MainVC: WeatherManagerDelegate {
    
    func setWeather(with weather: WeatherForecast) {
        windSpeedLabel.text = weather.currentForecast.windSpeedString
        pressureLabel.text = weather.currentForecast.pressureString
        humidityLabel.text = weather.currentForecast.humidityString
        minTempLabel.text = weather.dailyForecast.minTemperature[0].getTemp("")
        maxTempLabel.text = weather.dailyForecast.maxTemperature[0].getTemp("")
        feelsLikeLabel.text = weather.currentForecast.feelsLikeTemp.getTemp("")
        visibilityLabel.text = weather.currentForecast.visibilityString
        sunsetLabel.text = weather.currentForecast.sunset.getSunTimeString(weather.currentForecast.timezoneOffset)
        sunriseLabel.text = weather.currentForecast.sunrise.getSunTimeString(weather.currentForecast.timezoneOffset)
        descriptionLabel.text = weather.currentForecast.description?.capitalizingFirstLetter()
        currentTempLabel.text = weather.currentForecast.temperature.getTemp("")
        
        weatherForecast = weather
        
        tableView.reloadData()
        hourlyWeatherCollection.reloadData()
    }
}

//MARK: - CLLocationManagerDelegate

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFindLocation == false {
            
            if let location = locations.last {
                
                didFindLocation = true
                locationManager.stopUpdatingLocation()
                
                lat = location.coordinate.latitude
                lon = location.coordinate.longitude
                
                weatherManager.fetchWeatherWith(lat!, lon!)
                
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

//MARK: - GMSAutocompleteViewControllerDelegate

extension MainVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        lat = place.coordinate.latitude
        lon = place.coordinate.longitude
        
        weatherManager.fetchWeatherWith(lat!, lon!)
        
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

//MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return 8
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "weeklyWeather", for: indexPath) as! WeeklyCell
            cell.configureCell(weatherForecast, indexPath.row, weatherConditions)
            
            return cell
        } else {
            let infoCell = infoTableView.dequeueReusableCell(withIdentifier: "info", for: indexPath)
            infoCell.getHourlyHeader()
            
            return infoCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            
            if indexPath.row == 0 {
                return 34.0
            } else {
                return 44.0
            }
        } else {
            return 34.0
        }
    }
}

//MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = hourlyWeatherCollection.dequeueReusableCell(withReuseIdentifier: "hourlyWeather", for: indexPath) as! HourlyWeatherCell
        
        cell.configureCell(weatherForecast, indexPath.row, weatherConditions)
        
        if indexPath.row == 0 {
            
            cell.timeLabel.text = "Сейчас"
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 65, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

