import Foundation
import UIKit


struct GeneralConstants {
  
  static let kAppName = "TajerHub"
  static let kDeviceType = "1"
  static let kGoogleClientId = ""
  static let kUserExist = "This username is available"
  static let kSettings = ["Account","Privacy","Notifications"]
  static let kPrivacy = ["Blocks Profile","My Saved Post","Make Account Private"]
  static let kReason = ["Quality issue","Price issue","Others"]
  static let kReport = ["It's Spam","It's Inappropriate","Hate Speech or Symbol","Others"]
}

@available(iOS 16.0, *)
struct FunctionsConstants {
  static let kSharedUserDefaults = UserDefaults.standard
  static let kShared = Shared.sharedInstance
  static let kSharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
  static let kScreenWidth = UIScreen.main.bounds.width
  static let kScreenHeight = UIScreen.main.bounds.height
}

func print_debug(_ items: Any) {
  #if DEBUG
  print(items)
  #endif
}

func print_debug_fake(items: Any) {
}

struct AlertConstants {
  
  static var OK: String { return NSLocalizedString("Ok", comment: "") }
  static var CANCEL: String { return NSLocalizedString("Cancel", comment: "") }
  static var DONE: String { return NSLocalizedString("Done", comment: "") }
  static var SUBMIT: String { return NSLocalizedString("Submit", comment: "") }
  static var LOGOUT: String { return NSLocalizedString("Are you sure you want to log out?", comment: "") }
  static var PLEASE_LOGIN_AGAIN: String { return NSLocalizedString("You have been logged out of the system. Please login again.", comment: "") }
  static var PLEASE_ENTER_VALID_EMAIL: String { return NSLocalizedString("Please enter a valid email address", comment: "") }
  static var PLEASE_ENTER_VALID_PASSWORD: String { return NSLocalizedString("Password must contain 8 characters which includes at least a number and an alphabet", comment: "") }
  static var PLEASE_ENTER_VALID_PHONE_NUMBER: String { return NSLocalizedString("Please enter a valid phone number", comment: "") }
  static var PLEASE_ENTER_VALID_CONFIRM_PASSWORD: String { return NSLocalizedString("Confirm Password must contain 8 characters which includes at least a number and an alphabet", comment: "") }
  static var PLEASE_ENTER_IDENTICAL_VALUES: String { return NSLocalizedString("Please enter identical values in password and confirm password field", comment: "") }
  static var PLEASE_ENTER_VALID_NEW_PASSWORD: String { return NSLocalizedString("New Password must contain 8 characters which includes at least a number and an alphabet", comment: "") }
  static var PLEASE_SELECT_COUNTRY: String { return NSLocalizedString("Choose Country", comment: "") }
  static var OTP_SENT_SUCCESSFULLY: String { return NSLocalizedString("OTP Sent Successfully", comment: "") }
  static var PLEASE_ENTER_FIRST_NAME: String { return NSLocalizedString("Please enter a valid first name", comment: "") }
  static var PLEASE_ENTER_LAST_NAME: String { return NSLocalizedString("Please enter a valid last name", comment: "") }
    static var PLEASE_ENTER_LAST_User_NAME: String { return NSLocalizedString("Please enter a valid User Name", comment: "") }
  static var PLEASE_ACCEPT_TERMS: String { return NSLocalizedString("Please accept terms & conditions", comment: "") }
  static var Enter_Unique_Username: String { return NSLocalizedString("Please enter a unique user name", comment: "") }

  static var PLEASE_CHOOSE_INTERESTS: String { return NSLocalizedString("Please choose atleast one interest", comment: "") }
  static var PLEASE_ENTER_NAME: String { return NSLocalizedString("Please enter a valid name", comment: "") }
  static var PLEASE_ENTER_Flat: String { return NSLocalizedString("Please enter flat no", comment: "") }
  static var PLEASE_ENTER_City: String { return NSLocalizedString("Please enter city", comment: "") }
  static var PLEASE_ENTER_Zipcode: String { return NSLocalizedString("Please enter Zipcode", comment: "") }
  static var PLEASE_Select_Address: String { return NSLocalizedString("Please select an address", comment: "") }
  static var PLEASE_Rate: String { return NSLocalizedString("Please rate product", comment: "") }
  static var PLEASE_Enter_Description: String { return NSLocalizedString("Please enter Comment", comment: "") }
  static var PLEASE_Enter_OldPassword: String { return NSLocalizedString("Please enter Current password", comment: "") }
  static var PLEASE_Enter_New_Password: String { return NSLocalizedString("Please enter new password", comment: "") }
  static var Password_Match: String { return NSLocalizedString("Please check the password", comment: "") }
  static var PlaceBid: String { return NSLocalizedString("Please place a bid higher then the current Bid", comment: "") }
  static var enter_comment: String { return NSLocalizedString("Please enter the comment", comment: "") }

}

//struct FunctionsConstants {
//  static let kSharedUserDefaults = UserDefaults.standard
////  static let kShared = Shared.sharedInstance
//  static let kSharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
//  static let kScreenWidth = UIScreen.main.bounds.width
//  static let kScreenHeight = UIScreen.main.bounds.height
//}

extension Notification.Name {
  
}

struct ColorConstants {
  
}

struct StoryboardConstants {
  
  static let kLogin = "Login"
  static let kHome = "Home"
  static let kSocial = "Social"
}

struct KeyConstants {
  static let kDeviceToken = "deviceToken"
  static let kUserDetails = "userDetails"
  static let kError = "error"
  static let kAccessToken = "access_token"
  static let kData = "data"
  static let kEmail = "email"
  static let kPassword = "password"
  static let kName = "name"
  static let kImage = "image"
  static let kMobile = "mobile"
  static let kMessage = "message"
  static let kId = "_id"
  static let kDeviceType = "deviceType"
  static let kMobileNumber = "mobileNumber"
  static let kCountryCode = "countryCode"
  static let kCountry = "country"
  static let kVerificationCode = "verificationCode"
  static let kFirstName = "firstName"
  static let kLastName = "lastName"
  static let kUserName = "user_name"
  static let kSocialUserId = "social_user_id"
  static let kProfileImage = "profile_image"
  static let kSocialId = "social_id"
  static let kSocialType = "social_type"
  static let kAccountType = "account_type"
  static let kDob = "date_of_birth"
  static let kGender = "gender"
  static let kBio = "bio"
  static let kIsVerified = "is_verified"
  static let kIsProfileCompleted = "is_profile_completed"
  static let kTitle = "title"
  static let kIcon = "icon"
  static let kInterests = "interests"
  static let kPath = "path"
  static let kCurrency = "SAR"
  static let kCategoryId = "categoryId"
  static let kCategory = "category"    
  static let kProductId = "product_id"
  static let kQuantity = "quantity"
  static let kColour = "colour"
  static let kSize = "size"
  static let kSellerId = "seller_id"
  static let kcartQuantity = "1"
  //static let kCategory = "category"
  static let kSubcategory = "subcategory"
  static let kAddressId = "address_id"
  static let kLatitude = "latitude"
  static let kLongitude = "longitude"
  static let kAddressLine = "addressLine"
  static let kAdresseeName = "adressee_name"
  static let kMobileNumber1 = "mobileNumber1"
  static let kMobileNumber2 = "mobileNumber2"
  static let kHouseAddress = "house_address"
  static let kStreetAddress = "street_address"
  static let kLandmark = "landmark"
  static let kCity = "city"
  static let kPincode = "pincode"
  static let kIsDefault = "is_default"
  static let kPaymentMethod = "payment_method"
  static let kTotalAmount = "total_amount"
  static let kPayableAmount = "payable_amount"
  static let kDeliveryCharge = "delivery_charge"
  static let kDiscountAmount = "discount_amount"
  static let kTaxAmount = "tax_amount"
  static let kFilterType = "filter_type"
  static let kProductRating = "product_rating"
  static let kProductRatingDescription = "product_rating_description"
  static let KlikeMost = "like_most"
  static let KSellerRating = "seller_rating"
  static let KSellerRatingDescription = "seller_rating_description"
  static let KSizes = "sizes"
  static let KMinPrice = "minPrice"
  static let KMaxPrice = "maxPrice"
  static let KBrands = "brand"
  static let KColours = "colours"
  static let KSortQuery = "sortQuery"
  static let KBidId = "bidId"
  static let KItemId = "item_id"
  static let KBidAmount = "bid_amount"
  static let KOldPassword = "oldPassword"
  static let KNewPassword = "newPassword"
  static let KPostType = "postType"
  static let KPostImages = "postImages"
    static let KBussinessImages = "image"
  static let KPostCaption = "postCaption"
  static let KTaggedPeopleIds = "tagged_people_ids"
  static let Kusername = "username"
  static let KFollowingId = "following_id"
  static let KPostId = "postId"
  static let KComment = "comment"
  static let KIsPrivate = "is_private"
  static let KUserId = "userId"
  static let KReason = "reason"
  static let KBidType = "bid_type"
  static let KBlockedId = "blocked_id"
  static let KBiddingId = "bidding_id"
  static let KCommentId = "commentId"
  static let KFollowerId = "follower_id"

  static let kType = "type"
  static let kIsRead = "is_read"
  static let kTimeStamp = "timeStamp"
  static let kUserImage = "user_img"
  static let kLastMessage = "last_msg"
  //static let kSenderId = "sender_id"
  static let kLastMessageTime = "last_msg_time"
  static let Conversation = "Conversation"
  static let ChatList = "chatList"
  static let KBlockList = "blockList"    
  static let kUserId = "user_id"
  static let kMsgType = "msg_type"
  static let KIsBlocked = "blocked_status"
  static let KBlockedBy = "blocked_by"
  static let KOrderId = "orderId"
  static let KCancelReason = "cancel_reason"
   

}



enum HTTPStatusCodeConstants {
  
  case NO_RESPONSE
  case SUCCESS
  case CREATED
  case ACCEPTED
  case NO_CONTENT
  case UNAUTHORIZED
  case BAD_REQUEST
  case FORBIDDEN
  case NOT_FOUND
  case METHOD_NOT_ALLOWED
  case CONFLICT
  case USER_EXISTS
}

enum DeviceType: String {
  
  case iOS = "1"
  case android = "2"
}

enum PushedFrom: Int {
  
  case none = 0
  case signUp
  case forgotPassword
    case login
    case profile
    case businessInfo
    case home
    case advertDetails
    case sellerStore
    case advertOtherDetails
    case viewAllFromAdOtherDetails
    case search
    case chatList
    case similarItems
    case filter
    case saveSearch
    case notification
    case product
    case store
}

enum OnlineStatus: Int {
  
  case notAvailable = 0
}

extension Notification.Name {
  
  static let LocationUpdate = Notification.Name.init("locationUpdated")
  static let LocationNotFound = Notification.Name.init("locationNotFound")
  static let showAlert = Notification.Name.init("showAlert")
  static let showLogoutAlert = Notification.Name.init("showLogoutAlert")
  static let showApplicableViewC = Notification.Name.init("ShowApplicableViewC")
}

enum OTPVerificationStatus: Int {
  
  case notVerified = 0
  case verified
}

enum ProfileCompletionStatus: Int {
  case profileDetailsCompleted = 1
  case documentsUploaded
}

enum SelectedOption: Int {
  
  case none = 0
}

enum LoginType: Int {
  
  case none = 0
  case google
  case facebook
  case twitter
  case apple
}

struct BrokenRule {
  
  var propertyName :String
  var message :String
}

protocol ValidationViewModel {
  
  var brokenRules: [BrokenRule] { get set }
  var isValid: Bool { mutating get }
}


