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
        baseView.layer.cornerRadius = 6
        baseView.clipsToBounds = true
        baseView.translatesAutoresizingMaskIntoConstraints = false
        return baseView
    }()
    
    let creditCardFrontView: CreditCardFrontView = {
        let creditCardFrontView = CreditCardFrontView()
        creditCardFrontView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        creditCardFrontView.layer.cornerRadius = 6
        creditCardFrontView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        creditCardFrontView.layer.cornerRadius = 6
        creditCardFrontView.clipsToBounds = true
        creditCardFrontView.translatesAutoresizingMaskIntoConstraints = false
        return creditCardFrontView
    }()
    
    fileprivate var gradientLayer = CAGradientLayer()
    
    @IBInspectable
    public var defaultCardColor: UIColor = UIColor.hexStr(hexStr: "363434", alpha: 1) {
        didSet {
            gradientLayer.colors = [defaultCardColor.cgColor, defaultCardColor.cgColor]
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
    
}
