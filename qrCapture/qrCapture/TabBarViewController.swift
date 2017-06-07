//
//  TabBarViewController.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/04.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let redView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    
        redView.backgroundColor = UIColor.red
        _ = customSizeConstraint.view.defineSize(item: redView, width: self.view.bounds.width, height: self.view.bounds.height)
        redView.alpha = 0
        self.view.addSubview(redView)
        
        _ = commonMarginConstraint(item1: redView, item2: self.view, applyItem: self.view, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: redView, item2: self.view, applyItem: self.view, attribute1: .centerY, attribute2: .centerY, constant: 0)
    }
    
    override func didReceiveMemoryWarning() {
        // do something
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // QRコードの読み取りと再生を行うビューを作成
        let captureAndPlayView:CaptureAndPlayViewController = CaptureAndPlayViewController()
        let cameraIcon:UIImage = UIImage(named: "camera-off")!.withRenderingMode(.alwaysOriginal)
        let captureAndPLayBarItem:UITabBarItem = UITabBarItem(title: "", image: cameraIcon, selectedImage: UIImage(named: "camera-on.png"))
        captureAndPLayBarItem.tag = 1
        captureAndPlayView.tabBarItem = captureAndPLayBarItem
        
        
        // お気に入り一覧を表示するためのビューを作成
        let likeSoundListView:LikeSoundListViewController = LikeSoundListViewController()
        let likeIcon:UIImage = UIImage(named: "like-off")!.withRenderingMode(.alwaysOriginal)
        let likeBarItem:UITabBarItem = UITabBarItem(title: "", image: likeIcon, selectedImage: UIImage(named: "like-on.png"))
        likeBarItem.tag = 2
        likeSoundListView.tabBarItem = likeBarItem
        
        
        //  このビューに各ビューを格納する
        self.viewControllers = [captureAndPlayView, likeSoundListView]
    }
}


// MARK: - TABBAR DELEGATE METHOD
extension TabBarViewController {
    
    /**
     *　タブが選択されたときに動作します
     *
     */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title)")
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("tabbar is tapped")
        
        switch item.tag {
        case 1:
            /// QRコード読み取りと再生用のビュー
            print("capture QR code")
        case 2:
            /// お気に入り一覧用のビュー
            print("like list")
        default:
            print("error")
        }
    }
}

// MARK: - UITABBARITEM EXTENSION
extension UITabBarItem {
    func setImage(image:UIImage?, offset: CGPoint? = nil) {
        guard let v = self.value(forKey: "view") as? UIView else {
            return
        }
        print("offset iamge now")
        if let img = image {
            let imageView = UIImageView(image: img)
            
            var frame = imageView.frame
            frame.origin.y = (v.bounds.height - frame.height) / 2 + (offset?.y ?? 0)
            frame.origin.x = (v.bounds.width - frame.width) / 2 + (offset?.x ?? 0)
            imageView.frame = frame
            
            v.addSubview(imageView)
        }
    }
}

extension UITabBarController {
    func isHideTabBarAnimated(hide:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
            } else {
                self.tabBar.transform = CGAffineTransform.identity
            }
        })
    }
}
