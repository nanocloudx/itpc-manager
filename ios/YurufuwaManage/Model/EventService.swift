//
//  EventService.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/06.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation
import Gryphon

extension API {
    
    final class Events: Requestable {
        static var baseURL: String {
            return UserDefaults.standard.string(forKey: "baseURL") ?? ""
        }
        
        static var path: String {
            return "/api/events/"
        }
        
        class func getEvents() -> Task<[Event], Error> {
            let task = Task<[Event], Error> { result in
                guard let url = URL(string: baseURL + path) else {
                    return
                }
                
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let events = json as? [[String: String?]] else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(Event.getEvents(json: events)))
                })
                session.resume()
            }
            return task
        }
    }
}
