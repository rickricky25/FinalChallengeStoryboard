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
    
    struct BusModel: Codable {
        var idBus: Int
        var busOperator: String
        var busCode: String
        var route: String
        
    }
    
    struct ScheduleModel: Codable {
        var trip_id: Int
        var stop_id: Int
        var time_arrival: String
    }
    
    struct CommuteModel: Codable {
        var user_id: Int
        var stop_id: Int
        var longitude: Decimal
        var latitude: Decimal
        var status_check: String
    }
    
    struct ReminderModel: Codable {
        var user_id: Int
        var stop_id: Int
        var interval_start: String
        var interval_stop: String
        var time_before_arrival: Int
        var repeats: [String]
    }
    
    struct ReminderUpdateModel: Codable {
        var user_id: Int
        var stop_id: Int
        var interval_start: String
        var interval_stop: String
        var time_before_arrival: Int
        var repeats: [String]
        var reminder_id: Int
        var is_active: Bool
    }
    
    
    struct ReminderStatusModel: Codable {
        var reminder_id: Int
        var is_active: Bool
    }
    
    func getAllBus() {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/buses")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getStopsByID(bus_id: Int) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/stops/bus/\(bus_id)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getStopsByRoute(bus_id: Int, direction: String) {
           let url = URL(string: "https://server-fellowcity.herokuapp.com/api/stops/direction/\(bus_id)/\(direction)")
           guard let requestUrl = url else { fatalError() }
           // Create URL Request
           var request = URLRequest(url: requestUrl)
           // Specify HTTP Method to use
           request.httpMethod = "GET"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           // Send HTTP Request
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               // Check if Error took place
               if let error = error {
                   print("Error took place \(error)")
                   return
               }
               
               // Read HTTP Response Status code
               if let response = response as? HTTPURLResponse {
                   print("Response HTTP Status code: \(response.statusCode)")
               }
               
               // Convert HTTP Response Data to a simple String
               if let data = data, let dataString = String(data: data, encoding: .utf8) {
                   print("Response data string:\n \(dataString)")
               }
               
           }
           task.resume()
       }
    
    func getScheduleByStop(stop_id: Int) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/schedule/stop/\(stop_id)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getScheduleByTrip(trip_id: Int) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/schedule/trip/\(trip_id)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getAllSchedule() {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/schedule/all")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func updateSchedule(trip_id: Int, stop_id: Int, time_arrival: String) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/schedule/update")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let newSchedule = ScheduleModel(trip_id: trip_id, stop_id: stop_id, time_arrival: "\(time_arrival)")
        let jsonData = try! JSONEncoder().encode(newSchedule)
        request.httpBody = jsonData
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func addCommute(user_id: Int, stop_id: Int, longitude: Decimal, latitude: Decimal, status_check: String) {
           let url = URL(string: "https://server-fellowcity.herokuapp.com/api/commute")
           guard let requestUrl = url else { fatalError() }
           // Create URL Request
           var request = URLRequest(url: requestUrl)
           // Specify HTTP Method to use
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           let newCommute = CommuteModel(user_id: user_id, stop_id: stop_id, longitude: longitude, latitude: latitude, status_check: "\(status_check)")
           let jsonData = try! JSONEncoder().encode(newCommute)
           request.httpBody = jsonData
           // Send HTTP Request
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               // Check if Error took place
               if let error = error {
                   print("Error took place \(error)")
                   return
               }
               
               // Read HTTP Response Status code
               if let response = response as? HTTPURLResponse {
                   print("Response HTTP Status code: \(response.statusCode)")
               }
               
               // Convert HTTP Response Data to a simple String
               if let data = data, let dataString = String(data: data, encoding: .utf8) {
                   print("Response data string:\n \(dataString)")
               }
               
           }
           task.resume()
       }
    
    func addReminder(user_id: Int, stop_id: Int, interval_start: String, interval_stop: String, time_before_arrival: Int, repeats: [String]) {
              let url = URL(string: "https://server-fellowcity.herokuapp.com/api/reminder/add")
              guard let requestUrl = url else { fatalError() }
              // Create URL Request
              var request = URLRequest(url: requestUrl)
              // Specify HTTP Method to use
              request.httpMethod = "POST"
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              let newReminder = ReminderModel(user_id: user_id, stop_id: stop_id, interval_start: interval_start, interval_stop: interval_stop, time_before_arrival: time_before_arrival, repeats: repeats)
              let jsonData = try! JSONEncoder().encode(newReminder)
              request.httpBody = jsonData
              // Send HTTP Request
              let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                  
                  // Check if Error took place
                  if let error = error {
                      print("Error took place \(error)")
                      return
                  }
                  
                  // Read HTTP Response Status code
                  if let response = response as? HTTPURLResponse {
                      print("Response HTTP Status code: \(response.statusCode)")
                  }
                  
                  // Convert HTTP Response Data to a simple String
                  if let data = data, let dataString = String(data: data, encoding: .utf8) {
                      print("Response data string:\n \(dataString)")
                  }
                  
              }
              task.resume()
          }
    
    func updateReminder(reminder_id: Int, user_id: Int, stop_id: Int, interval_start: String, interval_stop: String, time_before_arrival: Int, repeats: [String], is_active: Bool) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/reminder/update")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let newReminder = ReminderUpdateModel(user_id: user_id, stop_id: stop_id, interval_start: interval_start, interval_stop: interval_stop, time_before_arrival: time_before_arrival, repeats: repeats, reminder_id: reminder_id, is_active: is_active)
        let jsonData = try! JSONEncoder().encode(newReminder)
        request.httpBody = jsonData
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func updateReminderActive(reminder_id: Int, is_active: Bool) {
           let url = URL(string: "https://server-fellowcity.herokuapp.com/api/reminder/update-active")
           guard let requestUrl = url else { fatalError() }
           // Create URL Request
           var request = URLRequest(url: requestUrl)
           // Specify HTTP Method to use
           request.httpMethod = "PUT"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           let newReminder = ReminderStatusModel(reminder_id: reminder_id, is_active: is_active)
           let jsonData = try! JSONEncoder().encode(newReminder)
           request.httpBody = jsonData
           // Send HTTP Request
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
               // Check if Error took place
               if let error = error {
                   print("Error took place \(error)")
                   return
               }
               
               // Read HTTP Response Status code
               if let response = response as? HTTPURLResponse {
                   print("Response HTTP Status code: \(response.statusCode)")
               }
               
               // Convert HTTP Response Data to a simple String
               if let data = data, let dataString = String(data: data, encoding: .utf8) {
                   print("Response data string:\n \(dataString)")
               }
               
           }
           task.resume()
       }
    
    func getReminderByUser(user_id: Int) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/reminder/user/\(user_id)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getReminderByItem(reminder_id: Int) {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/reminder/item/\(reminder_id)")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func saveUser(deviceToken: String) {
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        //advertisingIdentifier
       
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
    
    func getTokenByUuid(uuid: String) {
          let url = URL(string: "https://server-fellowcity.herokuapp.com/api/user-token/\(uuid)")
          guard let requestUrl = url else { fatalError() }
          // Create URL Request
          var request = URLRequest(url: requestUrl)
          // Specify HTTP Method to use
          request.httpMethod = "GET"
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          // Send HTTP Request
          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              
              // Check if Error took place
              if let error = error {
                  print("Error took place \(error)")
                  return
              }
              
              // Read HTTP Response Status code
              if let response = response as? HTTPURLResponse {
                  print("Response HTTP Status code: \(response.statusCode)")
              }
              
              // Convert HTTP Response Data to a simple String
              if let data = data, let dataString = String(data: data, encoding: .utf8) {
                  print("Response data string:\n \(dataString)")
              }
              
          }
          task.resume()
      }
    
    func getListRoutes() {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/routes")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func getAllStops() {
        let url = URL(string: "https://server-fellowcity.herokuapp.com/api/stops/all")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
}
