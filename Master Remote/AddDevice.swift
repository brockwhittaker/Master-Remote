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
    
    // Outlet to the ConnectNest Button
    @IBOutlet weak var connectNest: NestSDKConnectWithNestButton!
    
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var structuresObserverHandle: NestSDKObserverHandle = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Checks if user is logged in through access token
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            observeStructures()
        }
    }
    
    func connectNest(connectNest: NestSDKConnectWithNestButton!, didAuthorizeWithResult result: NestSDKAuthorizationManagerAuthorizationResult!, error: NSError!) {
        if (error != nil) {
            //Error
            print("Process error: \(error)")
            
        } else if (result.isCancelled) {
            //User cancels login
            print("Cancelled")
            
        } else {
            //User successfully logs in
            print("Authorized!")
            
            observeStructures()
        }
    }
    
    func connectWithNestButtonDidUnauthorize(connectWithNestButton: NestSDKConnectWithNestButton!) {
        removeObservers()
    }
    
    func observeStructures() {
        // Cleans up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            print("Structures updated!")
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterates through all structures and set observers for all device
            for structure in structuresArray as! [NestSDKStructure] {
                print("Found structure: \(structure.name)!")
                
                self.observeThermostatsWithinStructure(structure)
                
            }
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    print("Error observing thermostat: \(error)")
                    
                } else {
                    print("Thermostat \(thermostat.name) updated! Current temperature in C: \(thermostat.ambientTemperatureC)")
                }
            })
            
            deviceObserverHandles.append(handle)
        }
    }
    
    func removeObservers() {
        removeDevicesObservers();
        removeStructuresObservers();
    }
    
    func removeDevicesObservers() {
        for (_, handle) in deviceObserverHandles.enumerate() {
            dataManager.removeObserverWithHandle(handle);
        }
        
        deviceObserverHandles.removeAll()
    }
    
    func removeStructuresObservers() {
        dataManager.removeObserverWithHandle(structuresObserverHandle)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
