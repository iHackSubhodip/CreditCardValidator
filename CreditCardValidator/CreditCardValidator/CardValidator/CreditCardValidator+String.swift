//
//  CreditCardValidator+String.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 16/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

public func ==(lhs: CreditCardValidationType, rhs: CreditCardValidationType) -> Bool {
    return lhs.name == rhs.name
}

public struct CreditCardValidationType: Equatable {
    
    public var name: String
    
    public var regex: String
    
    public init(dict: [String: Any]) {
        if let name = dict["name"] as? String {
            self.name = name
        } else {
            self.name = ""
        }
        
        if let regex = dict["regex"] as? String {
            self.regex = regex
        } else {
            self.regex = ""
        }
    }
    
}
