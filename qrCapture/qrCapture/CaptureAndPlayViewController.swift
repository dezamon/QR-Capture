//
//  CaptureAndPlayViewController.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/04.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureAndPlayViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let captureView:UIView = UIView()
    let captureSession:AVCaptureSession = AVCaptureSession()
    let qrCodeView:UIView = UIView()

    var videoLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.green
        
        // タブバーの色などを初期化します
        initializeTabBar()
        
        // カメラのプレビュー用のビューを作成
        createCaptureView()
        
        // QRコードをマークするビューを作成
        createQRMarker()
        
        // カメラなどの設定をする
        cameraSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - CREATE ELEMENTS
extension CaptureAndPlayViewController {
    
    /**
     * createCaptureView()はQRコードを読み取るためのビューを作成します
     *
     */
    func createCaptureView(){
        
        // プレビュー用のプロパティ
        let width:CGFloat = self.view.bounds.width
        let height:CGFloat = 370
        
        // カメラのプレビューを表示するビューを作成
        captureView.backgroundColor = UIColor.brown
        _ = customSizeConstraint.view.defineSize(item: captureView, width: width, height: height)
        
        self.view.addSubview(captureView)
        _ = commonMarginConstraint(item1: captureView, item2: self.view, applyItem: self.view, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: captureView, item2: self.view, applyItem: self.view, attribute1: .top, attribute2: .top, constant: 0)
        
        self.view.layoutIfNeeded()
    }
    
    /**
     * createQRMarker()はQRコードをマーキングするビューを作成します
     *
     */
    func createQRMarker(){
        // QRコードをマークするビュー
         qrCodeView.layer.borderWidth = 4
         qrCodeView.layer.borderColor = UIColor.red.cgColor
         qrCodeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
         self.view.addSubview(qrCodeView)
    }
}

// MARK: - FUNCTIONS
extension CaptureAndPlayViewController {
    
    /**
     * cameraSetting()はカメラやデリゲートの設定を行います
     *
     */
    func cameraSetting(){
        
        // 入力用（背面カメラ）
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)
        
        // 出力（メタデータ）
        let metadataOutput:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        // QRコードを検出した歳のデリゲートの設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // QRコードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // プレビューを表示
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer?.frame = self.captureView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureView.layer.addSublayer(videoLayer!)
        
        // セッション開始
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
    }
}

// MARK: - DELEGATE
extension CaptureAndPlayViewController {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // 複数のメタデータを検出
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかを認識
            if metadata.type == AVMetadataObjectTypeQRCode {
                // 検出位置を取得
                let barCode = videoLayer?.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                
                // 取得した位置をQRコードのマーカーに反映
                qrCodeView.frame = barCode.bounds
                if metadata.stringValue != nil {
                    // 検出データを取得
                    print("got data: \(metadata.stringValue!)")
                }
            }
        }
    }
}


// MARK: - INITIALIZE
extension CaptureAndPlayViewController {
    
    
    /**
     * initializeTabBar()はタブバーの色などの初期化を行います
     *
     */
    func initializeTabBar() {
        self.tabBarController?.tabBar.tintColor = colorPink
        self.tabBarController?.tabBar.barTintColor = colorGrayThin3
        self.tabBarController?.tabBar.isTranslucent = true
    }
}
