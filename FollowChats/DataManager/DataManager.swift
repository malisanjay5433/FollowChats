//
//  DataManager.swift
//  FollowChats
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//
import Foundation
public final class DataManager {
    public static func getJSON(_ api:String,param:[String:[String:String]],completion:@escaping (_ data:Data?, _ error:Error?) -> Void){
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string:api) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonBody = try JSONEncoder().encode(param)
                request.httpBody = jsonBody
            } catch {
                print("Something went wrong")
            }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    if let er  = error  {
                        print("error = \(er.localizedDescription)")
                    }
                    
                    guard let mdata = data else {
                        return
                    }
                    completion(data,nil)
                }
                catch{
                    print(error)
                }
                }.resume()
            
            
        }
    }    
    
}
