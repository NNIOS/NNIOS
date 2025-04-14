import UIKit

class PollsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCreaterName: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblPolls: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblFavorite: UILabel!
    @IBOutlet weak var profileImgView : UIImageView!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var VoteBtn: UIButton!
    @IBOutlet weak var DotPollBtn: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var BgView: UIView!
    
    var DetailsCallback : ((UIButton) -> Void)?
    var ProfileCallback : ((UIButton) -> Void)?
    var DotCallback : ((UIButton) -> Void)?

    var userId: String?
    weak var delegateFav: ProfileFavTapDelegate?
    
    // Default storyboard colors
    private var defaultTextColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Save the default colors from storyboard
        defaultTextColor = lblCreaterName.textColor
        
        updateColors()
        addTapGestureToProfile()
    }
    
   
    private func updateColors() {
                // Optional binding for safety inside the function
                if let lblCreaterName = lblCreaterName,
                   let lblSec = lblSec,
                   let lblPolls = lblPolls,
                   let lblStartDate = lblStartDate,
                   let lblEndDate = lblEndDate,
                   let lblFavorite = lblFavorite,
                   let lblStart = lblStart,
                   let lblEnd = lblEnd,
                   let lblTime = lblTime,
                   let bgView = BgView {

                    if traitCollection.userInterfaceStyle == .dark {
                        // Dark mode colors
                        lblCreaterName.textColor = .white
                        lblSec.textColor = .white
                        lblPolls.textColor = .white
                        lblStartDate.textColor = .white
                        lblEndDate.textColor = .white
                        lblFavorite.textColor = .white
                        lblStart.textColor = .white
                        lblEnd.textColor = .white
                        lblTime.textColor = .white
                    } else {
                        // Light mode: use default colors
                        lblCreaterName.textColor = defaultTextColor
                        lblSec.textColor = .secondaryLabel
                        lblPolls.textColor = .secondaryLabel
                        lblStartDate.textColor = .secondaryLabel
                        lblEndDate.textColor = .secondaryLabel
                        lblFavorite.textColor = .secondaryLabel
                        lblStart.textColor = .secondaryLabel
                        lblEnd.textColor = .secondaryLabel
                        lblTime.textColor = .secondaryLabel
                        BgView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9411764706, alpha: 1)
                    }

                } else {
                    print("❗️One or more UI elements are nil. Skipping color update.")
                }
            }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }

    private func addTapGestureToProfile() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(tapGesture)
        
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblCreaterName.isUserInteractionEnabled = true
        lblCreaterName.addGestureRecognizer(nameTapGesture)
        
        let secTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        lblSec.isUserInteractionEnabled = true
        lblSec.addGestureRecognizer(secTapGesture)
    }
    
    @objc private func profileTapped() {
        if let userId = userId {
            delegateFav?.didTapProfile(userId: userId)
        }
    }
    
    @IBAction func btnDetails(_ sender: UIButton) {
        DetailsCallback?(sender)
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        ProfileCallback?(sender)
    }
    
    @IBAction func btnDotPoll(_ sender: UIButton) {
        DotCallback?(sender)
    }
}
