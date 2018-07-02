//
//  API.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/03.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation
import Gryphon

final class API {
}

extension API {
    final class Players: Requestable {
        
        static var baseURL: String {
            return "http://192.168.0.2:3000"
        }
        
        static var path: String {
            return "/api/event/31/players/"
        }
        
        class func getPlayers() -> Task<String, Error> {
            let task = Task<String, Error> { result in
                let url = URL(string: baseURL + path)!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject],
                        let players = json?[0]["result"] as? String else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(players))
                })
                session.resume()
            }
            return task
        }
        
        class func getPlayer(uuid: String) -> Task<Player, Error> {
            let task = Task<Player, Error> { result in
                let url = URL(string: baseURL + path + uuid)!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(Player.init(json: json!)))
                })
                session.resume()
            }
            return task
        }
        
        class func getToken() -> Task<String, Error> {
            let task = Task<String, Error> { result in
                let url = URL(string: baseURL + "/api/token")!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(json!["token"]!))
                })
                session.resume()
            }
            return task
        }
        
        
        //status : active/finish/cancel
        class func updatePlayer(uuid: String, status: String, token: String) -> Task<Int, Error> {
            let task = Task<Int, Error> { result in
                let url = URL(string: baseURL + path + uuid + "/" + status)!
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue(token, forHTTPHeaderField: "x-csrf-token")
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                    if 200...299 ~= statusCode {
                        result(.response(statusCode))
                    }else{
                        result(.error(ResponseError.unacceptableStatusCode(statusCode)))
                    }
                })
                session.resume()
            }
            return task
        }
    }
}
