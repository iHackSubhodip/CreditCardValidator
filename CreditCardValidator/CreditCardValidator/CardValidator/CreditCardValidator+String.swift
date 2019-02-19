//
//  CreditCardValidator+String.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 16/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

func ==(lhs: CreditCardValidationType, rhs: CreditCardValidationType) -> Bool {
    return lhs.name == rhs.name
}

 struct CreditCardValidationType: Equatable {
    
     var name: String
    
     var regex: String
    
     init(dict: [String: Any]) {
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
