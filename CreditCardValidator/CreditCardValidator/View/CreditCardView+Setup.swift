//
//  CreditCardView+Setup.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 16/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit


extension CreditCardView{
    
    //MARK:
    func creditCardBaseViewSetup() {
        self.addSubview(creditCardBaseView)
        NSLayoutConstraint.activate([
            creditCardBaseView.topAnchor.constraint(equalTo: self.topAnchor),
            creditCardBaseView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            creditCardBaseView.widthAnchor.constraint(equalTo: self.widthAnchor),
            creditCardBaseView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    
    //MARK:
    func creditCardFrontViewSetup(){
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
    
    func creditCardNumberMaskSetup(){
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
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==220)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardNumberview]));
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==30)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardNumberview]));
    }
    
    
    
    func creditCardBandSetup(){
        creditCardFrontView.addSubview(cardBrandImageView)
        NSLayoutConstraint.activate([
            cardBrandImageView.topAnchor.constraint(equalTo: creditCardFrontView.topAnchor, constant: 10),
            cardBrandImageView.trailingAnchor.constraint(equalTo: creditCardFrontView.trailingAnchor, constant: -10)
            ])
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==60)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardBrandImageView]));
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": cardBrandImageView]));
    }
    
    func creditCardConfirmButtonSetup(){
        creditCardFrontView.addSubview(creditCardProceedButton)
        NSLayoutConstraint.activate([
            creditCardProceedButton.widthAnchor.constraint(equalToConstant: 100),
            creditCardProceedButton.heightAnchor.constraint(equalToConstant: 40),
            creditCardProceedButton.leadingAnchor.constraint(equalTo: cardNumberview.leadingAnchor),
            creditCardProceedButton.bottomAnchor.constraint(equalTo: creditCardFrontView.bottomAnchor, constant: -20)
            ])
    }
    
    func creditCardInvalidLabelSetup(){
        creditCardFrontView.addSubview(creditCardInvalidLabel)
        NSLayoutConstraint.activate([
            creditCardInvalidLabel.widthAnchor.constraint(equalToConstant: 200),
            creditCardInvalidLabel.heightAnchor.constraint(equalToConstant: 40),
            creditCardInvalidLabel.leadingAnchor.constraint(equalTo: cardNumberview.leadingAnchor),
            creditCardInvalidLabel.bottomAnchor.constraint(equalTo: creditCardFrontView.bottomAnchor, constant: -30)
            ])
    }
}


