//
//  PlayerService.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/05.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation
import Gryphon

extension API {
    final class Players: Requestable {
        static var baseURL: String {
            return UserDefaults.standard.string(forKey: "baseURL") ?? ""
        }
        
        static var path: String {
            let eventID = UserDefaults.standard.string(forKey: "eventID") ?? ""
            return "/api/events/\(eventID)/entries/"
        }
        
        class func getPlayers() -> Task<[Player], Error> {
            let task = Task<[Player], Error> { result in
                guard let url = URL(string: baseURL + path) else {
                    return
                }
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let players = json as? [[String: Any?]] else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(Player.getPlayers(json: players)))
                })
                session.resume()
            }
            return task
        }
        
        class func getPlayer(uuid: String) -> Task<Player, Error> {
            let task = Task<Player, Error> { result in
                guard let url = URL(string: baseURL + path + uuid) else {
                    return
                }
                print(url)
                var request = URLRequest(url: url)
                print(url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let player = json as? [String: String?] else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response(Player.init(json: player)))
                })
                session.resume()
            }
            return task
        }
        
        class func updatePlayer(uuid: String, status: String) -> Task<Int, Error> {
            let task = Task<Int, Error> { result in
                guard let url = URL(string: baseURL + path + uuid + "/" + status) else {
                    return
                }
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
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
