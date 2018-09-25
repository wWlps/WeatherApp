//
//  ViewController.swift
//  WeatherApp
//
//  Created by Артем Писаренко on 27.06.2018.
//  Copyright © 2018 Артем Писаренко. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    @IBOutlet weak var activitiIndicater: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager ()
    
    
    func toggActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activitiIndicater.startAnimating()
        } else{
            activitiIndicater.stopAnimating()
        }
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "a668c2449da9259682286150469dd6fe")
    let coordinates = Coordinates(latitude: 47.225338, longitude: 39.676133)
    //latitude: 25.755435, longitude: 37.609549
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.stopUpdatingLocation()
    
        getCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        print("my location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
    
    func getCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            self.toggActivityIndicator(on: false)
            switch result {
            case .Success(let currentWether):
                self.updateUIWith(currentWeather: currentWether)
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
        self.humidityLabel.text = currentWeather.humidityString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

