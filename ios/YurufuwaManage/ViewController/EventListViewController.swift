//
//  SettingEventViewController.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/05.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import UIKit
import JGProgressHUD

class EventListViewController: UIViewController {

    var events: [Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    static func create() -> EventListViewController {
        return UIStoryboard.init(name: "EventList", bundle: nil).instantiateInitialViewController() as! EventListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        getEvents { events in
            self.events = events
            DispatchQueue.main.async {
                hud.dismiss()
                self.tableView.reloadData()
            }
        }
    }
    
    private func getEvents(completion: @escaping ([Event]) -> Void) {
        API.Events.getEvents().response { result in
            switch result {
            case let .response(events):
                print(events)
                completion(events)
            case let .error(error):
                print(error)
                completion([])
            }
        }
    }
}

extension EventListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        let event = events[indexPath.row]
        cell.nameLabel.text = event.title
        cell.dateLabel.text = event.date
        cell.placeLabel.text = "@\(event.place ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        UserDefaults.standard.setValue(event.id, forKey: "eventID")
        navigationController?.pushViewController(EventDetailViewController.create(event: event), animated: true)
    }
}
