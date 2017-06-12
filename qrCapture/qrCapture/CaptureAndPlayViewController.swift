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
    let controllerPanelView:UIView = UIView()
    let playerSlider:UISlider = UISlider()
    let subLabel:UILabel = UILabel()
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
        
        // 操作画面用のパネルを作成する
        createControllerPanelView()
        
        // トラックのタイトルを表示するラベル等を作成
        createTrackTitleLabels()
        
        // 再生用のスライダーを作成
        createPlayerSlider()
        
        // 再生、ループなどのボタンを作成
        createControllButtons()
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
        
        
        // 「QRコードをスキャン」というラベルを追加
        let pleaseScanLabel:UILabel = UILabel()
        pleaseScanLabel.text = "QRコードをスキャン"
        pleaseScanLabel.textColor = UIColor.white
        pleaseScanLabel.font = UIFont(name: fontHirakakuN3, size: fontSizeL)
        pleaseScanLabel.sizeToFit()
        
        // ラベルサイズ
        let labelWidth:CGFloat = pleaseScanLabel.bounds.width
        let labelHeight:CGFloat = pleaseScanLabel.bounds.height
        let labelVmargin:CGFloat = 30
        
        _ = customSizeConstraint.label.defineSize(item: pleaseScanLabel, width: labelWidth, height: labelHeight)
        
        self.view.addSubview(pleaseScanLabel)
        _ = commonMarginConstraint(item1: pleaseScanLabel, item2: captureView, applyItem: self.view, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: pleaseScanLabel, item2: captureView, applyItem: self.view, attribute1: .bottom, attribute2: .bottom, constant: -labelVmargin)
        
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


    /**
     * createControllerPanelView()は再生・停止などを行う操作画面用のビューを作成します
     *
     */
    func createControllerPanelView(){
        
        // 操作画面用のプロパティ
        let width:CGFloat = self.view.bounds.width - 100
        let height:CGFloat = self.view.bounds.height - captureView.bounds.height - 49
        
        controllerPanelView.backgroundColor = UIColor.white
        
        _ = customSizeConstraint.view.defineSize(item: controllerPanelView, width: width, height: height)
        
        self.view.addSubview(controllerPanelView)
        _ = commonMarginConstraint(item1: controllerPanelView, item2: self.view, applyItem: self.view, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: controllerPanelView, item2: self.captureView, applyItem: self.view, attribute1: .top, attribute2: .bottom, constant: 0)
        
        self.view.layoutIfNeeded()
    }
    
    /**
     * createTrackTitleLabels()はトラックのタイトルなどを表示するラベルを作成します
     *
     */
    func createTrackTitleLabels(){
        
        // ラベル用のプロパティ
        let titleLabelWidth:CGFloat = controllerPanelView.bounds.width
        let titleLabelHeight:CGFloat = 30
        let titleLabelVmargin:CGFloat = 30
        
        let subLabelHeight:CGFloat = 15
        let subLabelVmargin:CGFloat = 10
        
        // トラックタイトル用のラベルを作成
        let trackTitleLabel:UILabel = UILabel()
        trackTitleLabel.font = UIFont(name: fontHirakakuW6, size: fontSizeL)
        trackTitleLabel.textColor = colorGrayDark2
        trackTitleLabel.text = "基本の挨拶"
    
        _ = customSizeConstraint.label.defineSize(item: trackTitleLabel, width: titleLabelWidth, height: titleLabelHeight)
        
        self.controllerPanelView.addSubview(trackTitleLabel)
        _ = commonMarginConstraint(item1: trackTitleLabel, item2: self.controllerPanelView, applyItem: self.controllerPanelView, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: trackTitleLabel, item2: self.controllerPanelView, applyItem: self.controllerPanelView, attribute1: .top, attribute2: .top, constant: titleLabelVmargin)
        
        
        // サブラベルの作成
        subLabel.font = UIFont(name: fontHirakakuN3, size: fontSizeM)
        subLabel.textColor = colorGrayDark3
        subLabel.text = "チャプター1 おはようございます"
        
        _ = customSizeConstraint.label.defineSize(item: subLabel, width: titleLabelWidth, height: subLabelHeight)
        
        self.controllerPanelView.addSubview(subLabel)
        _ = commonMarginConstraint(item1: subLabel, item2: self.controllerPanelView, applyItem: self.controllerPanelView, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: subLabel, item2: trackTitleLabel, applyItem: self.controllerPanelView, attribute1: .top, attribute2: .bottom, constant: subLabelVmargin)
    }
    
    /**
     * createPlayerSlider()は再生用のスライダーを作ります
     *
     */
    func createPlayerSlider() {
        
        // スライダー用のプロパティ
        let sliderWidth:CGFloat = self.controllerPanelView.bounds.width
        let sliderHeight:CGFloat = 30
        let sliderVmargin:CGFloat = 40
                
        // スライダーを初期化
        playerSlider.minimumValue = 0.0
        playerSlider.maximumValue = 1.0
        playerSlider.value = 0.5
        
        // スライダーのつまみ部分を変更
        let thumbImage:UIImage = UIImage(named: "slider-thumb")!
        let minBaseImage:UIImage = UIImage(named: "slider-left")!
        let maxBaseImage:UIImage = UIImage(named: "slider-right")!
        let imageForMin = minBaseImage.stretchableImage(withLeftCapWidth: 4, topCapHeight: 0)
        let imageForMax = maxBaseImage.stretchableImage(withLeftCapWidth: 4, topCapHeight: 0)

        // カスタマイズ用の画像を当てはめる
        playerSlider.setThumbImage(thumbImage, for: .normal)
        playerSlider.setThumbImage(thumbImage, for: .highlighted)
        playerSlider.setMinimumTrackImage(imageForMin, for: .normal)
        playerSlider.setMaximumTrackImage(imageForMax, for: .normal)
        
        _ = customSizeConstraint.view.defineSize(item: playerSlider, width: sliderWidth, height: sliderHeight)
        
        self.controllerPanelView.addSubview(playerSlider)
        _ = commonMarginConstraint(item1: playerSlider, item2: self.controllerPanelView, applyItem: self.controllerPanelView, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: playerSlider, item2: self.subLabel, applyItem: self.controllerPanelView, attribute1: .top, attribute2: .bottom, constant: sliderVmargin)
    }
    
    /**
     * createControllButtons()は再生やスキップ、繰り返しなどのボタンを作成します
     *
     */
    func createControllButtons(){
        
        //　ボタンに必要なプロパティ
        let buttonSize1:CGFloat = 70
        let buttonSize2:CGFloat = 55
        let buttonSize3:CGFloat = 50
        let buttonVmargin1:CGFloat = 30
        let buttonHmargin:CGFloat = 10
        
        //
        // 再生ボタンを作成
        //
        let playImage:UIImage = UIImage(named: "play")!
        let playButton:UIButton = UIButton()
        playButton.setImage(playImage, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        
        _ = customSizeConstraint.button.defineSize(item: playButton, width: buttonSize1, height: buttonSize1)
        
        self.controllerPanelView.addSubview(playButton)
        _ = commonMarginConstraint(item1: playButton, item2: self.playerSlider, applyItem: self.controllerPanelView, attribute1: .left, attribute2: .left, constant: 0)
        _ = commonMarginConstraint(item1: playButton, item2: self.playerSlider, applyItem: self.controllerPanelView, attribute1: .top, attribute2: .bottom, constant: buttonVmargin1)
        
        
        //
        // 前へ戻るボタンを作成
        //
        let skipPrevImage:UIImage = UIImage(named: "skip-prev")!
        let skipPrevButton:UIButton = UIButton()
        skipPrevButton.setImage(skipPrevImage, for: .normal)
        skipPrevButton.imageView?.contentMode = .scaleAspectFit
        
        _ = customSizeConstraint.button.defineSize(item: skipPrevButton, width: buttonSize2, height: buttonSize2)
        
        self.controllerPanelView.addSubview(skipPrevButton)
        _ = commonMarginConstraint(item1: skipPrevButton, item2: playButton, applyItem: self.controllerPanelView, attribute1: .left, attribute2: .right, constant: buttonHmargin)
        _ = commonMarginConstraint(item1: skipPrevButton, item2: playButton, applyItem: self.controllerPanelView, attribute1: .centerY, attribute2: .centerY, constant: 0)
        
        
        //
        //　次へ進むボタンを作成
        //
        let skipNextImage:UIImage = UIImage(named: "skip-next")!
        let skipNextButton:UIButton = UIButton()
        skipNextButton.setImage(skipNextImage, for: .normal)
        skipNextButton.imageView?.contentMode = .scaleAspectFit
        
        _ = customSizeConstraint.button.defineSize(item: skipNextButton, width: buttonSize2, height: buttonSize2)
        
        self.controllerPanelView.addSubview(skipNextButton)
        _ = commonMarginConstraint(item1: skipNextButton, item2: skipPrevButton, applyItem: self.controllerPanelView, attribute1: .left, attribute2: .right, constant: buttonHmargin)
        _ = commonMarginConstraint(item1: skipNextButton, item2: skipPrevButton, applyItem: self.controllerPanelView, attribute1: .centerY, attribute2: .centerY, constant: 0)
        
        
        //
        //　ループボタンを作成
        //
        let loopImage:UIImage = UIImage(named: "loop-off")!
        let loopButton:UIButton = UIButton()
        loopButton.setImage(loopImage, for: .normal)
        loopButton.imageView?.contentMode = .scaleAspectFit
        
        _ = customSizeConstraint.button.defineSize(item: loopButton, width: buttonSize3, height: buttonSize3)
        self.controllerPanelView.addSubview(loopButton)
        _ = commonMarginConstraint(item1: loopButton, item2: skipNextButton, applyItem: self.controllerPanelView, attribute1: .left, attribute2: .right, constant: buttonHmargin)
        _ = commonMarginConstraint(item1: loopButton, item2: skipNextButton, applyItem: self.controllerPanelView, attribute1: .centerY, attribute2: .centerY, constant: 0)
        
        
        //
        // LIKEボタンを作成
        //
        
        let likeImage:UIImage = UIImage(named: "like-gray-off")!
        let likeButton:UIButton = UIButton()
        likeButton.setImage(likeImage, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        
        _ = customSizeConstraint.button.defineSize(item: likeButton, width: buttonSize3, height: buttonSize3)
        self.controllerPanelView.addSubview(likeButton)
        _ = commonMarginConstraint(item1: likeButton, item2: loopButton, applyItem: self.controllerPanelView, attribute1: .left, attribute2: .right, constant: buttonHmargin)
        _ = commonMarginConstraint(item1: likeButton, item2: loopButton, applyItem: self.controllerPanelView, attribute1: .centerY, attribute2: .centerY, constant: 0)
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
        
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice)
            
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
            
        } catch {
            print(error.localizedDescription)
        }
        
        //let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        /*
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
        */
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
