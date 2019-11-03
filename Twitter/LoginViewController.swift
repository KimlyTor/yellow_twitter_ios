//
//  LoginViewController.swift
//  Twitter
//
//  Created by KimlyT. on 11/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)  //if already logged in moving to home screen right away
        }
        
        
            
    }
    @IBAction func onLoginButton(_ sender: Any) {
     
        let myurl = "https://api.twitter.com/oauth/request_token" //twitter api ref index> basics>auth>POSTrequest

        TwitterAPICaller.client?.login(url: myurl, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")           //user stay loggedin
            self.performSegue(withIdentifier: "loginToHome", sender: self)   //perform segue way
        }, failure: { (Error) in
            print("login failed")
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
