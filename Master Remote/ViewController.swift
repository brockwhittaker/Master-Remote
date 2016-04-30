//
//  ViewController.swift
//  Master Remote
//
//  Created by Brock Whittaker on 4/23/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var login = Login()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var successMessage: UILabel!
    
    @IBAction func submitButton(sender: AnyObject) {
        login.setUsername(username.text!);
        login.setPassword(password.text!);
        
        self.login.sendCredentials({ (data, error) in
            dispatch_async(dispatch_get_main_queue(), {
                let res = JSON().parse(data)
                print(res)
                if (res != nil) {
                    self.successMessage.text = "You successfully signed up!"
                } else {
                    self.successMessage.text = "Uh oh. Either the username or password is incorrect."
                }
            })
        })

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /*
        let http = HTTP(url: "http://www.lavancier.com/")
        
        http.get({
            (data: String, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                print("data is : \n\n\n")
                print(data)
            }
        })
        */
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

