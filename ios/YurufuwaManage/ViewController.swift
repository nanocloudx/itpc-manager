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
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var statusChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCamera()
    }
    
    func prepareCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video, position: .back)
        
        let devices = discoverySession.devices
        guard let backCamera = devices.first else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: backCamera)
            let metadataOutput = AVCaptureMetadataOutput()
            
            if self.session.canAddInput(deviceInput) && self.session.canAddOutput(metadataOutput) {
                self.session.addInput(deviceInput)
                self.session.addOutput(metadataOutput)
                        
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                        
                previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.frame = cameraView.bounds
                previewLayer.videoGravity = .resizeAspectFill
            }
        } catch {
            print("Error occured while creating video device input: \(error)")
        }
    }
    
    
    private func startCameraSession() {
        cameraView.isHidden = false
        cameraView.layer.insertSublayer(previewLayer, at: 0)
        session.startRunning()
    }
    
    private func stopCameraSession() {
        session.stopRunning()
        previewLayer.removeFromSuperlayer()
        cameraView.isHidden = true
    }
    
    private func getPlayerInfo(uuid: String, completion: @escaping (Player?) -> Void) {
        API.Players.getPlayer(uuid: uuid).response { result in
            switch result {
            case let .response(player):
                completion(player)
            case let .error(error):
                print(error)
                completion(nil)
            }
        }
    }
    
    @IBAction func didTapLoadButton(_ sender: Any) {
        startCameraSession()
    }
    
    @IBAction func didTapCameraCloseButton(_ sender: Any) {
        stopCameraSession()
    }
}


extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let uuid = metadata.stringValue, metadata.type == .qr else {
                continue
            }
            
            self.stopCameraSession()
            getPlayerInfo(uuid: uuid) { player in
                DispatchQueue.main.async {
                    self.stopCameraSession()
                    if let player = player {
                        self.present(StatusChangeViewController.create(player: player), animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

