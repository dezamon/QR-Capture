//
//  customExtensions.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/18.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import Foundation
import UIKit

extension NSData {
    
    /**
     * loadAsyncFromURL()はURLからデータを取得するためのエクステンションです
     *
     *  parameter - url: ダウンロード先のURL
     */
    class func loadAsyncFromURL(url: URL, callback: @escaping (NSData?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            
            do {
                let fileData = try NSData(contentsOf: url, options: NSData.ReadingOptions.mappedIfSafe)
                
                DispatchQueue.main.async {
                    callback(fileData)
                }
            } catch {
                print("failed to load image")
            }
        }
    }
}
