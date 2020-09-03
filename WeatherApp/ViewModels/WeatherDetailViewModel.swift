//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private var dataRepository: DataRepository
    var currentWeather: CurrentWeather
    var weeklyWeather: WeeklyWeather
    
    var date: String {
        Utils.getFormattedDate()
    }
    
    var time: String {
        Utils.getFormattedTime()
    }
    
    init(appDependencies: AppDependencies, currentWeather: CurrentWeather, coordinator: Coordinator) {
        self.currentWeather = currentWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
        self.dataRepository = appDependencies.dataRepository
        self.weeklyWeather = WeeklyWeather(city: currentWeather.city, dailyWeatherList: [], hourlyWeatherList: [])
    }
    
    func getWeeklyWeather(completion: @escaping (Result<Bool, Error>) -> Void) {
        locationService.getLocationCoordinates(location: currentWeather.city) { (latitude, longitude ) in
            self.dataRepository.getWeeklyWeather(latitude: latitude, longitude: longitude) { (result) in
                switch result {
                case .success(let weeklyForecastEntity):
                    self.saveToWeeklyWeather(with: weeklyForecastEntity)
                    
                    completion(.success(true))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveToWeeklyWeather(with weeklyForecastEntity: WeeklyForecastEntity) {
        let dailyList = weeklyForecastEntity.dailyWeather.map { DailyWeather(from: $0 as! DailyWeatherEntity) }
        weeklyWeather.dailyWeatherList.append(contentsOf: dailyList)
        
        let hourlyList = weeklyForecastEntity.hourlyWeather.map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
        weeklyWeather.hourlyWeatherList.append(contentsOf: hourlyList)
        
        weeklyWeather.dailyWeatherList.sort { $0.dateTime < $1.dateTime }
        weeklyWeather.hourlyWeatherList.sort { $0.dateTime < $1.dateTime }
    }
    
}
