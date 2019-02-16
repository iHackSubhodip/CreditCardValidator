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
    
    
    private func setGradientBackground(view: UIView, top: CGColor, bottom: CGColor) {
        let colorTop =  top
        let colorBottom = bottom
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    
}


extension CreditCardView{
    
    //MARK:
    private func creditCardBaseViewSetup() {
        self.addSubview(creditCardBaseView)
        NSLayoutConstraint.activate([
            creditCardBaseView.topAnchor.constraint(equalTo: self.topAnchor),
            creditCardBaseView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            creditCardBaseView.widthAnchor.constraint(equalTo: self.widthAnchor),
            creditCardBaseView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    
    //MARK:
    private func creditCardFrontViewSetup(){
        self.addSubview(creditCardFrontView)
        setGradientBackground(view: creditCardFrontView, top: defaultCardColor.cgColor, bottom: defaultCardColor.cgColor)
        creditCardFrontView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        NSLayoutConstraint.activate([
            creditCardFrontView.topAnchor.constraint(equalTo: self.topAnchor),
            creditCardFrontView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            creditCardFrontView.widthAnchor.constraint(equalTo: self.widthAnchor),
            creditCardFrontView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    
    private func creditCardNumberMaskSetup(){
        cardNumberview.maskDelegate = self
        cardNumberview.maskExpression = cardNumberMaskExpression
        cardNumberview.maskTemplate = cardNumberMaskTemplate
        cardNumberview.textColor = cardHolderExpireDateColor
        cardNumberview.becomeFirstResponder()
        creditCardFrontView.addSubview(cardNumberview)
        
        NSLayoutConstraint.activate([
            cardNumberview.centerXAnchor.constraint(equalTo: creditCardFrontView.centerXAnchor),
            cardNumberview.centerYAnchor.constraint(equalTo: creditCardFrontView.centerYAnchor)
            ])
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==200)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardNumberview]));
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==30)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardNumberview]));
    }
    
    private func creditCardBandSetup(){
        creditCardFrontView.addSubview(cardBrandImageView)
        NSLayoutConstraint.activate([
            cardBrandImageView.topAnchor.constraint(equalTo: creditCardFrontView.topAnchor, constant: 10),
            cardBrandImageView.trailingAnchor.constraint(equalTo: creditCardFrontView.trailingAnchor, constant: -10)
            ])
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==60)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardBrandImageView]));
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardBrandImageView]));
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
    
}
