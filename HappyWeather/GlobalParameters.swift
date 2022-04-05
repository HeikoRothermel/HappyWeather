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

var dict = [Int: String]()
var arrayTimes = [Int]()
//typealias MultipleValue = (firstObject: String, secondObject: String)
//var dict2 = [Int: MultipleValue]()
//dict2[1] = MultipleValue(firstObject: "Hausaufgaben", secondObject: "Sport")
//var value = dict2[1]
//print value?.firstObject
