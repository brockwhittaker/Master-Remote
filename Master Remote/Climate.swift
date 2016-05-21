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
    
    var deviceObserverHandles: Array<NestSDKObserverHandle> = []
    var dataManager: NestSDKDataManager = NestSDKDataManager()
    var structuresObserverHandle: NestSDKObserverHandle = 0
    
    @IBOutlet weak var nestClimateInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nestClimateInfo.text! = ""
        if (NestSDKAccessToken.currentAccessToken() != nil) {
            print("Authorized!")
            observeStructures()
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
    func observeStructures() {
        // Cleans up previous observers
        removeObservers()
        
        // Start observing structures
        structuresObserverHandle = dataManager.observeStructuresWithBlock({
            structuresArray, error in
            
            self.displayMessage("Structures updated!")
            
            // Structure may change while observing, so remove all current device observers and then set all new ones
            self.removeDevicesObservers()
            
            // Iterates through all structures and set observers for all device
            for structure in structuresArray as! [NestSDKStructure] {
                self.displayMessage("Found structure: \(structure.name)!")
                
                self.observeThermostatsWithinStructure(structure)
                
            }
        })
    }
    
    func observeThermostatsWithinStructure(structure: NestSDKStructure) {
        for thermostatId in structure.thermostats as! [String] {
            let handle = dataManager.observeThermostatWithId(thermostatId, block: {
                thermostat, error in
                
                if (error != nil) {
                    self.displayMessage("Error observing thermostat: \(error)")
                    
                } else {
                    self.displayMessage("Thermostat \(thermostat.name) updated! Current temperature in C: \(thermostat.ambientTemperatureC)")
                    
                    self.displayMessage("Current temperature in F: \(thermostat.ambientTemperatureF)")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage(message: String) {
        nestClimateInfo.text = nestClimateInfo.text! + "\(message)\n"
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
