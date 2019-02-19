//
//  CreditCardTextField+Protocols.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 19/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

protocol CreditCardTextFieldDelegate: class {
    
    func maskFieldShouldBeginEditing(_ maskField: CreditCardTextField) -> Bool
    
    func maskFieldDidBeginEditing(_ maskField: CreditCardTextField)
    
    func maskFieldShouldEndEditing(_ maskField: CreditCardTextField) -> Bool
    
    func maskFieldDidEndEditing(_ maskField: CreditCardTextField)
    
    func maskField(_ maskField: CreditCardTextField, didChangedWithEvent event: CreditCardTextFieldEvents)
    
    func maskField(_ maskField: CreditCardTextField, shouldChangeBlock block: CreditCardTextFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool
    
    func maskFieldShouldReturn(_ maskField: CreditCardTextField) -> Bool
}

extension CreditCardTextFieldDelegate {
    
    func maskFieldShouldBeginEditing(_ maskField: CreditCardTextField) -> Bool {
        return true
    }
    
    func maskFieldDidBeginEditing(_ maskField: CreditCardTextField) {}
    
    func maskFieldShouldEndEditing(_ maskField: CreditCardTextField) -> Bool {
        return true
    }
    
    func maskFieldDidEndEditing(_ maskField: CreditCardTextField) {}
    
    func maskField(_ maskField: CreditCardTextField, didChangedWithEvent event: CreditCardTextFieldEvents) {}
    
    func maskField(_ maskField: CreditCardTextField, shouldChangeBlock block: CreditCardTextFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool {
        return true
    }
    
    func maskFieldShouldReturn(_ maskField: CreditCardTextField) -> Bool {
        return true
    }
}
