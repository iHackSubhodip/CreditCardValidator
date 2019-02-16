//
//  CreditCardValidator+String.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 16/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func isValidCardNumber() -> Bool {
        do {
            try CreditCardValidator.performLuhnAlgorithm(with: self)
            return true
        }
        catch {
            return false
        }
    }
    
    func cardType() -> CreditCardBrands? {
        let cardType = try? CreditCardValidator.cardType(for: self)
        return cardType
    }
    
    func suggestedCardType() -> CreditCardBrands? {
        let cardType = try? CreditCardValidator.cardType(for: self, suggest: true)
        return cardType
    }
    
    public func formattedCardNumber() -> String {
        let numbersOnlyEquivalent = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return numbersOnlyEquivalent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
