//
//  NetworkManager.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 4/1/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import Foundation

class NetworkManager {
    var endpointBaseUrl = URL(string: "nourl")!
    var usingNetwork = false
    
    init() {
        if (!usingNetwork) {
            return
        }
        var endpointBase = UserDefaults.standard.string(forKey: "endpoint")
        if endpointBase == nil {
            endpointBase = "http://traffictest.chrisbailey.io"
        }
        endpointBaseUrl = URL(string: endpointBase!)!
    }
    
    func pinValid(pin: String, callback: @escaping (_ result: Bool) -> ()) {
        if (!usingNetwork) {
            return
        }
        let url = endpointBaseUrl.appendingPathComponent("checkpin.php")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = ("pin=" + pin).data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded charset=utf-8", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) {(data, _response, error) in
            if error != nil {
                print(error.debugDescription)
                callback(false)
                return
            }
            let response = _response as! HTTPURLResponse
            print(response.statusCode)
            if response.statusCode == 200 {
                callback(true)
            } else {
                callback(false)
            }
        }.resume()
    }
    
    func uploadSession(session: Session, callback: @escaping (_ result: Bool) -> ()) {
        if (!usingNetwork) {
            return
        }
        let url = endpointBaseUrl.appendingPathComponent("upload.php")
        
        var payload: Data
        do {
            try payload = JSONEncoder().encode(session)
        } catch {
            callback(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload
        URLSession.shared.dataTask(with: request) {(data, _response, error) in
            if error != nil {
                print(error.debugDescription)
                callback(false)
                return
            }
            let response = _response as! HTTPURLResponse
            print(response.statusCode)
            if response.statusCode == 200 {
                callback(true)
            } else {
                callback(false)
            }
        }.resume()
    }
}
