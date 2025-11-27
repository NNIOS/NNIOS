//
//  OnboardingVC.swift
//  Neighbrsnooks
//
//  Created by shivendra dhakar on 16/10/25.
//

import UIKit

class OnboardingVC: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var getStartBtn: UIButton!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var iconImg2: UIImageView!
    @IBOutlet weak var iconImg3: UIImageView!
    @IBOutlet weak var iconImg4: UIImageView!
    @IBOutlet weak var iconImg5: UIImageView!
    @IBOutlet weak var iconImg6: UIImageView!
    @IBOutlet weak var iconImg7: UIImageView!
    
    @IBOutlet weak var welcomePageImg: UIImageView!
    @IBOutlet weak var lastPageImg: UIImageView!
    @IBOutlet weak var joinCGroupImg: UIImageView!
    @IBOutlet weak var welComeImg: UIImageView!
    @IBOutlet weak var sellAndBuyImg: UIImageView!
    @IBOutlet weak var SomeThingHappImg: UIImageView!
    @IBOutlet weak var ShowCaseBImg: UIImageView!
    
    @IBOutlet weak var firstPage: UIImageView!

    var timer: Timer?
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        pageController.isUserInteractionEnabled = false
        pageController.numberOfPages = 7
        pageController.currentPage = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        getStartBtn.layer.cornerRadius = getStartBtn.frame.height / 2
        getStartBtn.clipsToBounds = true
        
        [joinCGroupImg, welComeImg, sellAndBuyImg, SomeThingHappImg, ShowCaseBImg, welcomePageImg, lastPageImg].forEach {
            $0?.layer.cornerRadius = 8
            $0?.clipsToBounds = true
        }
        
        [iconImg, iconImg2, iconImg3, iconImg4, iconImg5, iconImg6, iconImg7].forEach {
            $0?.layer.cornerRadius = ($0?.frame.height ?? 0) / 2
            $0?.clipsToBounds = true
        }
    }
    
    // MARK: - Auto Scroll Methods
    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func scrollToNextPage() {
        let pageWidth = scrollView.frame.size.width
        let maxWidth = pageWidth * CGFloat(pageController.numberOfPages)
        var newOffset = scrollView.contentOffset.x + pageWidth
        
        if newOffset >= maxWidth {
            newOffset = 0
        }
        
        let rect = CGRect(x: newOffset, y: 0, width: pageWidth, height: scrollView.frame.size.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        pageController.currentPage = currentPage
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startAutoScroll()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func getStarted(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

}

