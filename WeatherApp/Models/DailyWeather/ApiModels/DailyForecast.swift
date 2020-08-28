//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct DailyForecast: Decodable {
    
    let dateTime: Int
    let temperature: Temperature
    let weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "temp"
        case weather = "weather"
    }
    
}