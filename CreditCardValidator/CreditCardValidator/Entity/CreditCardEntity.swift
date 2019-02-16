//
//  CreditCardEntity.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 15/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation

public enum CreditCardBrands: Int{
    case amex = 0
    case visa
    case mastercard
    case discover
    case dinersClub
}

enum CardError: Error {
    case unsupported
    case invalid
}

class CreditCardEntity{
    
    class func regularExpression(for cardType: CreditCardBrands) -> String {
        switch cardType {
        case .amex:
            return "^3[47][0-9]{5,}$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$"
        case .visa:
            return "^4[0-9]{6,}$"
        }
    }
    
    class func suggestionRegularExpression(for cardType: CreditCardBrands) -> String {
        switch cardType {
        case .amex:
            return "^3[47][0-9]+$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]+$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]+$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$"
        case .visa:
            return "^4[0-9]+$"
        }
    }
}

