//
//  ViewController.swift
//  YurufuwaManage
//
//  Created by Minami Baba on 2018/07/02.
//  Copyright © 2018年 Minami Baba. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var player: Player?
    
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var statusChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
        reloadInfo()
    }
    
    func prepareCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let devices = discoverySession.devices
        
        guard let backCamera = devices.first else {
            return
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: backCamera)
            let metadataOutput = AVCaptureMetadataOutput()
            
            if self.session.canAddInput(deviceInput) && self.session.canAddOutput(metadataOutput) {
                self.session.addInput(deviceInput)
                self.session.addOutput(metadataOutput)
                        
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                        
                previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.frame = self.view.bounds
                previewLayer.videoGravity = .resizeAspectFill
            }
        } catch {
            print("Error occured while creating video device input: \(error)")
        }
    }
    
    func reloadInfo() {
        playerView.isHidden = (player == nil)
        uuidLabel.text = player?.uuid
        nameLabel.text = player?.name
        companyLabel.text = player?.company
        statusLabel.text = player?.status
        
        switch player?.status {
        case "none":
            statusChangeButton.isHidden = false
            statusChangeButton.setTitle("change to Active", for: .normal)
        case "active":
            statusChangeButton.isHidden = false
            statusChangeButton.setTitle("change to Finish", for: .normal)
        case "finish":
            statusChangeButton.isHidden = true
        default:
            statusChangeButton.isHidden = true
            break
        }
    }
    
    @IBAction func didTapLoadButton(_ sender: Any) {
        self.view.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    @IBAction func didTapStatusChangeButton(_ sender: Any) {
        guard let status = player?.status, let uuid = player?.uuid else { return }
        switch status {
        case "none":
            updatePlayerStatus(uuid: uuid, status: "active")
        case "active":
            updatePlayerStatus(uuid: uuid, status: "finish")
        default:
            break
        }
    }
    
    private func getPlayerInfo(uuid: String, completion: @escaping () -> Void) {
        API.Players.getPlayer(uuid: uuid).response { result in
            switch result {
            case let .response(player):
                print("Player=\(player)")
                self.player = player
                completion()
            case let .error(error):
                print("Error=\(error)")
            }
        }
    }
    
    private func updatePlayerStatus(uuid: String, status: String) {
        API.Players.getToken().response { result in
            switch result {
            case let .response(token):
                API.Players.updatePlayer(uuid: uuid, status: status, token: token).response { result in
                    switch result {
                    case let .response(statusCode):
                        self.getPlayerInfo(uuid: uuid, completion: {
                            DispatchQueue.main.async {
                                self.reloadInfo()
                            }
                        })
                        print("StatusCode=\(statusCode)")
                    case let .error(error):
                        print("Error=\(error)")
                    }
                }
            case let .error(error):
                print("Error=\(error)")
            }
        }
    }
}


extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let uuid = metadata.stringValue, metadata.type == .qr else {
                continue
            }
          
            getPlayerInfo(uuid: uuid) {
                DispatchQueue.main.async {
                    self.reloadInfo()
                }
            }
            
            session.stopRunning()
            previewLayer.removeFromSuperlayer()
        }
    }
}

