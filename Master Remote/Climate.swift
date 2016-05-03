//
//  Climate.swift
//  Master Remote
//
//  Created by Samuel Wang on 5/2/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import UIKit
import NestSDK

class Climate: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            print("Authorized!")
            let dataManager = NestSDKDataManager()
            dataManager.observeStructuresWithBlock({
                structuresArray, error in
                
                if (error == nil) {
                    print("Error occurred while observing structures: \(error)")
                    return
                }
                
                for structure in structuresArray as! [NestSDKStructure] {
                    print("Updated structure with name: \(structure.name)")
                }
            })
            
        } else {
            print("Not authorized!")
        }

        // Do any additional setup after loading the view.
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
