import UIKit

@IBDesignable
class RSLabelCustomisation: UILabel {
  
  override func layoutSubviews() {
    
    super.layoutSubviews()
  }
  
    @IBInspectable override var cornerRadius: CGFloat  {
    
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = false
    }
  }
  
  @IBInspectable var isCircle: Bool = false {
    
    didSet {
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
    @IBInspectable override var borderWidth: CGFloat  {
    
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
    @IBInspectable override var borderColor: UIColor? {
    
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }
}
