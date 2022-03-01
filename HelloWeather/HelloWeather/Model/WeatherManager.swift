//
//  WeatherManager.swift
//  HelloWeather
//
//  Created by herongjin on 2022/3/1.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

// 基于高德地图api https://lbs.amap.com/api/webservice/guide/api/georegeo
struct WeatherManager {
    let geoCodeURL = "https://restapi.amap.com/v3/geocode/regeo"
    let weatherURL = "https://restapi.amap.com/v3/weather/weatherInfo"
    let key = "1dee7505fbf7c25a88c0f9914d8896d6"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        requestAdcode(latitude: latitude, longitude: longitude) { adcode in
            self.requestWeather(adcode: adcode)
        }
    }
    
    // get adcode from
    func requestAdcode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, complition: @escaping(String) -> Void) {
        let params = [
            "key": key,
            "location": "\(longitude), \(latitude)"
        ]
        
        AF.request(geoCodeURL, parameters: params).responseData { response in
            switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    if let jsonData = try? JSON(data: data) {
                        complition(jsonData["regeocode"]["addressComponent"]["adcode"].stringValue)
                    }
                case let .failure(error):
                    self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    // get weather
    func requestWeather(adcode: String, extend: String = "base") {
        let params = [
            "key": key,
            "city": adcode,
            "extensions": extend
        ]
        
        AF.request(weatherURL, parameters: params).responseDecodable(of: WeatherModel.self) { response in
            switch response.result {
                case let .success(weather):
                    self.delegate?.didUpdateWeather(self, weather: weather)
                case let .failure(error):
                    self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
}
