//
//  GlobalParameters.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/5/22.
//

import Foundation

//used to get weather data
var long = Double()
var lat = Double()
var urlToUse = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=52.72&lon=13.41&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b")

//factors to nake sure that constraints fit for all models
var factorHeight = Float()
var factorWidth = Float()

//dicts/arrays to be used for Notes (from 24-Stunden-Vorschau to View Controller
var dictEventsNoted = [Int: String]()
var arrayTimes = [Int]()
typealias MultipleValue = (temp: Float, main: String)
var dictWeatherForEvents = [Int: MultipleValue]()

//Used to store data for next usage
var dictForSavings = [String: String]()
