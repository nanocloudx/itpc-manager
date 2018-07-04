//
//  Player.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/02.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import Foundation

enum PlayerStatus: String {
    case playing = "playing"
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
        self.uuid = json["id"] ?? ""
        self.name = json["name"] ?? ""
        self.company = json["organization"] ?? ""
        if let status = json["status"] {
            self.status = PlayerStatus(rawValue: status ?? "")
        }
    }
    
    static func getPlayers(json: [[String: String?]]) -> [Player] {
        var players: [Player] = []
        for j in json {
            players.append(Player.init(json: j))
        }
        return players
    }
    
    static func getStatusString(status: PlayerStatus) -> String {
        switch status {
        case .playing:
            return "参加中"
        case .finish:
            return "終了"
        case .none:
            return "未参加"
        }
    }
}
