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
    }
    
}
