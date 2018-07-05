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
    class Util: Requestable {
        static var baseURL: String {
            return UserDefaults.standard.string(forKey: "baseURL") ?? ""
        }
        
        static var path: String {
            return "/api/check/"
        }
        
        class func check() -> Task<String, Error> {
            let task = Task<String, Error> { result in
                guard let url = URL(string: baseURL + path) else {
                    return
                }
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                            result(.error(ResponseError.unexceptedResponse(error as AnyObject)))
                            return
                    }
                    result(.response("ok"))
                })
                session.resume()
            }
            return task
        }
    }
}

