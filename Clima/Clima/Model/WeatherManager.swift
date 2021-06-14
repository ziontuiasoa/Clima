//
//  WeatherManager.swift
//  Clima
//
//  Created by Zion Tuiasoa on 12/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
// MARK: NETWORKING
//    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=181380c76c9567899fdb7cef3abf9245&units=imperial"
    var baseURL = "https://api.openweathermap.org"
    var dataVersion = DataVersion.current.urlValue
    var appID = "/weather?appid=181380c76c9567899fdb7cef3abf9245"
    var weatherFormat = WeatherFormat.imperial.urlValue
    
    var delegate: WeatherManagerDelegate?
    
    enum WeatherFormat: String {
        case imperial = "imperial"
        case metric = "metric"
        
        var urlValue: String {
            return "&units=\(self.rawValue)"
        }
    }
    
    enum DataVersion: Double {
        case early = 1.2
        case current = 2.5
        case beta = 3.1
        
        var urlValue: String {
            return "/data/\(self.rawValue)"
        }
    }
    
    func getWeather(cityName: String) {
        let weatherURL = baseURL + dataVersion + appID + weatherFormat
        let weatherURLString = "\(weatherURL)&q=\(cityName)"
        
        requestWeather(with: weatherURLString)
    }
    
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let weatherURL = baseURL + dataVersion
        let weatherURLString = "\(weatherURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=181380c76c9567899fdb7cef3abf9245" + weatherFormat
        
        requestWeather(with: weatherURLString)
    }
    
    func requestWeather(with weatherURLString: String) {
        
        // Create Weather URL
        guard let weatherURL = URL(string: weatherURLString) else {
            print("Couldn't create URL from dat string")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: weatherURL) { (weatherData, resonse, error) in
            
            if let unwrappedError = error {
                delegate?.didFailWithError(error: unwrappedError)
                return
            }
            
            guard let unwrappedWeatherData = weatherData else {
                print("Weather Data is nil")
                return
            }
            
            guard let currentWeatherUpdate = self.parseJSON(unwrappedWeatherData) else {
                print("Couldn't get weather from JSON")
                return
            }
        
            delegate?.didUpdateWeather(self, weather: currentWeatherUpdate)
        }
        
        task.resume()
    }
    
    // Parse the data into a Swift Object
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            let id = decodedData.weather[0].id
            let temp =  decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            print(weather.temperatureString)
            return weather
            
        } catch let weatherError {
            delegate?.didFailWithError(error: weatherError)
            return nil
        }
    }
}
