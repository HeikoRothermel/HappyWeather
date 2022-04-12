//
//  GlobalParameters.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/5/22.
//

import Foundation


var long = Double()
var lat = Double()
var urlToUse = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=52.72&lon=13.41&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b")


var factorHeight = Float()
var factorWidth = Float()

var dictEventsNoted = [Int: String]()
var arrayTimes = [Int]()

typealias MultipleValue = (temp: Float, main: String)
var dictWeatherForEvents = [Int: MultipleValue]()

var dictForSavings = [String: String]()


