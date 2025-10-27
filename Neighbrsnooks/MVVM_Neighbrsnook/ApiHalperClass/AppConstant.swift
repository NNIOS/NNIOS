//
//  AppConstant.swift
//  HRDesk
//
//  Created by Manish Mishra on 10/06/21.
//

import UIKit
import Foundation

class AppConstants {
    //Live Server
    
    
    let navigationColor = UIColor.white
    
    func randomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
    let appThemeColor = UIColor(red: 244.0/255.0, green: 93.0/255.0, blue: 45.0/255.0, alpha: 1.0)
//    let appBackgroundColor = 
    
}
