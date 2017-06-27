//
//  LikeTableViewCell.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/22.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    let baseView:UIView = UIView()
    let height:CGFloat = 80
    let likeButton:UIButton = UIButton()
    let playButton:UIButton = UIButton()

    var index:Int = 0
    var isPlaying:Bool = false
    var trackObj:likeTrack?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // セル本来の背景を設定
        self.backgroundColor = UIColor.blue
        
        // ベースとなるビューの作成
        createBaseView()
        
        // タイトルなどのラベルを追加
        //addLabels()
        
        // 再生ボタンなどを追加
        addPlayAndLikeIcons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - CREATE ELEMENTS
extension LikeTableViewCell {
    
    /**
     * createBaseView()はベースとなるビューを作成します
     *
     */
    func createBaseView(){
        
        let width:CGFloat = UIScreen.main.bounds.width
        
        self.baseView.backgroundColor = UIColor.white
        _ = customSizeConstraint.view.defineSize(item: baseView, width: width, height: height)
        
        self.contentView.addSubview(baseView)
        _ = commonMarginConstraint(item1: baseView, item2: self.contentView, applyItem: self.contentView, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: baseView, item2: self.contentView, applyItem: self.contentView, attribute1: .centerY, attribute2: .centerY, constant: 0)
        
        self.layoutIfNeeded()
    }
    
    /**
     * addLabels()はタイトルなどのラベルを作成します
     *
     */
    func addLabels(mainTitle:String, subTitle:String){
        
        // ラベル用のプロパティー
        let labelHmargin:CGFloat = 25
        let labelVmargin:CGFloat = 17
        //let labelWidth:CGFloat = (UIScreen.main.bounds.width - labelHmargin*2) * 0.33
        //let labelHeight:CGFloat = 20
        
        // トラックタイトル用のラベルを作成
        let titleLabel:UILabel = UILabel()
        titleLabel.font = UIFont(name: fontHirakakuN3, size: fontSizeMLL)
        titleLabel.textColor = colorGrayDark
        titleLabel.text = "\(mainTitle)"
        titleLabel.sizeToFit()
        
        let labelWidth:CGFloat = titleLabel.bounds.width
        let labelHeight:CGFloat = titleLabel.bounds.height
        _ = customSizeConstraint.label.defineSize(item: titleLabel, width: labelWidth, height: labelHeight)
        
        self.baseView.addSubview(titleLabel)
        _ = commonMarginConstraint(item1: titleLabel, item2: self.baseView, applyItem: self.baseView, attribute1: .left, attribute2: .left, constant: labelHmargin)
        _ = commonMarginConstraint(item1: titleLabel, item2: self.baseView, applyItem: self.baseView, attribute1: .top, attribute2: .top, constant: labelVmargin)
        
        
        // サブラベルを作成
        let subLalbel:UILabel = UILabel()
        subLalbel.font = UIFont(name: fontHirakakuN3, size: fontSize)
        subLalbel.textColor = colorGray
        subLalbel.text = "\(subTitle)"
        subLalbel.sizeToFit()
        
        let subLabelWidth:CGFloat = subLalbel.bounds.width
        let subLabelHeight:CGFloat = subLalbel.bounds.height
        _ = customSizeConstraint.label.defineSize(item: subLalbel, width: subLabelWidth, height: subLabelHeight)
        
        self.baseView.addSubview(subLalbel)
        _ = commonMarginConstraint(item1: subLalbel, item2: self.baseView, applyItem: self.baseView, attribute1: .left, attribute2: .left, constant: labelHmargin)
        _ = commonMarginConstraint(item1: subLalbel, item2: titleLabel, applyItem: self.baseView, attribute1: .top, attribute2: .bottom, constant: 13)
    }
    
    /**
     * addPlayAndLikeIcons()は再生とハートのアイコンを作成します
     *
     */
    func addPlayAndLikeIcons(){
        
        // ボタン用のプロパティ
        let buttonSize:CGFloat = 50
        let buttonHmargin1:CGFloat = 25
        let buttonHmargin2:CGFloat = 10
        
        // LIKEボタンの作成
        let likeImage:UIImage = UIImage(named: "like-gray-off")!
        likeButton.setImage(likeImage, for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        
        // ボタンにタグを設定　0:Stoping 1:Playing
        likeButton.tag = 0
        
        _ = customSizeConstraint.button.defineSize(item: likeButton, width: buttonSize, height: buttonSize)
        
        self.baseView.addSubview(likeButton)
        _ = commonMarginConstraint(item1: likeButton, item2: self.baseView, applyItem: self.baseView, attribute1: .right, attribute2: .right, constant: -buttonHmargin1)
        _ = commonMarginConstraint(item1: likeButton, item2: self.baseView, applyItem: self.baseView, attribute1: .centerY, attribute2: .centerY, constant: 0)
        
        
        // 再生ボタンの作成
        let playImage:UIImage = UIImage(named: "play-mini")!
        playButton.setImage(playImage, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        
        // ボタンにタグを設定　0:Stoping 1:Playing
        playButton.tag = 0
        
        _ = customSizeConstraint.button.defineSize(item: playButton, width: buttonSize, height: buttonSize)
        
        self.baseView.addSubview(playButton)
        _ = commonMarginConstraint(item1: playButton, item2: likeButton, applyItem: self.baseView, attribute1: .right, attribute2: .left, constant: -buttonHmargin2)
        _ = commonMarginConstraint(item1: playButton, item2: self.baseView, applyItem: self.baseView, attribute1: .centerY, attribute2: .centerY, constant: 0)
    }
}

// MARK: - FUNCTIONS
extension LikeTableViewCell {
    
    /**
     * setIndex()はカスタムセルにIndexを設定します
     *
     *  parameter - index: 音源のIndex
     */
    func setIndex(index:Int) {
        self.index = index
    }
    
    /**
     * changeLikeButtonColor()はハートボタンをオン・オフします
     *
     *  parameter - isOn: true: 赤色　false: 灰色
     */
    func changeLikeButtonColor(isOn:Bool) {
        
        var likeImage:UIImage = UIImage(named: "like-gray-off")!
        
        if isOn == true {
            likeImage = UIImage(named: "like-gray-on")!
        }
        
        likeButton.setImage(likeImage, for: .normal)
    }
    
    /**
     * changePlayButtonColor()は再生状況に合わせてアイコンを変更します
     *
     */
    func changePlayButtonColor() {
        
        var playImage:UIImage = UIImage(named: "play-mini")!
        
        // 停止中
        if self.isPlaying == false {
            // 再生アイコンに変更
            playImage = UIImage(named: "resume-mini")!
            self.isPlaying = true
        } else {
            self.isPlaying = false
        }
        
        playButton.setImage(playImage, for: .normal)
    }
}
