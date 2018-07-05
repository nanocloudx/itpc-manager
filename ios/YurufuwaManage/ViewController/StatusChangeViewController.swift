//
//  StatusChangeViewController.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/04.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import UIKit
import JGProgressHUD

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
        
        statusLabel.text = Player.getStatusString(status: player.status)
        
        switch player.status {
        case .playing:
            activateButton.alpha = 0.2
            activateButton.isEnabled = false
        case .finish:
            finishButton.alpha = 0.2
            finishButton.isEnabled = false
        case .none:
            cancelButton.alpha = 0.2
            cancelButton.isEnabled = false
        case .some(_):
            break
        }
    }

    @IBAction func didTapActivateButton(_ sender: Any) {
        callUpdatePlayerStatus(status: PlayerStatus.playing.rawValue)
    }
    
    @IBAction func didTapFinishButton(_ sender: Any) {
        callUpdatePlayerStatus(status: PlayerStatus.finish.rawValue)
    }
    
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        callUpdatePlayerStatus(status: PlayerStatus.none.rawValue)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    private func callUpdatePlayerStatus(status: String) {
        guard let uuid = player.uuid else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        updatePlayerStatus(uuid: uuid, status: status) { success in
            hud.dismiss()
            if success {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayerTableViewReload"), object: nil)
                }
            }
        }
    }
    
    private func updatePlayerStatus(uuid: String, status: String, completion: @escaping (Bool) -> Void) {
        API.Players.updatePlayer(uuid: uuid, status: status).response { result in
            switch result {
            case let .response(statusCode):
                print(statusCode)
                completion(true)
            case let .error(error):
                print(error)
                completion(false)
            }
        }
    }

}
