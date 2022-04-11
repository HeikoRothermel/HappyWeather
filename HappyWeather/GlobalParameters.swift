//
//  GlobalParameters.swift
//  HappyWeather
//
//  Created by Heiko Rothermel on 4/5/22.
//

import Foundation


var long = Double()
var lat = Double()
var urlToUse = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=48.14&lon=11.57&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b")


var factorHeight = Float()
var factorWidth = Float()

var dictEventsNoted = [Int: String]()
var arrayTimes = [Int]()


typealias MultipleValue = (temp: Float, main: String)
var dictWeatherForEvents = [Int: MultipleValue]()

var shownCities = ["Munich", "Berlin", "Hamburg", "+"]







var arrayTemp = [Float]()
var arrayMain = [String]()
var arrayInfo = [String]()

var savingArray = [[]]



var dictForSavings = [String: String]()


