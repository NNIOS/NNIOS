

import UIKit
import MediaPlayer
import NVActivityIndicatorView

extension Notification.Name {
    static let userListRefresh = Notification.Name("userListRefresh")
    static let likeRefresh = Notification.Name("likeRefresh")
    static let chatRefresh = Notification.Name("chatRefresh")
    static let LiveUserRefersh = Notification.Name("LiveUserRefersh")
    static let userremoved_add = Notification.Name("userremoved_add")
    static let movie_created = Notification.Name("movie_created")
}

// MARK: DATA
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

// MARK: AVAsset
extension AVAsset {
    var videoThumbnail:UIImage?{
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = self.duration
        time.value = min(time.value, 2)
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            
            print("Video Thumbnail genertated successfuly")
            
            return thumbNail
        } catch {
            print("error getting thumbnail video")
            return nil
            
        }
    }
}

// MARK: UIViewController
extension UIViewController {
    func convertToLocalDateFormatOnlyTime(utcDate:String) -> String {
        if utcDate.count == 0 {
            return ""
        } else {
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: utcDate)
            dateFormatter.timeZone = TimeZone.current
            
            let finalDateStr = dateFormatter.string(from: dt!)
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSSXXXXX"
            
            //  return dateFormatter.date(from: differenceDate!)
            return Date().offsetLong(date: dateFormatter.date(from: finalDateStr)!)
        }
    }
}

extension UIViewController {
    
    enum deviceType : String{
        case iPad
        case iPhone
        case other
    }
    
    func checkDevice () -> deviceType {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return .iPad
        } else if UIDevice.current.userInterfaceIdiom == .phone{
            return .iPhone
        } else {
            return .other
        }
    }
    
    enum VenueDaysList : String {
        case startTime_Wed
        case endTime_Thurs
        case endTime_Sun
        case endTime_Mon
        case startTime_Fri
        case startTime_Thurs
        case endTime_Wed
        case startTime_Sat
        case endTime_Fri
        case endTime_Tues
        case startTime_Sun
        case startTime_Mon
        case startTime_Tues
        case endTime_Sat
    }
}

//MARK: - Date
func convertDateFormaterSecond(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "dd MMM, yyyy"
    return  dateFormatter.string(from: date!)
    
}

func convertDateFormater(_ date: String) -> String {
    print(date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM, yyyy"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return  dateFormatter.string(from: date!)
    
}

func convertDateFormat(_ date: String, oldFormat: String, newFormat: String) -> String {
    print(date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = oldFormat
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = newFormat
    return  dateFormatter.string(from: date!)
    
}

func convertIntoDate(utcDate:String)-> String {
    if utcDate.count == 0 {
        return ""
    } else {
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: utcDate)
        // dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = "MMM dd,yyyy-MMM dd,yyyy"
        let finalDateStr = dateFormatter.string(from: dt!)
        //  return dateFormatter.date(from: differenceDate!)
        // return Date().offsetLong(date: dateFormatter.date(from: finalDateStr)!)
        return finalDateStr
    }
}

extension Date {
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offsetLong(date: Date) -> String {
        if years(from: date)   > 0 {
            if months(from: date)  < 12 {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            } else {
                return years(from: date) > 1 ? "\(years(from: date)) years ago" : "\(years(from: date)) year ago"
            }
        }
        if months(from: date)  > 0 {
            if weeks(from: date)   < 4 {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            } else {
                return months(from: date) > 1 ? "\(months(from: date)) months ago" : "\(months(from: date)) month ago"
            }
        }
        if weeks(from: date)   > 0 {
            if days(from: date)    < 7 {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            } else {
                return weeks(from: date) > 1 ? "\(weeks(from: date)) weeks ago" : "\(weeks(from: date)) week ago"
            }
        }
        if days(from: date)    > 0 {
            if hours(from: date)   < 24 {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            } else {
                return days(from: date) > 1 ? "\(days(from: date)) days ago" : "\(days(from: date)) day ago"
            }
        }
        if hours(from: date)   > 0 {
            if minutes(from: date) < 59 {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) min ago" : "\(minutes(from: date)) min ago"
            } else {
                return hours(from: date) > 1 ? "\(hours(from: date)) hours ago" : "\(hours(from: date)) hour ago"
            }
        }
        if minutes(from: date) > 0 {
            if seconds(from: date) < 59 {
                return seconds(from: date) > 1 ? "\(seconds(from: date)) sec ago" : "\(seconds(from: date)) sec ago"
            } else {
                return minutes(from: date) > 1 ? "\(minutes(from: date)) min ago" : "\(minutes(from: date)) min ago"
            }
        }
        if seconds(from: date) > 0 {
            return seconds(from: date) > 1 ? "\(seconds(from: date)) sec ago" : "\(seconds(from: date)) sec ago"
        }
        
        return "just now"
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   == 1 {
            return "\(years(from: date)) year"
        }
        else if years(from: date)   > 1 {
            return "\(years(from: date)) years"
        }
        
        if months(from: date)  == 1 {
            return "\(months(from: date)) month"
        } else if months(from: date)  > 1 {
            return "\(months(from: date)) month"
        }
        
        if weeks(from: date)   == 1 {
            return "\(weeks(from: date)) week"
        } else if weeks(from: date)   > 1 {
            return "\(weeks(from: date)) weeks"
        }
        
        if days(from: date)    == 1 {
            return "\(days(from: date)) day"
        } else if days(from: date)    > 1 {
            return "\(days(from: date)) days"
        }
        
        if hours(from: date)   == 1 {
            return "\(hours(from: date)) hour"
        } else if hours(from: date)   > 1 {
            return "\(hours(from: date)) hours"
        }
        
        if minutes(from: date) == 1 {
            return "\(minutes(from: date)) minute"
        } else if minutes(from: date) > 1 {
            return "\(minutes(from: date)) minutes"
        }
        return ""
    }
}

//MARK:  Array
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

//MARK: UIView
//extension UIView {
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//    
//    @IBInspectable
//    var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//    @IBInspectable
//    var borderColor: UIColor? {
//        get {
//            let color = UIColor.init(cgColor: layer.borderColor!)
//            return color
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//    
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowColor = UIColor.black.cgColor
//            layer.shadowOffset = CGSize(width: 0, height: 2)
//            layer.shadowOpacity = 0.4
//            layer.shadowRadius = newValue
//        }
//    }
//}

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}


//MARK: TextView
class UIPlaceholderTextView: UITextView {
    
    var placeholderLabel: UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshPlaceholder()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @IBInspectable var placeholder: String? {
        didSet {
            refreshPlaceholder()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? = .darkGray {
        didSet {
            refreshPlaceholder()
        }
    }
    
    @IBInspectable var placeholderFontSize: CGFloat = 14 {
        didSet {
            refreshPlaceholder()
        }
    }
    
    func refreshPlaceholder() {
        if placeholderLabel == nil {
            placeholderLabel = UILabel()
            let contentView = self.subviews.first ?? self
            contentView.addSubview(placeholderLabel!)
            placeholderLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            placeholderLabel?.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: textContainerInset.left + 4).isActive = true
            placeholderLabel?.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: textContainerInset.right + 4).isActive = true
            placeholderLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textContainerInset.top).isActive = true
            placeholderLabel?.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: textContainerInset.bottom)
        }
        placeholderLabel?.text = placeholder
        placeholderLabel?.textColor = placeholderColor
        placeholderLabel?.font = UIFont.systemFont(ofSize: placeholderFontSize)
    }
    
    @objc func textChanged() {
        if self.placeholder?.isEmpty ?? true {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            if self.text.isEmpty {
                self.placeholderLabel?.alpha = 1.0
            } else {
                self.placeholderLabel?.alpha = 0.0
            }
        }
    }
    
    override var text: String! {
        didSet {
            textChanged()
        }
    }
    
}

//MARK: TextField
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}

//MARK: UIButton
extension UIButton {
    func setButtonCornerRadius_Image(_ sender: UIButton, image: UIImage, cornerRadius: CGFloat, borderwidth: CGFloat, isClipBound: Bool, bordercolor: CGColor) {
        sender.setImage(image, for: .normal)
        sender.layer.cornerRadius = cornerRadius
        sender.layer.borderWidth = borderwidth
        sender.clipsToBounds = isClipBound

    }
}

//MARK: Dictionary
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

//MARK: MutableData
// for Multipart
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: .utf8, allowLossyConversion: true)
        append(data!)
    }
}

//MARK: - String
extension String {
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
}
