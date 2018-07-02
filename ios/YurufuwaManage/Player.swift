//
//  Player.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/02.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation

struct Player {
    var uuid: String?
    var name: String?
    var company: String?
    var status: String?
    
    init(uuid: String, name: String, company: String, status: String) {
        self.uuid = uuid
        self.name = name
        self.company = company
        self.status = status
    }
    
    init(json: [String: String]) {
        self.uuid = json["id"]
        self.name = json["name"]
        self.company = json["organization"]
        self.status = json["status"]
    }
}
