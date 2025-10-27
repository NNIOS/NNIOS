//
//  BaseViewController.swift
//  FF Application
//
//  Created by iOS_I$K on 26/04/20.
//  Copyright © 2020 iOS_I$K. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    //MARK:- Global Variables
    var defaultLeftBarButton : BarButtonType {
        let appIconImageButton = UIButton()
        appIconImageButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        appIconImageButton.addTarget(self, action: #selector(defaultLeftBarButtonTapped), for: .touchUpInside)
        return .customView(position: .left, value: appIconImageButton)
    }
    
    var backLeftBarButton : BarButtonType {
        let appIconImageButton = UIButton()
               appIconImageButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)

        appIconImageButton.addTarget(self, action: #selector(backLeftBarButtonTapped), for: .touchUpInside)
        appIconImageButton.tintColor = UIColor.white
        return .customView(position: .left, value: appIconImageButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }

    
    @objc
    func defaultLeftBarButtonTapped() {
//        AppDelegate.sharedInstance.rootViewController?.showLeftView()

    }
    @objc
    func backLeftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- UINavigationController Methods
extension MasterViewController {
    
    enum BarButtonPosition {
        case left, right
    }
    
    enum BarButtonType {
        case title(position : BarButtonPosition, value : String, fontSize : CGFloat, style : UIBarButtonItem.Style, selector: Selector),
        image(position : BarButtonPosition, value : UIImage, style : UIBarButtonItem.Style, selector: Selector),
        customView(position : BarButtonPosition, value : UIView)
    }
    
    func showNavigationBarWith(title : String?, barButtonItems : [BarButtonType]? = nil, isTabBarController : Bool? = nil, barTintColor : UIColor = .blue) {
        let navItem : UINavigationItem? = isTabBarController != nil ? self.parent?.navigationItem : self.navigationItem
        
        let label = UILabel(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width-110, height:50))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        //label.font = UIFont.appRobotoCondensedFont(ofSize: 18.0)
        label.textAlignment = .center
        label.textColor = .white
        label.text = title
        navItem?.titleView = label
        
        //navItem?.title = title
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = barTintColor
        self.navigationController?.navigationBar.tintColor = .white
        barButtonItems != nil ? self.setBarButtonItems(barButtonItems!, navigationItem: navItem) : ()
        self.navigationController?.navigationBar.setBackgroundImage(barTintColor == .clear ? UIImage() : nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = barTintColor == .clear ? UIImage() : nil
    }
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setNavigationItemTitleEmpty() {
        self.navigationItem.title = ""
    }
    
    func hideLeftButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setBarButtonItems(_ types : [BarButtonType], navigationItem : UINavigationItem?) {
        for type in types {
            switch type {
            case .title(let position, let title, let fontSize, let style, let selector):
                let barButtonItem = UIBarButtonItem(title: title, style: style, target: self, action: selector)
                switch position {
                case .left:
                    navigationItem?.setLeftBarButton(barButtonItem, animated: false)
                    navigationItem?.leftBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: fontSize)], for: .normal)
                case .right:
                    navigationItem?.setRightBarButton(barButtonItem, animated: false)
                    navigationItem?.rightBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: fontSize)], for: .normal)
                }
            case .image(let position, let image, let style, let selector):
                let barButtonItem = UIBarButtonItem(image: image, style: style, target: self, action: selector)
                switch position {
                case .left: navigationItem?.setLeftBarButton(barButtonItem, animated: false)
                case .right: navigationItem?.setRightBarButton(barButtonItem, animated: false)
                }
                
            case .customView(let position, let customView):
                let barButtonItem = UIBarButtonItem(customView: customView)
                switch position {
                case .left: navigationItem?.setLeftBarButton(barButtonItem, animated: false)
                case .right: navigationItem?.setRightBarButton(barButtonItem, animated: false)
                }
            }
        }
    }
}
