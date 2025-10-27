//
//  NVProgressClass.swift
//  Angel Food User
//
//  Created by Manish on 30/10/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

import UIKit
import NVActivityIndicatorView

class UtilityMethods {
    
    private static var indicatorCount = 0
    private static let activityData = ActivityData(
        size: CGSize(width: UIScreen.main.bounds.size.width/7,
                     height: UIScreen.main.bounds.size.width/7),
        messageFont: UIFont.systemFont(ofSize: 14.0),
        messageSpacing: 5,
        type: .ballPulseSync,
        color: UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0),  
        backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.4),
        textColor: .white
    )

    static func showIndicator(withMessage message: String? = nil) {
        if indicatorCount == 0 {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        }
        indicatorCount += 1
    }
    
    static func hideIndicator() {
        indicatorCount -= 1
        indicatorCount == 0 ? NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil) : ()
    }
    
    static func HTML_to_string(string: String)->NSMutableAttributedString{
        do{
            let attrStr = try NSMutableAttributedString(
            data: (string.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue), allowLossyConversion: false)!),
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
            let fontt = UIFont.systemFont(ofSize: 16)
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:attrStr.length))
            attrStr.addAttribute(NSAttributedString.Key.font, value: fontt, range: NSRange(location:0,length:attrStr.length))
            
            
            return attrStr
        }
        catch _ {
            return NSMutableAttributedString()
        }
    }
    
    class func fixFontsInAttributedStringForUseInApp(cachedAttributedString: NSMutableAttributedString?) -> NSMutableAttributedString {
        
        cachedAttributedString?.beginEditing()
        
        let rangeAll = NSRange(location: 0, length: cachedAttributedString!.length)
        
        var boldRanges: [NSRange] = []
        var italicRanges: [NSRange] = []
        
        var boldANDItalicRanges: [NSRange] = [] // WTF right ?!
        
        cachedAttributedString?.enumerateAttribute(
            NSAttributedString.Key.font,
            in: rangeAll,
            options: .longestEffectiveRangeNotRequired)
        { value, range, stop in
            
            if let font = value as? UIFont {
                
                let bb: Bool = font.fontDescriptor.symbolicTraits.contains(.traitBold)
                let ii: Bool = font.fontDescriptor.symbolicTraits.contains(.traitItalic)
                
                // you have to carefully handle the "both" case.........
                
                if bb && ii {
                    
                    boldANDItalicRanges.append(range)
                }
                
                if bb && !ii {
                    
                    boldRanges.append(range)
                }
                
                if ii && !bb {
                    
                    italicRanges.append(range)
                }
            }
        }
        
        cachedAttributedString!.setAttributes([NSAttributedString.Key.font: UIFont(name: "Roboto", size: 17.0)!], range: rangeAll)
        
        for r in boldANDItalicRanges {
            cachedAttributedString!.addAttribute(NSAttributedString.Key.font, value: (UIFont.systemFont(ofSize: 15.0, weight: .regular)), range: r)
        }
        
        for r in boldRanges {
            cachedAttributedString!.addAttribute(NSAttributedString.Key.font, value: (UIFont.systemFont(ofSize: 15.0, weight: .bold)), range: r)
        }
        
        for r in italicRanges {
            cachedAttributedString!.addAttribute(NSAttributedString.Key.font, value: (UIFont.systemFont(ofSize: 15.0, weight: .regular)), range: r)
        }
        
        cachedAttributedString?.endEditing()
        return cachedAttributedString!
    }
    
}
