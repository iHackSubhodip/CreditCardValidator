//
//  CreditCardTextFieldPattern.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 19/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

enum CreditCardTextFieldPattern: String {
    
    //  MARK: - Constants
    
    case NumberDecimal = "d"
    case NonDecimal    = "D"
    case NonWord       = "W"
    case Alphabet      = "a"
    case AnyChar       = "."
    
    /// Returns regular expression pattern.
    
    func pattern() -> String {
        switch self {
        case .NumberDecimal   : return "\\d"
        case .NonDecimal      : return "\\D"
        case .NonWord         : return "\\W"
        case .Alphabet        : return "[a-zA-Z]"
        default               : return "."
        }
    }
}
