//
//  Structure.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/4/22.
//

import Foundation


struct WeatherResponse: Codable {

//
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
    let clouds: Int
    let wind_gust: Float
    let pop: Float
    let uvi: Float
    struct Temp: Codable {

        let eve: Float
        let morn: Float
        let max: Float
        let min: Float

    }
    let temp: Temp

    struct Weather: Codable {

        let main: String

    }
    let weather: [Weather]

}
