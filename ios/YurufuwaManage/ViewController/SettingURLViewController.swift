//
//  SettingURLViewController.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/05.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import UIKit
import JGProgressHUD

class SettingURLViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    static func create() -> SettingURLViewController {
        return UIStoryboard.init(name: "SettingURL", bundle: nil).instantiateInitialViewController() as! SettingURLViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.becomeFirstResponder()
        urlTextField.text = UserDefaults.standard.string(forKey: "baseURL")
    }
    
    @IBAction func didTapConnectButton(_ sender: Any) {
        UserDefaults.standard.setValue(urlTextField.text, forKeyPath: "baseURL")
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        checkURL {
            DispatchQueue.main.async {
                hud.dismiss()
                self.navigationController?.pushViewController(EventListViewController.create(), animated: true)
            }
        }
    }
    
    private func checkURL(completion: @escaping () -> Void) {
        API.Util.check().response { result in
            switch result {
            case .response(_):
                completion()
            case let .error(error):
                print(error)
            }
        }
    }
    
}
