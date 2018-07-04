//
//  Player.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/02.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation

enum PlayerStatus: String {
    case active = "playing"
    case finish = "finish"
    case none = "none"
}

struct Player {
    
    var uuid: String?
    var name: String?
    var company: String?
    var status: PlayerStatus?
    
    init(uuid: String, name: String, company: String, status: String) {
        self.uuid = uuid
        self.name = name
        self.company = company
        self.status = PlayerStatus(rawValue: status)
    }
    
    init(json: [String: String?]) {
        print(json)
        self.uuid = json["id"]!
        self.name = json["name"]!
        self.company = json["organization"]!
        self.status = PlayerStatus(rawValue: json["status"]!!)
    }
}
