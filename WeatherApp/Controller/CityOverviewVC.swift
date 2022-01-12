//
//  CityOverviewVC.swift
//  WeatherApp
//
//  Created by Oleh Falalieiev on 27.12.2021.
//

import UIKit
import CoreLocation
import GooglePlaces

class CityOverviewVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var urlArray: [String] = []
    private var citiesArray: [String] = []
    private let defaults = UserDefaults.standard
    private var weatherManager = WeatherManager()
    private var minTemp: [Double] = []
    private var maxTemp: [Double] = []
    private var currentPlace: [String] = []
    private var currentTime: [String] = []
    private var currentDescription: [String] = []
    private var currentTemp: [Double] = []
    var delegate: CityOverviewDelegate?
    var user = UserDefaultsModel.shared
    private let url = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=3d4c8200225ab2d654954da00a1d1907&lang=ru&units=metric"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        urlArray = defaults.array(forKey: "urls") as? [String] ?? []
        citiesArray = defaults.array(forKey: "cities") as? [String] ?? []
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        getWeather()
        
        backgroundImage.image = UIImage(named: "background")?.resizeImage(targetSize: backgroundImage.bounds.size)
        
        setupContextMenu()
    }
    
    func getWeather() {
        
        if urlArray.isEmpty == false {
            
            for url in urlArray {
                
                weatherManager.fetchWeather(with: url)
            }
        }
    }
    
    func getWeather1(url1: String) {
        
        weatherManager.fetchWeather(with: url1)
        
    }
    
    
    @IBAction func addCityButtonPressed(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autoCompleteController.autocompleteFilter = filter
        present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return urlArray.count
        
    }
    
    func setupContextMenu() {
        let menuItems: [UIAction] = [
            UIAction(title: "Градусы Цельсия", image: UIImage(named: "celsius")?.withTintColor(UIColor(named: "degreeColor")!), handler: { (_) in
                
                self.user.degrees = 0
                self.delegate?.updateDegrees()
                
                self.tableView.reloadData()
            }),
            UIAction(title: "Градусы Фаренгейта", image: UIImage(named: "fahrenheit")?.withTintColor(UIColor(named: "degreeColor")!), handler: { (_) in
                
                self.user.degrees = 1
                self.delegate?.updateDegrees()
                
                self.tableView.reloadData()
                
            })
        ]
        
        if user.degrees == 1 {
            menuItems[1].state = .on
        } else {
            menuItems[0].state = .on
        }
        
        let settingsMenu: UIMenu = UIMenu(title: "", image: nil, identifier: nil, options: [.singleSelection], children: menuItems)
        settingsButton.menu = settingsMenu
    }
    
}

//MARK: - WeatherManagerDelegate

extension CityOverviewVC: WeatherManagerDelegate {
    
    func setWeather(with weather: WeatherForecast) {
        
        minTemp.append(weather.dailyForecast.minTemperature[0])
        maxTemp.append(weather.dailyForecast.maxTemperature[0])
        currentTime.append(weather.currentForecast.time.getData(weather.currentForecast.timezoneOffset, "HH:mm"))
        currentDescription.append((weather.currentForecast.description?.capitalizingFirstLetter())!)
        currentTemp.append(weather.currentForecast.temperature)
        
    }
    
}

//MARK: - TableView

extension CityOverviewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .destructive, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.urlArray.remove(at: indexPath.row)
            self.defaults.set(self.urlArray, forKey: "urls")
            
            self.citiesArray.remove(at: indexPath.row)
            self.defaults.set(self.citiesArray, forKey: "cities")
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            success(true)
            
        })
        
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        if UserDefaultsModel.shared.degrees == 1 {
            
            cell.minMaxTemp.text = "\(maxTemp[indexPath.row].convertToFahrenheit().getTemp("Макс: "))  \(minTemp[indexPath.row].convertToFahrenheit().getTemp("Мин: "))"
            cell.currentTempLabel.text = currentTemp[indexPath.row].convertToFahrenheit().getTemp("")
            
        } else {
            
            cell.minMaxTemp.text = "\(maxTemp[indexPath.row].getTemp("Макс: "))  \(minTemp[indexPath.row].getTemp("Мин: "))"
            cell.currentTempLabel.text = currentTemp[indexPath.row].getTemp("")
            
        }
        
        cell.currentPlaceLabel.text = citiesArray[indexPath.row]
        cell.descriptionLabel.text = currentDescription[indexPath.row]
        cell.currentTime.text = currentTime[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        delegate?.passUrl(urlArray[indexPath.row], citiesArray[indexPath.row])
        
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate

extension CityOverviewVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        
        let urlWithCoordinates = "\(url)&lat=\(lat)&lon=\(lon)"
        urlArray.append(urlWithCoordinates)
        defaults.set(urlArray, forKey: "urls")
        
        if let city = place.name {
            citiesArray.append(city)
            defaults.set(citiesArray, forKey: "cities")
        }
        
        weatherManager.fetchWeather(with: urlWithCoordinates)
        
        DispatchQueue.main.async {
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.urlArray.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
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
