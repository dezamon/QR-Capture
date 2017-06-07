//
//  Constraint.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/04.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import Foundation
import UIKit

/**
 * commonMarginConstraint()は特定の要素同士の配置制約を関連づける
 *
 * - parameter item1: 制約を付けたい対象となる要素
 * - parameter item2: リレーショナルを持たせる参照する要素
 * - parameter applyItem: item1がaddSubviewされた親要素
 * - parameter attribute1:　item1の起点となる面（top,bottom,left,right）を選択
 * - parameter attribute2:　item2の接続先の面（top,bottom,left.right）を選択
 * - parameter constant:　マージン値
 */
func commonMarginConstraint(item1:AnyObject, item2: AnyObject, applyItem:AnyObject, attribute1:NSLayoutAttribute, attribute2:NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
    
    let constraint:NSLayoutConstraint = NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: NSLayoutRelation.equal, toItem: item2, attribute: attribute2, multiplier: 1, constant: constant)
    
    // define identifier
    constraint.identifier = ""
    applyItem.addConstraint(constraint)
    
    // return this constraint
    return constraint
}




/**
 * customSizeConstraint()は特定の要素のサイズに対して制約を持たせる
 *
 * - parameter item: 制約を付けたい対象となる要素
 * - parameter width:　幅
 * - parameter height:　高さ
 */
enum customSizeConstraint {
    case view
    case label
    case textfield
    case button
    case uiswitch
    case picker
    case slider
    
    func defineSize (item:AnyObject, width:CGFloat, height:CGFloat) -> (NSLayoutConstraint, NSLayoutConstraint) {
        
        // widthConstraint for return
        var widthConstraint:NSLayoutConstraint = NSLayoutConstraint()
        var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
        
        switch self {
            
        case customSizeConstraint.view:
            
            let thisItem:UIView = item as! UIView
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.label:
            let thisItem:UILabel = item as! UILabel
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.textfield:
            let thisItem:UITextField = item as! UITextField
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.button:
            let thisItem:UIButton = item as! UIButton
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.uiswitch:
            let thisItem:UISwitch = item as! UISwitch
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.picker:
            let thisItem:UIPickerView = item as! UIPickerView
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
            
        case customSizeConstraint.slider:
            let thisItem:UISlider = item as! UISlider
            thisItem.translatesAutoresizingMaskIntoConstraints = false
            widthConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
            
            heightConstraint = NSLayoutConstraint(item: thisItem, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
            thisItem.addConstraints([widthConstraint,heightConstraint])
        }
        
        // return width and height constraints
        return (widthConstraint,heightConstraint)
    }
}
