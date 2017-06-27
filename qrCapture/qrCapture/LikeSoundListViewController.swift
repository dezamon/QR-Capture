//
//  LikeSoundListViewController.swift
//  qrCapture
//
//  Created by KAWAITAKAFUMI on 2017/06/04.
//  Copyright © 2017年 takafumi. All rights reserved.
//

import UIKit

import Realm
import RealmSwift
import AVFoundation
import MediaPlayer

class LikeSoundListViewController: UIViewController {
    
    let likeSoundTableView:UITableView = UITableView()
    
    var audioPlayer: AVAudioPlayer!
    var currentAudioFileName:String = ""
    var likeTrackCells:[LikeTableViewCell] = [LikeTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange


        // お気に入り用のテーブルビューを作成
        createLikeSoundTableView()
        
        // テーブルビューの初期設定
        initializeLikeSoundTableView()
        
        // DBからお気に入りのトラックを取得
        getLikeSoundFromDB()
        
        // AudioPlayerを初期化
        initAudioPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("show table view")
        // DBからお気に入りのトラックを取得
        getLikeSoundFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - CREATE ELEMENTS
extension LikeSoundListViewController {
    
    /**
    * createLikeSoundTableView()はお気に入り用のテーブルビューを作成します
    *
    */
    func createLikeSoundTableView(){
        let height:CGFloat = self.view.bounds.height - 49
        let width:CGFloat = self.view.bounds.width
        
        likeSoundTableView.backgroundColor = UIColor.gray
        likeSoundTableView.separatorStyle = .none
        likeSoundTableView.allowsSelection = false
        
        _ = customSizeConstraint.view.defineSize(item: likeSoundTableView, width: width, height: height)
        
        self.view.addSubview(likeSoundTableView)
        _ = commonMarginConstraint(item1: likeSoundTableView, item2: self.view, applyItem: self.view, attribute1: .centerX, attribute2: .centerX, constant: 0)
        _ = commonMarginConstraint(item1: likeSoundTableView, item2: self.view, applyItem: self.view, attribute1: .top, attribute2: .top, constant: 0)
    }
}

// MARK: - FUNCTIONS
extension LikeSoundListViewController {
    
    /**
     * getLikeSoundFromDB()はDBからお気に入り登録されたトラックを取得します
     *
     */
    func getLikeSoundFromDB(){
        
        // セルの配列をリセット
        self.likeTrackCells.removeAll(keepingCapacity: false)
        
        // デフォルトのRealmを取得する
        let realm = try! Realm()
        
        // 全てのお気に入りアイテムを取得
        var likeTracks = realm.objects(likeTrack.self)
        
        // indexラベルでソートする
        let sortedLikeTracks = likeTracks.sorted { $0.index < $1.index }
        
        for track in sortedLikeTracks {
            
            print(track.chapter)
            
            // トラック用のカスタムセルを作成
            let likeTrackCell:LikeTableViewCell = LikeTableViewCell()
            
            // RealmのTrackObjectを渡す
            likeTrackCell.trackObj = track
            
            // タイトルラベルを追加
            likeTrackCell.addLabels(mainTitle: track.chapter, subTitle: track.section)
            
            // UIDを設定
            likeTrackCell.setIndex(index: track.index)
            
            // LIKEボタンの色を変更する
            likeTrackCell.changeLikeButtonColor(isOn: true)
            
            // LIKEボタンにアクションを設定する
            likeTrackCell.likeButton.addTarget(self, action: #selector(self.likeButtonIsTapped(sender:)), for: .touchUpInside)
            
            // LIKEボタンのタグにIndexを設定する
            likeTrackCell.likeButton.tag = track.index
            
            // 再生ボタンにアクションを設定する
            likeTrackCell.playButton.addTarget(self, action: #selector(self.playButtonIsTapped(sender:)), for: .touchUpInside)
            
            // 再生ボタンのタグにIndexを設定する
            likeTrackCell.playButton.tag = track.index
            
            // likeTrackCellsにカスタムセルを追加
            self.likeTrackCells.append(likeTrackCell)
        }
        
        // テーブルビューを更新
        self.likeSoundTableView.reloadData()
    }
    
    /**
     * initAudioPlayer()はaudioPlayerを初期化します
     *
     */
    func initAudioPlayer() {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .allowBluetooth)
        } catch {
            fatalError("failed to set category")
        }
        
        // セッションを有効にする
        do {
            try session.setActive(true)
        } catch {
            fatalError("failed to activate a session")
        }
    }
    
    /**
     * recognizeCurrentAudioRoute()は現在のオーディオリソースを取得します
     *
     */
    func recognizeCurrentAudioRoute() -> String {
        
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        
        var type:String = ""
        
        for description in currentRoute.outputs {
            if description.portType == AVAudioSessionPortHeadphones {
                print("headphone plugged in")
                type = "earphone"
            } else if description.portType == AVAudioSessionPortBluetoothHFP {
                print("connected to bluetooh")
                type = "bluetooh"
            } else {
                print("headphone pulled out")
                type = "speaker"
            }
        }
        return type
    }
    
    /**
     * findVoiceSound()はファイル名から音源を探します
     *
     *  parameter - fileName: 音声ファイルの名前です
     */
    func findVoiceSound(fileName:String) {
        
        // 音声ファイルを探す
        let voiceSoundURL:URL =  URL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: "mp3")!)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: voiceSoundURL)
            self.audioPlayer.prepareToPlay()
        } catch {
            print("can not play sound")
        }
    }
    
    /**
     * getAudioResouce()は音源を取得した時に反応します
     *
     * parameter - name: ファイル名
     */
    func getAudioResouce(name:String){
        
        // 新しいファイル名を検知した時のみ、音源を取得する
        if currentAudioFileName != name {
            
            // ファイル名から音源を再生
            findVoiceSound(fileName: name)
            
            // 現在のオーディオリソースを確認
            do {
                if recognizeCurrentAudioRoute() == "speaker" {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                }
            } catch {
                print("failed to recognize audioRoute")
            }
            self.audioPlayer.delegate = self
            self.audioPlayer.enableRate = true
            
            // ファイル名をcurrentAudioFileNameに格納
            currentAudioFileName = name
            
            print("got new audio resouce")
        }
    }
    
}

// MARK: - DELEGATE
extension LikeSoundListViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
     * initializeLikeSoundTableView()はテーブルビューを初期化して
     * デリゲートなどの設定をします
     */
    func initializeLikeSoundTableView(){
        
        likeSoundTableView.delegate = self
        likeSoundTableView.dataSource = self
        likeSoundTableView.register(LikeTableViewCell.self, forCellReuseIdentifier: "likeCell")

    }
    
    // MARK: - TABLEVIEW DELEGATE
    /**
     * numberOfRowsInSectionはcell数を返す
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likeTrackCells.count
    }
    
    /**
     * numberOfRowsInSectionはcell数を返す
     *
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LikeTableViewCell = self.likeTrackCells[indexPath.row]
        
        // インデックスが偶数ならセルの背景色を変える
        if ((indexPath.row+1) % 2) == 0 {
            cell.baseView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        }
        return cell
    }
    
    /**
     * heightForRowAtはindexはarticleTyepに応じて、セルの高さを変更する
     *
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.likeTrackCells[indexPath.row]
        return cell.height
    }
}

// MARK: - AUDIO DELEGATE
extension LikeSoundListViewController: AVAudioPlayerDelegate {
    
    /**
     * audioPlayerDidFinishPlaying()は音源が終了したときに反応します
     *
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 再生されているセルを取得する
        let predicateForPlaying:NSPredicate = NSPredicate(format: "isPlaying == true", "")
        let predicatedResultForPlaying:[LikeTableViewCell] = (self.likeTrackCells as NSArray).filtered(using: predicateForPlaying) as! [LikeTableViewCell]
        
        if predicatedResultForPlaying.count > 0 {
            print("we fond the playing cell!")
            
            //　再生中のセルの再生アイコンを変更する
            predicatedResultForPlaying.first?.changePlayButtonColor()
        }
    }
}

// MARK: - ACTIONS
extension LikeSoundListViewController {
    
    /**
     * likeButtonIsTapped()はハートボタンがタップされた時に反応します
     *
     * - parameter sender: ハートボタンそのもの
     */
    func likeButtonIsTapped(sender:UIButton){
        print("like button is tapped")
        print("track index is \(sender.tag)")
        
        // indexから特定のセルを取得する
        let predicate:NSPredicate = NSPredicate(format: "index == %i",sender.tag)
        let predicatedResult:[LikeTableViewCell] = (self.likeTrackCells as NSArray).filtered(using: predicate) as! [LikeTableViewCell]
        
        // 結果を確認する
        if predicatedResult.count > 0 {
            print("total:\(predicatedResult.count)")
            print("index:\(predicatedResult.first?.index)")
            
            //　ハートボタンの色を変更する
            predicatedResult.first?.changeLikeButtonColor(isOn: false)
            
            // 要素のインデックスを取得
            if let index = self.likeTrackCells.index(of: predicatedResult.first!) {
                
                UIView.animate(withDuration: 0.5, animations: {
                    predicatedResult.first?.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                    predicatedResult.first?.alpha = 0
                }, completion: { (Bool) in
                    //　テーブルビューから要素を削除する
                    self.likeTrackCells.remove(at: index)
                    
                    // テーブルビューを更新
                    self.likeSoundTableView.reloadData()
                })
            }
            
            // デフォルトのRealmを取得する
            let realm = try! Realm()
            
            // このトラックがDBに格納されていないか確認する
            if let thisLikeTrackObj = realm.objects(likeTrack.self).filter("index == \(predicatedResult.first!.index)").first {
                print("this track is in DB")
            
                // DBから削除
                do {
                    try realm.write {
                        realm.delete(thisLikeTrackObj)
                        print("this track is removed from DB")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /**
     * playButtonIsTapped()は再生ボタンがタップされた時に反応します
     *
     * - parameter sender: 再生ボタンそのもの
     */
    func playButtonIsTapped(sender:UIButton){
        print("play button is tapped")
        

        // indexから特定のセルを取得する
        let predicate:NSPredicate = NSPredicate(format: "index == %i",sender.tag)
        let predicatedResult:[LikeTableViewCell] = (self.likeTrackCells as NSArray).filtered(using: predicate) as! [LikeTableViewCell]
        
        // 結果を確認する
        if predicatedResult.count > 0 {
            
            // 現在再生中のオーディオファイルとタップされた音源が異なる時に
            // 他の再生ボタンのアピアランスを変更する
            if predicatedResult.first?.trackObj?.audio != self.currentAudioFileName {
                // 再生されているセルを取得する
                let predicateForPlaying:NSPredicate = NSPredicate(format: "isPlaying == true", "")
                let predicatedResultForPlaying:[LikeTableViewCell] = (self.likeTrackCells as NSArray).filtered(using: predicateForPlaying) as! [LikeTableViewCell]
                
                if predicatedResultForPlaying.count > 0 {
                    print("we fond the playing cell!")
                    
                    //　再生中のセルの再生アイコンを変更する
                    predicatedResultForPlaying.first?.changePlayButtonColor()
                }
            }
            
            //　音源の取得
            self.getAudioResouce(name: (predicatedResult.first?.trackObj?.audio)!)
            
            // 音源を再生する
            if predicatedResult.first?.isPlaying == false {
                self.audioPlayer.play()
            } else {
                //　音源を停止する
                self.audioPlayer.pause()
            }
            
            //  再生ボタンのアイコンを変更する
            predicatedResult.first?.changePlayButtonColor()
        }
    }
}
