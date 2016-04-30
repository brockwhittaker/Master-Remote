//
//  HTTP.swift
//  Master Remote
//
//  Created by Brock Whittaker on 4/24/16.
//  Copyright © 2016 Brock Whittaker. All rights reserved.
//

import Foundation

/*

https://medium.com/swift-programming/http-in-swift-693b3a7bf086#.w90trbqr5
Modified Code from Santosh Rajan.

This code has been converted to two seperate classes that are called to send requests.

*/

class JSON {
    func stringify (value: AnyObject,prettyPrinted:Bool = false) -> String {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        if NSJSONSerialization.isValidJSONObject(value) {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            } catch {
                print("Error stringifying JSON.")
            }
            
        }
        return ""
    }
    
    func parse (text: String) -> [String:String]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            var error: NSError?
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments) as? [String:String]

            if (json != nil) {
                return json!
            } else {
                return nil
            }
        }
        return nil
    }

}

class HTTP {
    var url: String?
    
    init(url: String) {
        self.url = url;
    }
    
    func _sendRequest (request: NSMutableURLRequest,callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
                }
        })
        
        task.resume() //Tasks are called with .resume()
        
    }
    
    func get (callback: (String, String?) -> Void) {
        if (self.url != nil) {
            let url = self.url!
            let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
            self._sendRequest(request, callback: callback)
        } else {
            print("Error. URL is not set.")
        }
    }
    
    func post (jsonObj: AnyObject, callback: (String, String?) -> Void) {
        
        if (self.url != nil) {
            let url = self.url!;
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json",
                forHTTPHeaderField: "Content-Type")
            let jsonString = JSON().stringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            self._sendRequest(request,callback: callback)
        }
    }
}