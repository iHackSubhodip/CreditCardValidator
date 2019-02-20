//
//  CreditCardView.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 14/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class CreditCardBaseView: UIView {}
@IBDesignable
class CreditCardFrontView: UIView {}

@IBDesignable
class CreditCardView: UIView {

    let creditCardBaseView: CreditCardBaseView = {
        let baseView = CreditCardBaseView()
        baseView.frame = .zero
        baseView.layer.cornerRadius = 8
        baseView.clipsToBounds = true
        baseView.translatesAutoresizingMaskIntoConstraints = false
        return baseView
    }()
    
    let creditCardFrontView: CreditCardFrontView = {
        let creditCardFrontView = CreditCardFrontView()
        creditCardFrontView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        creditCardFrontView.isUserInteractionEnabled = false
        creditCardFrontView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        creditCardFrontView.layer.cornerRadius = 8
        creditCardFrontView.clipsToBounds = true
        creditCardFrontView.translatesAutoresizingMaskIntoConstraints = false
        return creditCardFrontView
    }()
    
    var cardNumberview: CreditCardTextField = {
        let cardNumber = CreditCardTextField()
        cardNumber.translatesAutoresizingMaskIntoConstraints = false
        cardNumber.font = UIFont(name: "Menlo Bold", size: 17.0)
        cardNumber.frame = .zero
        return cardNumber
    }()
    
    var cardBrandImageView: UIImageView = {
        let cardBrandImageView = UIImageView()
        cardBrandImageView.translatesAutoresizingMaskIntoConstraints = false
        cardBrandImageView.contentMode = .scaleAspectFit
        cardBrandImageView.image = UIImage(named: "default")
        return cardBrandImageView
    }()
    
    var creditCardProceedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Verify now", for: .normal)
        button.setTitleColor(UIColor.hexStr(hexStr: "#3545AE", alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Menlo Regular", size: 10.0)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        return button
    }()
    
    var creditCardInvalidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Card info not found."
        label.font = UIFont(name: "Menlo Bold", size: 9.0)
        label.textColor = .white
        return label
    }()
    
    var gradientLayer = CAGradientLayer()
    var colors = [String : [UIColor]]()
    var amexCard = false
    
    
    @IBInspectable
     var defaultCardColor: UIColor = UIColor.hexStr(hexStr: "363434", alpha: 1) {
        didSet {
            gradientLayer.colors = [defaultCardColor.cgColor, defaultCardColor.cgColor]
        }
    }
    
    @IBInspectable
     var cardNumberMaskExpression = "{....} {....} {....} {....}" {
        didSet {
            cardNumberview.maskExpression = cardNumberMaskExpression
        }
    }
    
    @IBInspectable
     var cardNumberMaskTemplate = "XXXX XXXX XXXX XXXX" {
        didSet {
            cardNumberview.maskTemplate = cardNumberMaskTemplate
        }
    }
    
    @IBInspectable
     var cardHolderExpireDateColor: UIColor = .white {
        didSet {
            cardNumberview.textColor = cardHolderExpireDateColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCreditCardViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        createCreditCardViews()
    }
    
    
    func createCreditCardViews(){
        creditCardProceedButton.isHidden = true
        creditCardInvalidLabel.isHidden = true
        
        if colors.count < 6 {
            setCreditCradBrandColors()
        }
        creditCardBaseViewSetup()
        creditCardFrontViewSetup()
        creditCardNumberMaskSetup()
        creditCardBandSetup()
        creditCardConfirmButtonSetup()
        creditCardInvalidLabelSetup()
    }
    

    
     func paymentCardTextFieldDidChange(cardNumber: String? = "") {
        
        self.cardNumberview.text = cardNumber
        creditCardProceedButton.isHidden = true
        creditCardInvalidLabel.isHidden = true
        
        guard let cardN = cardNumber else {
            return
        }
        
        if (cardN.count == 0)
        {
            self.cardNumberview.maskExpression = "{....} {....} {....} {....}"
        }
        
        let validator = CreditCardValidator()
        if (cardN.count >= 7 || cardN.count < 4) {
            
            guard let type = validator.type(from: "\(cardN as String?)") else {
                self.cardBrandImageView.image = UIImage(named: "default")
                if let name = colors["NONE"] {
                    setType(colors: [name[0], name[1]], alpha: 0.5)
                }
                return
            }
            
            if let name = colors[type.name] {
                
                if cardNumberview.maskStatus == .complete{
                    let isCardValid = validator.validate(string: "\(cardN as String?)")
                    if isCardValid{
                        creditCardProceedButton.isHidden = false
                    }else{
                        creditCardInvalidLabel.isHidden = false
                        return
                    }
                }
                
                if(type.name.lowercased() == "amex".lowercased()){
                    if !amexCard {
                        amexCard = true
                    }
                }else {
                    amexCard = false
                }
                self.cardBrandImageView.image = UIImage(named: type.name)
                setType(colors: [name[0], name[1]], alpha: 1)
            }else{
                creditCardInvalidLabel.isHidden = false
                setType(colors: [self.colors["DEFAULT"]![0], self.colors["DEFAULT"]![0]], alpha: 1)
            }
            
            
        }
    }
    
}




