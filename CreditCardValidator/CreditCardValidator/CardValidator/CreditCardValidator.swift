//
//  CreditCardValidator.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 16/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

class CreditCardValidator{
    
    public lazy var types: [CreditCardValidationType] = {
        var types = [CreditCardValidationType]()
        for object in CreditCardValidator.types {
            types.append(CreditCardValidationType(dict: object))
        }
        return types
    }()
    
    public init() { }
    

    func type(from string: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            let numbersString = self.onlyNumbers(string: string)
            if predicate.evaluate(with: numbersString) {
                return type
            }
        }
        return nil
    }

    
    public func validate(string: String) -> Bool {
        let numbers = self.onlyNumbers(string: string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        let range: Range<String.Index> = numbers.startIndex..<numbers.endIndex
        
        numbers.enumerateSubstrings(in: range, options: [.reverse, .byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString
        
        for (i, s) in reversedArray.enumerated() {
            
            let digit = Int(String(s))!
            
            if i % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    /**
     Validate card number string for type
     
     - parameter string: card number string
     - parameter type:   CreditCardValidationType structure
     
     - returns: true or false
     */
    public func validate(string: String, forType type: CreditCardValidationType) -> Bool {
        return self.type(from: string) == type
    }
    
    public func onlyNumbers(string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    // MARK: - Loading data
    
    private static let types = [
        [
            "name": "Amex",
            "regex": "^3[47][0-9]{5,}$"
        ], [
            "name": "Visa",
            "regex": "^4[0-9]{6,}$"
        ], [
            "name": "MasterCard",
            "regex": "^5[1-5][0-9]{5,}$"
        ], [
            "name": "Maestro",
            "regex": "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        ], [
            "name": "Diners Club",
            "regex": "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        ], [
            "name": "JCB",
            "regex": "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        ], [
            "name": "Discover",
            "regex": "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        ], [
            "name": "UnionPay",
            "regex": "^62[0-5]\\d{13,16}$"
        ]
    ]
    
}
