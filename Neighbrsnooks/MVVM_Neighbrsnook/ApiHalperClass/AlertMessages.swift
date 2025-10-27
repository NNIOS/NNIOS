//
//  AlertMessages.swift
//  Manish Mishra
//
//  Created by Manish on 6/17/21.
//  Copyright © 2021 Manish Mishra. All rights reserved.
//

import Foundation
import UIKit

//Screen Size
let screenSize = UIScreen.main.bounds
let screenHeight = screenSize.height
let screenWidth = screenSize.width

//Alert Messages
struct AlertMessages {
//    OLD   by Puneet Sir
    static let alertTitle               = "Project Name"
    static let AlertMessages            = "Something went wrong!!"
    static let enterDoc                 = "Please Upload all documents"
    static let invalidEmail             = "Please Enter Valid Email Address."
    static let emptyEmail               = "Please Enter Email Address."
    static let invalidOTP               = "Please Enter Valid OTP."
    static let emptyPassword            = "Please Enter Password."
    static let limitPassword            = "Password Should be atleast 8 characters long."
    static let firstName                = "Please Enter First Name."
    static let lastName                 = "Please Enter Last Name."
    static let gender                   = "Please Select Gender."
    static let fees                     = "Please Enter Consultation fee."
    static let dob                      = "Please Select Date of Birth."
    static let otp                      = "Please Enter OTP"
    static let terms                    = "Please Accept Term & Conditions"
    static let emptyConfirmPassword     = "Please Enter Confirm Password."
    static let passwordsDoNotMatch      = "Password and Confirm Password doesn't Match"
    static let changePasswordsDoNotMatch = "Change Password and Confirm Password doesn't match"
    static let emptyPhoneNumber         = "Please Enter Phone Number."
    static let subject                  = "Please Enter Subject."
    static let comment                  = "Please enter comment."
    static let limitPhoneNumber         = "Please enter valid phone number."
    static let location                 = "Please enter location"
    static let noProfileImage           = "Please choose a profile image."
    static let emptyOldPassword         = "Please enter current password."
    static let emptyNewPassword         = "Please enter new password."
    static let passwordChanged          = "Your password has been changed successfully."
    static let emlptyName               = "Please enter name."
    static let logout                   = "Are you sure you want to log out?"
    
//    by Manish
    
//    NoInternetConnection
    static let NoInternetConnection     = "Please check your internet connection."
    
    
//    ApplyLeave
    static let leaveoption              = "Please select leave option"
    static let leaveType                = "Please select Leave type"
    static let leaveFromDate            = "Please enter date from leave"
    static let leaveToDate              = "Please select date till you want leave"
    static let leaveReason              = "Please enter reason for leave."
    
//    Reimburse
    static let reimburseDate            = "Please enter date. "
    static let reimburseAmount          = "Please enter amount for reimburse."
    static let reimburseDetail          = "Please enter description."
    
//    Profile
    static let profileAddress           = "Please enter address"
    
//    Login
    static let loginMailEmpty           = "Email cannot be empty"
    static let loginMailInvalid         = "Invalid Email-id, Please enter valid email-id."
    static let loginPasswordEmpty       = "Password cannot be empty."
    static let loginPasswordShort       = "Password is too short."
    static let loginPasswordLong        = "Password is too long."
    
//    Registration
    static let signupFirstNameEmpty     = "Please enter first name"
    static let signupFirstNameShort     = "First name is too short"
    static let signupFirstNameLong      = "First name must be below 12 characters"
    static let signupLastnameEmpty      = "Please enter last name"
    static let signupLastNameShort      = "Last name is too short"
    static let signupLastNameLong       = "Last name must be below 12 characters"
    static let signupMobileEmpty        = "Mobile Number can't be empty"
    static let signupMobileValidation   = "Please enter more than 7 digits or less than 14 digits mobile number."
    static let signupDOJEmpty           = "Date of Joining cannot be empty."
    static let signupDesignationEmpty   = "Designation cannot be empty."
    static let signupTCAccept           = "Please accept Terms & Conditions."
    
//    VerifyEmail
    static let verifyOTPEmpty           = "OTP cannot be empty"
    static let verifyOTPNotFill         = "Please enter all 4 digits"
    
//    ChangePassword
    static let newPasswordEmpty         = "Please enter new password"
    static let newPasswordShort         = "Please enter 6 to 15 charactes password"
    static let newPasswordLong          = "Please enter 6 to 15 charactes password"
    static let confirmPasswordEmpty     = "Please enter confirm password"
    static let newPasswordConfirmPasswordUnmatch = "Password & Confirm password are not matched"
    
}

struct WebServiceCallErrorMessage {
    static let ErrorInvalidDataFormatMessage    = "Please try again, server not reachable";
    static let ErrorServerNotReachableMessage   = "Server Not Reachable";
    static let ErrorInternetConnectionNotAvailableMessage
        = "OOPS! Looks like you don't have internet access at this moment..."
    static let ErrorTitleInternetConnectionNotAvailableMessage
        = "Network Error.";
    static let ErrorNoDataFoundMessage          = "No Data Available";
    static let ErrorOccuredMessage              = "Error occurred! Please try again"
}
