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
        creditCardFrontView.layer.cornerRadius = 8
        creditCardFrontView.isUserInteractionEnabled = false
        creditCardFrontView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        creditCardFrontView.layer.cornerRadius = 6
        creditCardFrontView.clipsToBounds = true
        creditCardFrontView.translatesAutoresizingMaskIntoConstraints = false
        return creditCardFrontView
    }()
    
    var cardNumberview: AKMaskField = {
        let cardNumber = AKMaskField()
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
    
    fileprivate var gradientLayer = CAGradientLayer()
    public var colors = [String : [UIColor]]()
    var amexCard = false
    
    @IBInspectable
    public var defaultCardColor: UIColor = UIColor.hexStr(hexStr: "363434", alpha: 1) {
        didSet {
            gradientLayer.colors = [defaultCardColor.cgColor, defaultCardColor.cgColor]
        }
    }
    
    @IBInspectable
    public var cardNumberMaskExpression = "{....} {....} {....} {....}" {
        didSet {
            cardNumberview.maskExpression = cardNumberMaskExpression
        }
    }
    
    @IBInspectable
    public var cardNumberMaskTemplate = "XXXX XXXX XXXX XXXX" {
        didSet {
            cardNumberview.maskTemplate = cardNumberMaskTemplate
        }
    }
    
    @IBInspectable
    public var cardHolderExpireDateColor: UIColor = .white {
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        createCreditCardViews()
    }
    
    
    func createCreditCardViews(){
        if colors.count < 6 {
            setCreditCradBrandColors()
        }
        creditCardBaseViewSetup()
        creditCardFrontViewSetup()
        creditCardNumberMaskSetup()
        creditCardBandSetup()
    }
    
    
    func setGradientBackground(view: UIView, top: CGColor, bottom: CGColor) {
        let colorTop =  top
        let colorBottom = bottom
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    func setType(colors: [UIColor], alpha: CGFloat, back: UIColor) {
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.gradientLayer.colors = [colors[0].cgColor, colors[1].cgColor]
        })
    }
    
    public func paymentCardTextFieldDidChange(cardNumber: String? = "") {
        self.cardNumberview.text = cardNumber
        
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
                self.cardBrandImageView.image = nil
                if let name = colors["NONE"] {
                    setType(colors: [name[0], name[1]], alpha: 0.5, back: name[0])
                }
                return
            }
            
            // Visa, Mastercard, Amex etc.
            if let name = colors[type.name] {
                if(type.name.lowercased() == "amex".lowercased()){
                    if !amexCard {
                        self.cardNumberview.maskExpression = "{....} {....} {....} {...}"
                        amexCard = true
                    }
                }else {
                    amexCard = false
                }
                self.cardBrandImageView.image = UIImage(named: type.name)
                setType(colors: [name[0], name[1]], alpha: 1, back: name[0])
            }else{
                setType(colors: [self.colors["DEFAULT"]![0], self.colors["DEFAULT"]![0]], alpha: 1, back: self.colors["DEFAULT"]![0])
            }
        }
    }
    
}

extension CreditCardView{
    func setCreditCradBrandColors() {
        colors[CreditCardBrands.NONE.rawValue] = [defaultCardColor, defaultCardColor]
        colors[CreditCardBrands.Visa.rawValue] = [UIColor.hexStr(hexStr: "#5D8BF2", alpha: 1), UIColor.hexStr(hexStr: "#3545AE", alpha: 1)]
        colors[CreditCardBrands.MasterCard.rawValue] = [UIColor.hexStr(hexStr: "#ED495A", alpha: 1), UIColor.hexStr(hexStr: "#8B1A2B", alpha: 1)]
        colors[CreditCardBrands.Amex.rawValue] = [UIColor.hexStr(hexStr: "#005B9D", alpha: 1), UIColor.hexStr(hexStr: "#132972", alpha: 1)]
        colors["Diners Club"] = [UIColor.hexStr(hexStr: "#5b99d8", alpha: 1), UIColor.hexStr(hexStr: "#4186CD", alpha: 1)]
        colors[CreditCardBrands.Discover.rawValue] = [UIColor.hexStr(hexStr: "#e8a258", alpha: 1), UIColor.hexStr(hexStr: "#D97B16", alpha: 1)]
        colors[CreditCardBrands.DEFAULT.rawValue] = [UIColor.hexStr(hexStr: "#5D8BF2", alpha: 1), UIColor.hexStr(hexStr: "#3545AE", alpha: 1)]
    }
}

extension CreditCardView: AKMaskFieldDelegate{
    
    func maskField(_ maskField: AKMaskField, shouldChangeBlock block: AKMaskFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool {
        if maskField == cardNumberview {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func maskField(_ maskField: AKMaskField, didChangedWithEvent event: AKMaskFieldEvent) {
        paymentCardTextFieldDidChange(cardNumber: maskField.text)
    }
    
    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
        print("end")
    }
    
    func maskFieldShouldEndEditing(_ maskField: AKMaskField) -> Bool {
        print("aaa")
        return true
    }
    
    
}

