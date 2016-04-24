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
        
        return (self.username != nil) ? true : false
    }
    
    func getUsername () -> String? {
        return self.username
    }
}