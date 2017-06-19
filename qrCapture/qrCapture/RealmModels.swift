//
//  RealmModels.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/19.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

/**
 * likeTrack()はお気に入りのトラックを保存するためのクラスです
 *
 */

class likeTrack: Object {
    dynamic var index = Int()
    dynamic var chapter = String()
    dynamic var section = String()
    dynamic var audio = String()
}
