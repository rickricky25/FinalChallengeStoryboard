//
//  API.swift
//  BussMeStoryboard
//
//  Created by Khairani Ummah on 15/12/19.
//  Copyright © 2019 Ricky Effendi. All rights reserved.
//

import Foundation
import UIKit


class API {
    struct bus {
        let a: String
        
    }
    
    struct UserModel: Codable {
        var uuid: String
        var token_id: String
        var name: String
        
    }
    
    func getBus() {
        //apa
    }
    
    func saveUser(deviceToken: String) {
            let uuid = UIDevice.current.identifierForVendor!.uuidString
            let url = URL(string: "https://server-fellowcity.herokuapp.com/api/user")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Header
            //        request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let newUser = UserModel(uuid: "\(uuid)", token_id: "\(deviceToken)", name: "Hello")
            let jsonData = try! JSONEncoder().encode(newUser)
            request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                         
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    guard let data = data else { return }
                    do {
                        let userModel = try JSONDecoder().decode(UserModel.self, from: data)
                        print(userModel)
                        print("Data:\n \(userModel)")
                        print("UUID: \(userModel.uuid)")
                        print("name: \(userModel.name)")
                    } catch let jsonErr {
                        print(jsonErr)
                   }
             
            }
            task.resume()
        }
}
