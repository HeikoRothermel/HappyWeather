//
//  Structure.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/4/22.
//

import Foundation

// data structure from OpenWeather
struct WeatherResponse: Codable {

    let timezone: String
    let daily: [Daily]
    let current: Current
    let hourly: [Hourly]

}

struct Hourly: Codable {
    
    var temp: Float
    var feels_like: Float
    let dt: Int
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]
}





struct Current: Codable {
    
    let temp: Float
    struct Weather: Codable {
        let main: String
    }
    let weather: [Weather]

}





struct Daily: Codable {
    let dt: Int

    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moon_phase: Float
    struct Temp: Codable {
        let day: Float
        let min: Float
        let max: Float
        let night: Float
        let eve: Float
        let morn: Float


    }
    let temp: Temp

    let pressure:Int
    let humidity: Int
    let dew_point: Float
    let wind_speed: Float
    let wind_deg: Int
    let wind_gust: Float
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    let weather: [Weather]

    let clouds: Int
    let pop: Float
    let uvi: Float
}

