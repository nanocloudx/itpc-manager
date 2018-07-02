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
                self.view.layer.addSublayer(previewLayer)
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
            statusChangeButton.setTitle("Join!!", for: .normal)
        case "join":
            statusChangeButton.isHidden = false
            statusChangeButton.setTitle("Finish!!", for: .normal)
        case "finish":
            statusChangeButton.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func didTapLoadButton(_ sender: Any) {
        session.startRunning()
    }
    
    @IBAction func didTapStatusChangeButton(_ sender: Any) {
        guard let status = player?.status, let uuid = player?.uuid else { return }
        switch status {
        case "none":
            updatePlayerStatus(uuid: uuid, status: "join")
        case "join":
            updatePlayerStatus(uuid: uuid, status: "finish")
        default:
            break
        }
    }
    
    private func getPlayerInfo(uuid: String) -> Player? {
        return Player.init(uuid: uuid, name: "馬場南実", company: "hogehoge", status: "join")
    }
    
    private func updatePlayerStatus(uuid: String, status: String) {
        print("\(uuid) update to \(status)")
    }
}


extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let uuid = metadata.stringValue, metadata.type == .qr else {
                continue
            }
          
            self.player = getPlayerInfo(uuid: uuid)
            reloadInfo()
            
            session.stopRunning()
            previewLayer.removeFromSuperlayer()
        }
    }
}

