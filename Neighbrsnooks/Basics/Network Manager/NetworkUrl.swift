import Foundation
import UIKit

/** --------------------------------------------------------
 * HTTP Basic Authentication
 *	--------------------------------------------------------
 */

let kHTTPUsername               = ""
let kHTTPPassword               = ""
let OS                          = UIDevice.current.systemVersion
let kAppVersion                 = "1.0"
let kDeviceModel                = UIDevice.current.model

/** --------------------------------------------------------
 *	 API Base URL defined by Targets.
 *	--------------------------------------------------------
 */

 
 // dev.
let kBASEURL = "https://dev.neighbrsnook.com/oldadmin/api/"

//let kMBASEURL = "https://dev.neighbrsnook.com/marketplace/api/"

let kMBASEURL = "https://dev.neighbrsnook.com/admin/api/"
// https://www.getpostman.com/collections/26b0e1c72aca6e901d76

let kImageBaseUrl = ""
let kAuthentication = "Authentication"     //Header key of request  encrypt data
let kFirebaseURL = "https://labae-322020-default-rtdb.firebaseio.com/"
let kSharedUserDefaults = UserDefaults.standard
//dev.neighbrsnook.com/admin/api/login
/** --------------------------------------------------------
 *		Used Web Services Name
 *	--------------------------------------------------------
 *///   https://vensemart.com/Vensemart/api/
struct WebServiceName {
    
    static let kLogin = "login"
    static let kOtp = "master?flag=sendotp"
    static let kRegisterNew = "master?flag=reg-step-I"
    static let kVerifyEmail = "verify-email"
    static let kForgetOtp = "otpverification"
    static let kForgotPassword = "master?flag=forgotpassword"
    static let kRegister = "master?flag=createuser"
    static let kVerifyOTP = "otpverification?flag=verification"
    static let kProffesion = "master?flag=profession"
    static let kintrset = "master?flag=interest"
    static let kReason = "master?flag=reason"
    static let kMoreYou = "master?flag=moreaboutyou"
    static let kCountry = "master?flag=country"
    static let kstate = "master?flag=state"
    static let kCity = "master?flag=city"
    static let kSearchNeighbr = "master?flag=searchneighborhood"
    static let kReachout = "master?flag=requestneighborhood"
    static let kAddress = "master?flag=address"
    static let kAddressProof = "master?flag=addressproof"
    static let kHome = "posting?flag=homepage"
    static let kUploadPhoto = "master?flag=userprofilephoto"
    static let kNeighbrhood = "myneighborhood?flag=myneighborhood"
    static let kUserProfile = "master?flag=userprofile"
    static let kHomeBookay = "welcome?flag=userwellikes"
    static let kReportpost = "reportapp?flag=reportitems"
    static let kFavouirtBuss = "posting?flag=userfavouritespost"
    static let kRemoveFavouirtBuss = "posting?flag=userunfavouritepost"
    static let kbusnisees = "business?flag=businesslist"
    static let kSubscribe = "neighbrsnook?flag=subscribe"
    static let kMemberList = "chat?flag=neighbrhoodmemberlist"
    static let kGrouplist = "groups?flag=grouplist"
    static let kEventList = "event?flag=eventlist"
    static let kPollS = "poll?flag=polllist"
    //static let kPostList = "postlist"
    static let kNotification = "all-notification?flag=notification"
    static let kCreateGroup = "groups?flag=creategroup"
    static let kChat = "chat?flag=directmessagelist"
    static let kChatMember = "chat?flag=neighbrhoodmemberlist"
    static let kChatMessage = "chat?flag=showdirectmessage"
    static let kUserChat = "chat?flag=userdirectmessage"
    static let kContactus = "contactus?flag=contactus"
    static let kSettings = "mobilesettings?flag=usermobilesetting"
    static let kChangePassword = "master?flag=changepassword"
    static let kCatBusiness = "business?flag=businesstype"
    static let kPublicDirect = "master?flag=publicdirectory"
    static let kReportFinalpost = "reportapp?flag=reportitems"
    static let kCreateBussines = "business?flag=newcreatebusiness"
    static let kExitGroup = "groups?flag=exitgroup"
    static let kJoinGroup = "groups?flag=userjoingroup"
    static let kGroupDetails = "groups?flag=groupdetail"
    static let kGroupList = "groups?flag=viewjoingroupnamelist"
    static let kAcceptGroup = "groups?flag=grouprequest"
    static let kGroupChatList = "groups?flag=showgroupchat"
    static let kMessageGroup = "groups?flag=groupchat"
    static let kDeleteGroup = "groups?flag=deletegroup"
    static let kUpdateGroup = "groups?flag=updategroup"
    static let kDelUser = "groups?flag=userdeletefromgroup"
    
    static let kPostList = "posting?flag=postlist"
    static let kLikePost = "posting?flag=userpostlikes"
    static let kUnlikeLikePost = "posting?flag=userpostlikes"
    static let kCommentPosts = "posting?flag=postcommentslist"
    static let kPostComment = "posting?flag=postcomments"
    static let kLikeList = "posting?flag=userpostemojilist"
    static let kPostcategory = "posting?flag=posttype"
    static let kCreatePost = "posting?flag=createpost"
    static let kAllHomeDataa = "posting?flag=homepage"
    // static let kLikePost = "user/likePost"
    static let kUnLikePost = "user/unlikePost"
    static let KCreatMarket = "mpk_product_add?"
    
    
    static let kFavouriteList = "posting?flag=userfavouritelisting"
    static let kBussinesDetail = "business?flag=businessdetails"
    static let kBusinessReview = "business?flag=allreviewlist"
    static let kBusinessType = "business?flag=businesstype"
    static let kReviwcomment = "business?flag=businessreview"
    static let kRatingBusiness = "business?flag=businessuserrate"
    static let kDeleteBusiness = "business?flag=deletebusiness"
    static let kDeleteBusinessReview = "business?flag=deleteBusinessReview"
    static let kUpdateBusiness = "business?flag=newcreatebusiness"
    static let kEventDetail = "event?flag=viewalldataeventlistdetails"
    
    static let kUploadImageEventt = "event?flag=eventimage"
    static let kCreateEvent = "event?flag=createevent"
    static let kEventJointList = "event?flag=eventaddjoinlist"
    static let kDelteEvent = "event?flag=deleteevent"
    static let kEventImgDel = "event?flag=deleteimageevent"
    static let kEventYesJoint = "event?flag=userjoinevent"
    static let kNewNotification = "mobilesettings?flag=usermobilesetting"
    static let kMarketcat = "category"
    static let kMarketWall = "mpk_home_wall?"
    static let kpollDetail = "poll?flag=polldetail"
    static let kProductListl = "mpk_product_today_list?user_id=463"
    static let kDeletepoll = "poll?flag=deletepoll"
    static let kpollVoted = "poll?flag=pollvoted"
    static let kRegSec = "master?flag=reg-step-II"
    static let kDeviceInfo = "master?flag=deviceinfo"
    static let kNeighborhoodStatusByState = "master?flag=neighborhoodstatus"
    static let kFAQ = "master?flag=faq"
    static let kpollCreate = "poll?flag=createpoll"
    static var kNotificationCounta: String {
            let userid = UserDefaults.standard.string(forKey: "userid") ?? ""
            return "notificationcount.php?flag=counter&appkey=abc1239&userid=\(userid)"
        }  
    static let kpopVerify = "master?flag=popupVerifiedStatus"
    static let kpostDetail = "posting?flag=postdetails"
    static let kDeletePost = "posting?flag=deletepostbyuser"
    static let kDeletePostCmnd = "posting?flag=deletecomment"
    
    static let kpollEdit = "poll?flag=editpoll"
    static let kUploadedDocuments = "/master?flag=uploaddocs"
    static let kUpdateEvent = "event?flag=updateevent"
    static let kaboutUs = "aboutusapi?flag=aboutus"
    static let kHideNotification = "hide-notification?flag=hidenotification"
    static let kEventLikeList = "event?flag=eventlikeslist"
    static let kUpdateToken = "update-token"
    static let kEmailVerify = "verify-email"
    static let kDeactivate = "mobilesettings?flag=deactiveaccount"
    static let KUserDeletePic = "master?flag=deleteuserprofilephoto"
    static let KAwaitStatus = "master?flag=awaitstatus"
    static let kCommentPostLike = "posting?flag=likecomment"
    static let kDeleteMsg = "chat?flag=deletemessage"
    
    
    
    
    //https://dev.neighbrsnook.com/marketplace/api/
    
}
