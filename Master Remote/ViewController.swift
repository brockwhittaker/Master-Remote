//
//  ViewController.swift
//  Master Remote
//
//  Created by Brock Whittaker on 4/23/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func submitButton(sender: UIButton) {
        print(username.text)
        print(password.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let login = Login()
        
        login.setUsername("brockwhittaker")
        login.getUsername()

        
        HTTPGet("http://www.lavancier.com") {
            (data: String, error: String?) -> Void in
            if error != nil {
                print(error)
            } else {
                print("data is : \n\n\n")
                print(data)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

