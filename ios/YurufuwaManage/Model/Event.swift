//
//  Events.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/05.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation

struct Event {
    var id: String!
    var title: String!
    var date: String!
    var place: String!
    
    init(id:String, title: String, date: String, place: String) {
        self.id = id
        self.title = title
        self.date = date
        self.place = place
    }
    
    init(json: [String: String?]) {
        self.id = json["id"] ?? ""
        self.title = json["title"] ?? ""
        self.date = json["date"] ?? ""
        self.place = json["place"] ?? ""
    }
    
    static func getEvents(json: [[String: String?]]) -> [Event] {
        var events: [Event] = []
        for j in json {
            events.append(Event.init(json: j))
        }
        return events
    }
}
