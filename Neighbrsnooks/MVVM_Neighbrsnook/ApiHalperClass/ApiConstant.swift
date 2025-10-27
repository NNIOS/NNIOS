
//
//  API_Constant.swift
//  Vedmir
//
//  Created by Admin on 20/08/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ApiResponseHandler = (_ success: Bool, _ result : JSON, _ responseCode : Int?) -> Void

class API_Model: NSObject {
    var path        : String!
    var newPath     : String!
    var method      : HTTPMethod = .post
    var isRawData   : Bool = true
    var paramKey    : [String]?
    
    init(_ path : String, _ httpMethod : HTTPMethod = .post,_ isRawData : Bool = true,_ param : [String]? = nil) {
        self.path       = path
        self.method     = httpMethod
        self.isRawData  = isRawData
        paramKey        = param
    }
    
    func callAPI(param : Parameters?, paramStr : String? = nil, completion completionBlock: ApiResponseHandler? = nil) {
        if let paramStr = paramStr {
            newPath = path+paramStr
        } else {
            newPath = path
        }
        APIManager.sharedInstance.callAPI(apiModel: self, param: param, completion: completionBlock)
    }
    
    func getFullAPIPathUpdate(_ id: String? = nil) -> String {
        return SERVER_API_URL_TEST+path+id!
    }
    func getFullAPIPath(_ id: String? = nil) -> String {
        return SERVER_API_URL_TEST+path!
    }
}

// MARK: PAGINATION
class API_PAGINASTION: API_Model {
    var isLoadMoreNewMessage                = true
    var isPaginationEnded : Bool!           = false
    var loadRecordCount                     = 0
    var totalMessageCount                   = 0
    var strLanguage : String?
    var reloadDataBlock     :   ApiResponseHandler? = nil
    var localParam : Parameters!
    
    init(_ apiModel : API_Model, completion completionBlock: ApiResponseHandler? = nil) {
        super.init(apiModel.path, apiModel.method, apiModel.isRawData, apiModel.paramKey)
        
        reloadDataBlock = completionBlock
    }
    
    override func callAPI(param : Parameters? = nil, paramStr : String? = nil, completion completionBlock: ApiResponseHandler? = nil) {
        //        loadRecordCount = 10
        //        totalMessageCount = 20
        //        self.loadMoreList(param: param, lastObjArr: nil, completion: completionBlock)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isLoadMoreNewMessage = false
        if let tableView = scrollView as? UITableView {
            if tableView.tableFooterView == nil {
                if scrollView.bounds.size.height < scrollView.contentSize.height {
                    if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height) {
                        isLoadMoreNewMessage = true
                    }
                }
            }
        }
    }
    
    func getUIIndeView() -> UIView {
        let activityIndicatorView =  UIActivityIndicatorView.init(style: .gray)
        activityIndicatorView.backgroundColor = UIColor.clear
        activityIndicatorView.frame = CGRect.init(x: 0, y: 0, width: 37, height: 37)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
}

 

struct API {
//    test
    
    static let BaseURL              = "https://beta.neighbrsnook.com/api/"
    
//    live
    
//    static let BaseURL              = "https://neighbrsnook.com/api/"
    
    static let login                    = BaseURL + "login"
    static let decrypt                  = BaseURL + "decrypt"
    static let user_Profile             = BaseURL + "user_profile"
    static let registerFirst            = BaseURL + "register"
    static let sendOtp                  = BaseURL + "send-otp"
    static let verifyOtp                = BaseURL + "otp_verify"
    static let verifyEmail              = BaseURL + "email_verify"
    static let currentLocation          = BaseURL + "CurrentLocation"
    static let DeviceRegister           = BaseURL + "DeviceRegister"
    static let searchneighborhood       = BaseURL + "searchneighborhood"
    static let ReachOutCaseApi          = BaseURL + "ReachOutCase"
    static let register_2Api            = BaseURL + "register_2"
    static let RegistationThardSteep    = BaseURL + "register_3"
    static let UpdateUserpic            = BaseURL + "updateUserpic"
    static let homeDataApi              = BaseURL + "home_wall"
    static let postTypeApi              = BaseURL + "post_type"
    static let profileUpdate            = BaseURL + "profile_update"
    static let awaitClearName           = BaseURL + "user/clear-await-status"
    static let firebase_tokenApi        = BaseURL + "firebase_token"
    static let createPost               = BaseURL + "post"
    static let detailsPost              = BaseURL + "post/getPostById"
    static let createCommentPost        = BaseURL + "post_comment"
    static let commentListPost          = BaseURL + "post/comments"
    static let commenPostLike           = BaseURL + "post/comments/like"
    static let PostLike                 = BaseURL + "post/toggle_post_reaction"
    static let PostLikeStatus           = BaseURL + "post/emoji/fetch"
    static let PostAllDataList          = BaseURL + "post_fetch"
    
    static let grouplist            = BaseURL + "group_fetch"
    static let createGroup          = BaseURL + "group_store"
    static let updateGroup          = BaseURL + "group_edit"
    static let groupDeatail         = BaseURL + "getGroupById"
    static let groupDelete          = BaseURL + "group_delete"
    static let group_join           = BaseURL + "group_join"
    static let groupExit            = BaseURL + "group_exit"
    static let groupMember          = BaseURL + "group_members"
    static let groupApprove         = BaseURL + "approveJoinRequest"
    static let groupDecRemove       = BaseURL + "group_admin_remove_members"
    static let createPoll           = BaseURL + "poll/create"
    static let pollList             = BaseURL + "poll/list"
    static let pollDetails          = BaseURL + "poll/FetchbyId"
    static let pollDelete           = BaseURL + "poll/delete"
    static let pollVote             = BaseURL + "poll/vote"
    static let createEvents         = BaseURL + "event_store"
    static let eventsList           = BaseURL + "event_fetch"
    static let eventsDelete         = BaseURL + "event/delete"
    static let eventsDetails        = BaseURL + "Findbyid"
    static let eventsAttend         = BaseURL + "Attender"
    static let eventsImage          = BaseURL + "StoreImage"
    static let eventsImageDelete    = BaseURL + "DeleteImage"
    static let eventsLike           = BaseURL + "ToggleLike"
    static let createMarket         = BaseURL + "marketplace/StoreProduct"
    static let selectCategories     = BaseURL + "marketplace/FetchCategory"
    static let AuthProducts         = BaseURL + "marketplace/AuthProducts"
    static let latestProducts       = BaseURL + "marketplace/TodayProductList"
    static let popularCategories    = BaseURL + "marketplace/FetchCategory"
    static let allListCategories    = BaseURL + "marketplace/ProductHomePageRedirect"
    static let wishList             = BaseURL + "marketplace/FetchWishlist"
    static let searchMarketProduct  = BaseURL + "marketplace/SearchProducts"
    static let marketDetails        = BaseURL + "marketplace/FetchByID"
    static let toggleWishlist       = BaseURL + "marketplace/toggleWishlist"
    static let marketDelete         = BaseURL + "marketplace/delete_product"
    static let categoriesFilter    = BaseURL + "marketplace/SearchFilter"
   
}


