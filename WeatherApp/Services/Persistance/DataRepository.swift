//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
    func getCurrentWeatherData(completion: @escaping (Result<CurrentForecastEntity, Error>) -> Void) {
        weatherApiService.fetchCurrentWeather(completion: { (result) in
            switch result {
            case .success(let currentWeatherResponse):
                self.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
                guard let currentWeatherEntity = self.coreDataService.loadCurrentForecastData() else { return }
                
                completion(.success(currentWeatherEntity))
                
            case .failure(_):
                guard let currentWeatherEntity = self.coreDataService.loadCurrentForecastData() else { return }
                
                completion(.success(currentWeatherEntity))
            }
        })
    }
    
    func getDailyWeather(latitude: Double, longitude: Double, completion: @escaping (Result<DailyForecastEntity, Error>) -> Void) {
        weatherApiService.fetchDailyWeather(with: latitude, longitude) { (result) in
            switch result {
            case .success(let dailyWeatherResponse):
                self.coreDataService.saveDailyForecast(dailyWeatherResponse)
                guard let dailyForecastEntity = self.coreDataService.loadDailyForecast(withCoordinates: dailyWeatherResponse.latitude, dailyWeatherResponse.longitude) else { return }
                
                completion(.success(dailyForecastEntity))
                
            case .failure(_):
                guard let dailyForecastEntity = self.coreDataService.loadDailyForecast(withCoordinates: latitude, longitude) else {
                    return
                }
                
                completion(.success(dailyForecastEntity))
            }
        }
    }
    
    func getHourlyWeather(city: String, completion: @escaping (Result<HourlyForecastEntity, Error>) -> Void) {
        weatherApiService.fetchHourlyWeather(for: city) { (result) in
            switch result {
            case .success(let hourlyWeather):
                self.coreDataService.saveHourlyForecast(hourlyWeather, city)
                guard let hourlyForecastEntity = self.coreDataService.loadHourlyForecast(forCity: city) else { return }
                
                completion(.success(hourlyForecastEntity))
                
            case .failure(_):
                guard let hourlyForecastEntity = self.coreDataService.loadHourlyForecast(forCity: city) else { return }
                
                completion(.success(hourlyForecastEntity))
            }
        }
    }
    
}
