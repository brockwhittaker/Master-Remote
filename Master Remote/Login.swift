//
//  Login.swift
//  Master Remote
//
//  Created by Brock Whittaker on 4/23/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import Foundation

class Login {
    var username: String?
    var password: String?
    
    func setUsername (username: String) -> Bool {
        self.username = username
        
        return (self.username != nil)
    }
    
    func setPassword (password: String) -> Bool {
        self.password = password
        
        return (self.password != nil)
    }
    
    func getCredentials () -> AnyObject {
        let username = self.username!
        let password = self.password!
        
        let dict: Dictionary = [
            "username": username,
            "password": password
        ]
        
        return dict
    }
    
    func sendCredentials (callback: (String, String?) -> Void) -> Bool {
        let credentials: AnyObject = self.getCredentials()
        let app_id : String = "homio"
        
        let json: [AnyObject] = [
            [
                "username": credentials["username"] as! String,
                "password": credentials["password"] as! String,
                "app_id": app_id
            ]
        ]
        
        let http = HTTP(url: "http://localhost/homio/login")
        
        http.post(
            json,
            callback: callback
        )
        
        return true
    }
}