//
//  TweetCell.swift
//  Twitter
//
//  Created by KimlyT. on 11/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func favoriteTweet(_ sender: Any) {                                     //can favorite tweet or undo it
        let toBeFavorited = !favorited
        
        if(toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Favorited did not succeed \(Error)")
            })
        }else{
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unfavorited did not succeed \(Error)")
            })
        }
        
    }
    
    func setFavorite (_ isFavorited: Bool){                                          //change favButton to red if favoritted else it is gray
        favorited = isFavorited
        
        if(favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    
    
    @IBAction func retweet(_ sender: Any) {                                        //if retweet sucess setReTweet to true
        TwitterAPICaller.client?.reTweet(tweetId: tweetId, success: {
            self.setReTweet(true)
        }, failure: { (Error) in
            print("Retweeted did not succeed \(Error)")
        })
        
    }

    func setReTweet(_ isReTweeted: Bool){                                        //change retweetButton to green if retweet is true else it's gray
        
        if(isReTweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
        
    }
    
    

}
