//
//  AddDevice.swift
//  Master Remote
//
//  Created by Samuel Wang on 5/2/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import UIKit
import NestSDK

class AddDevice: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let connectWithNestButton = NestSDKConnectWithNestButton(frame: CGRectMake(0, 0, 200, 44))
        
        // Optional: Place the button in the center of your view.
        connectWithNestButton.center = self.view.center
        view.addSubview(connectWithNestButton)
        // Do any additional setup after loading the view.
        
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            print("Authorized!")
            
        } else {
            print("Not authorized!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
