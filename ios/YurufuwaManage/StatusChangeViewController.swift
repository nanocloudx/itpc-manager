//
//  StatusChangeViewController.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/04.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import UIKit

class StatusChangeViewController: UIViewController {

    var player: Player!
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    static func create(player: Player) -> StatusChangeViewController {
        let vc = UIStoryboard.init(name: "StatusChange", bundle: nil).instantiateInitialViewController() as! StatusChangeViewController
        vc.player = player
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        organizationLabel.text = player.company
        nameLabel.text = player.name
        
        switch player.status! {
        case .active:
            statusLabel.text = "参加中"
            activateButton.alpha = 0.2
            activateButton.isEnabled = false
        case .finish:
            statusLabel.text = "終了"
            finishButton.alpha = 0.2
            finishButton.isEnabled = false
        case .none:
            statusLabel.text = "未参加"
            cancelButton.alpha = 0.2
            cancelButton.isEnabled = false
        }
    }

    @IBAction func didTapActivateButton(_ sender: Any) {
        updatePlayerStatus(uuid: player.uuid!, status: PlayerStatus.active.rawValue) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapFinishButton(_ sender: Any) {
        updatePlayerStatus(uuid: player.uuid!, status: PlayerStatus.finish.rawValue) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        updatePlayerStatus(uuid: player.uuid!, status: PlayerStatus.none.rawValue) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func updatePlayerStatus(uuid: String, status: String, completion: @escaping () -> Void) {
        API.Players.updatePlayer(uuid: uuid, status: status).response { result in
            switch result {
            case let .response(statusCode):
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    completion()
                }
            case let .error(error):
                print("Error=\(error)")
            }
        }
    }

}
