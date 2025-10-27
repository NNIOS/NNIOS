//
//  Userdefault.swift
//  Manish_Class
//
//  Created by Manish on 16/09/20.
//  Copyright © 2020 Manish Mishra. All rights reserved.
//

import Foundation

class UserDefault: NSObject {
    static let shared = UserDefault()
    let defaults = UserDefaults.standard
    
    func clearAll(){
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
            defaults.synchronize()
        }
    }
    
    func setdeviceToken(token: String) {
        defaults.set(token, forKey: "devicetoken")
    }
    
    func getdeviceToken() -> String {
        if let token = defaults.value(forKey: "devicetoken") as? String {
            return token
        }
        return ""
    }
    
    func setUserid(userid: String) {
        defaults.set(userid, forKey: "userid")
    }
    
    func getUserid() -> String {
        if let userid = defaults.value(forKey: "userid") as? String {
            return userid
        }
        return ""
    }
    
    
    func setAccessToken(userid: String) {
        defaults.set(userid, forKey: "accesstoken")
    }
    
    func getAccessToken() -> String {
        if let userid = defaults.value(forKey: "accesstoken") as? String {
            return userid
        }
        return ""
    }

    func setUserName(username: String) {
        defaults.set(username, forKey: "username")
    }
    func getUserName() -> String {
        if let username = defaults.value(forKey: "username") as? String {
            return username
        }
        return ""
    }
    
    func setUserMail(usermail: String) {
        defaults.set(usermail, forKey: "usermail")
    }
    func getUserMail() -> String {
        if let usermail = defaults.value(forKey: "usermail") as? String {
            return usermail
        }
        return ""
    }
    
    func setUserNumber(usernumber: String) {
        defaults.set(usernumber, forKey: "usernumber")
    }
    func getUserNumber() -> String {
        if let usernumber = defaults.value(forKey: "usernumber") as? String {
            return usernumber
        }
        return ""
    }

    
    func setUserPic(userpic: String) {
        defaults.set(userpic, forKey: "userpic")
    }
    func getUserPic() -> String {
        if let userpic = defaults.value(forKey: "userpic") as? String {
            return userpic
        }
        return ""
    }

    func setTodayAttendenceDate(lastDate: String) {
        defaults.set(lastDate, forKey: "lastAttendenceDate")
    }
    func getTodayAttendenceDate() -> String {
        if let lastDate = defaults.value(forKey: "lastAttendenceDate") as? String {
            return lastDate
        }
        return ""
    }
    
    func setTodayAttendenceTimeIN(lastTimeIN: String) {
        defaults.set(lastTimeIN, forKey: "lastAttendenceTime")
    }
    func getTodayAttendenceTimeIN() -> String {
        if let lastTimeIN = defaults.value(forKey: "lastAttendenceTime") as? String {
            return lastTimeIN
        }
        return ""
    }

    func setEmpId(EmpId: String) {
        defaults.set(EmpId, forKey: "empid")
    }
    func getEmpId() -> String {
        if let EmpId = defaults.value(forKey: "empid") as? String {
            return EmpId
        }
        return ""
    }
    
}
