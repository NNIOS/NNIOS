import UIKit

@IBDesignable
class RSTextFieldCustomisation: UITextField {
  
  var currentText: (String) -> () = { _ in }
  
  // MARK: - Layout
  override public func layoutSubviews() {
    
    super.layoutSubviews()
    updateUnderLineFrame()
  }
  
    @IBInspectable override var cornerRadius: CGFloat {
    
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
  
    @IBInspectable override var borderWidth: CGFloat {
    
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
    @IBInspectable override var borderColor: UIColor? {
    
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }
  
  @IBInspectable var applyShadow: Bool = false {
    didSet {
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowOpacity = 0.5
      self.layer.shadowOffset = .zero
      self.layer.shadowRadius = 1
    }
  }
  
  /// Applies underline to the text field with the specified width
  @IBInspectable var underLineWidth: CGFloat = 0.0 {
    
    didSet {
      applyUnderLine()
    }
  }
  
  /// Sets the underline color
  @IBInspectable var underLineColor: UIColor = .tertiarySystemGroupedBackground {
    didSet {
      applyUnderLine()
    }
  }
  
  @IBInspectable var placeHolderColor: UIColor? {
    
    didSet {
    //  self.attributedPlaceholder = NSAttributedString(string: String.getString(self.placeholder), attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor ?? .lightText])
    }
  }
  
  // MARK: - Underline
  private var underLineLayer = CALayer()
  private func applyUnderLine() {
    
    // Apply underline only if the text view's has no borders
    if borderStyle == UITextField.BorderStyle.none {
      underLineLayer.removeFromSuperlayer()
      updateUnderLineFrame()
      updateUnderLineUI()
      layer.addSublayer(underLineLayer)
      layer.masksToBounds = true
    }
  }
  
  private func updateUnderLineFrame() {
    
    var rect = bounds
    rect.origin.y = bounds.height - underLineWidth
    rect.size.height = underLineWidth
    underLineLayer.frame = rect
  }
  
  private func updateUnderLineUI() {
    
    underLineLayer.backgroundColor = underLineColor.cgColor
  }
  
  @IBInspectable var leftPaddingViewImage: UIImage? {
    didSet
    {
      if leftPaddingViewImage != nil
      {
        let viewLeft = UIView(frame: CGRect.init(x: 0, y: 0, width: 44.0, height: 44.0))
        
        let imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: viewLeft.frame.size.height - 0, height: viewLeft.frame.size.height))
        imgView.contentMode = .left
        imgView.image = leftPaddingViewImage
        viewLeft.addSubview(imgView)
        
        let lblLine = UILabel.init(frame: CGRect.init(x: 32.0, y: 12, width: 1.0, height: 20))
        //lblLine.backgroundColor = ColorConstants.kAppUnderlineColor
        viewLeft.addSubview(lblLine)
        
        self.leftView = viewLeft
        self.leftViewMode = .always
      }
    }
  }
  
  @IBInspectable var rightPaddingViewImage: UIImage? {
    didSet
    {
      if rightPaddingViewImage != nil
      {
        let viewRight = UIView(frame: CGRect.init(x: 0, y: 0, width: 44.0, height: 44.0))
        
        let imgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: viewRight.frame.size.height, height: viewRight.frame.size.height))
        imgView.contentMode = .left
        imgView.image = rightPaddingViewImage
        viewRight.addSubview(imgView)
        
        self.rightView = viewRight
        self.rightViewMode = .always
      }
    }
  }
  
  @IBInspectable var leftPaddingWidth: CGFloat = 0.0 {
    didSet
    {
      let viewLeft = UIView(frame: CGRect.init(x: 0, y: 0, width: leftPaddingWidth, height: self.frame.size.height))
      self.leftView = viewLeft
      self.leftViewMode = .always
    }
  }
  
  func bind(callback :@escaping (String) -> ()) {
    
    self.currentText = callback
    self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  @objc func textFieldDidChange(_ textField :UITextField) {
    
  //  self.currentText(String.getString(textField.text))
  }
}

@IBDesignable
class AfterOneSecondTextField: UITextField {
    
    @IBInspectable var leftPaddingWidth: CGFloat = 0.0 {
      didSet
      {
        let viewLeft = UIView(frame: CGRect.init(x: 0, y: 0, width: leftPaddingWidth, height: self.frame.size.height))
        self.leftView = viewLeft
        self.leftViewMode = .always
      }
    }


    @IBInspectable var delayValue : Double = 1.0
    var timer:Timer?

    var actionClosure : (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(changedTextFieldValue), for: .editingChanged)
    }

    @objc func changedTextFieldValue(){
        timer?.invalidate()
        //setup timer
        timer = Timer.scheduledTimer(timeInterval: delayValue, target: self, selector: #selector(self.executeAction), userInfo: nil, repeats: false)
    }

    @objc func executeAction(){
        actionClosure?()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
