//
//  CaptureAndPlayViewController.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/04.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import UIKit

class CaptureAndPlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.green
        
        // タブバーの色などを初期化します
        initializeTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - CREATE ELEMENTS
extension CaptureAndPlayViewController {
    
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
