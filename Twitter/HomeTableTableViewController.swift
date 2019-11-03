//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by KimlyT. on 11/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()                             // an array of dictionary
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl            //refresh home screen when pull down
        
        
    
    }
    
    @objc func loadTweets(){
        
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:{( tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{                                 //for every tweet getting from the api tweets dictionary
                self.tweetArray.append(tweet)                    //append each tweet to the tweetArray
            }
            self.tableView.reloadData()                         //update the table
            self.myRefreshControl.endRefreshing()               //stop the refreshing wheel
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! Oh no!")
        })
        
    }
    
    func loadMoreTweets(){    // infinite scroll
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success:{( tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{                                 //for every tweet getting from the api tweets dictionary
                self.tweetArray.append(tweet)                    //append each tweet to the tweetArray
            }
            self.tableView.reloadData()                         //update the table
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! Oh no!")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{              //when at the end of the page
            loadMoreTweets()                                   //load more tweets
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)             //dismiss the home screen and back to the login screen
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")  // when log out, user no longer stay logged in
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        
        let imageUrl = URL(string: ((user["profile_image_url_https"] as? String)!))
        let data = try?Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}