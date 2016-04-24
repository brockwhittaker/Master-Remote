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

*/

func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String {
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    
    if NSJSONSerialization.isValidJSONObject(value) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        } catch {
            print("error")
            //Access error here
        }
        
    }
    return ""
}

func HTTPsendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
    
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

func HTTPGet(url: String, callback: (String, String?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
    HTTPsendRequest(request, callback: callback)
}

func HTTPPostJSON(url: String,
    jsonObj: AnyObject,
    callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json",
        forHTTPHeaderField: "Content-Type")
        let jsonString = JSONStringify(jsonObj)
        let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        request.HTTPBody = data
        HTTPsendRequest(request,callback: callback)
}