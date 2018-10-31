//
//  Utils.swift
//  GeoSparkExample
//
//  Created by GeoSpark Mac #1 on 31/10/18.
//  Copyright © 2018 Geospark Inc. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func currentTimestamp() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    static func saveLocationToLocal(_ latitude : Double, longitude : Double) {
        let dataDictionary = ["latitude" : latitude, "longitude" : longitude,"timeStamp" : Utils.currentTimestamp(),] as [String : Any]
        var dataArray = UserDefaults.standard.array(forKey: "GeoSparkKeyForLatLongInfo")
        if let _ = dataArray {
            dataArray?.append(dataDictionary)
        }else{
            dataArray = [dataDictionary]
        }
        UserDefaults.standard.set(dataArray, forKey: "GeoSparkKeyForLatLongInfo")
        UserDefaults.standard.synchronize()
    }

    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != "DeviceToken"{
                defaults.removeObject(forKey: key)
            }
        }
    }

}
