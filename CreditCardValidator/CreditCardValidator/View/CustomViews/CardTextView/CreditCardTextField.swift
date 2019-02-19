//
//  CreditCardTextField.swift
//  CreditCardValidator
//
//  Created by Banerjee,Subhodip on 19/02/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation
import UIKit

class CreditCardTextField: UITextField, UITextFieldDelegate  {
    
    //  MARK: - Configuring the Mask Field
    
    var isVisited = false
    
    @IBInspectable  var maskExpression: String? {
        didSet {
            
            if guardMask {
                return
            }
            
            let brackets = CreditCardTextFieldUtility.matchesInString(maskExpression!, pattern: "(?<=\\\(maskBlockBrackets.left)).*?(?=\\\(maskBlockBrackets.right))")
            
            if brackets.isEmpty {
                return
            }
            
            delegate = self
            
            // Save initial text
            
            maskTemplateText = maskExpression
            
            // Create mast object
            
            maskBlocks = [CreditCardTextFieldBlock]()
            
            for (i, bracket) in brackets.enumerated() {
                
                // Characters
                
                var characters = [CreditCardTextFieldBlockCharacter]()
                
                for y in 0..<bracket.range.length {
                    
                    let patternRange  = NSMakeRange(bracket.range.location + y, 1)
                    var templateRange = patternRange
                    templateRange.location -=  i * 2 + 1
                    
                    let pattern = CreditCardTextFieldPattern(rawValue: CreditCardTextFieldUtility.substring(maskExpression, withNSRange: patternRange))
                    
                    characters.append(CreditCardTextFieldBlockCharacter(
                        index : y,
                        blockIndex : i,
                        status : .clear,
                        pattern : pattern,
                        patternRange : patternRange,
                        template : maskTemplateDefault,
                        templateRange : templateRange))
                }
                
                // Blocks
                
                maskBlocks.append(CreditCardTextFieldBlock(
                    index : i,
                    chars : characters))
                
                updateMaskTemplateTextFromBlock(i)
            }
            
            // Refresh field & text
            
            updateMaskTemplateText()
        }
    }
    
    /// Default character for the mask templates initialization.
    
    fileprivate var maskTemplateDefault: Character = "*"
    
    @IBInspectable  var maskTemplate: String = "*" {
        didSet {
            
            if guardMask {
                return
            }
            
            maskTemplateText = maskExpression
            
            var copy: Bool = true
            var _maskTemplate = String(maskTemplateDefault)
            
            if maskTemplate.count == maskExpression!.count - (maskBlocks.count * 2) {
                copy = false
                _maskTemplate = maskTemplate
            } else if maskTemplate.count == 1 {
                _maskTemplate = maskTemplate
            }
            
            for block in maskBlocks {
                for char in block.chars {
                    maskBlocks[char.blockIndex].chars[char.index].template = copy
                        ? Character(_maskTemplate)
                        : Character(CreditCardTextFieldUtility.substring(maskTemplate, withNSRange: char.templateRange))
                }
                
                updateMaskTemplateTextFromBlock(block.index)
            }
            
            // Refresh field & text
            
            updateMaskTemplateText()
        }
    }
    
    /**
     
     Use this method to set the mask and template parameters.
     
     - parameter mask : The string value that has blocks with symbols that determine the certain format of input data.
     - parameter maskTemplate : The text that represents the mask filed with replacing mask symbol by template character.
     
     */
    
    func setMask(_ mask: String, withMaskTemplate maskTemplate: String!) {
        maskExpression = mask
        self.maskTemplate = maskTemplate ?? String(maskTemplateDefault)
    }
    
    /**
     
      and close bracket character for the mask block.
     
     Default value of this property is `{` and `}`.
     
     */
    
     var maskBlockBrackets: CreditCardTextFieldBraces = CreditCardTextFieldBraces(left: "{", right: "}")
    
    //  MARK: - Mask Field actions
    
    /// Set new text for the mask field. Equal to select all and paste actions.
    
     override var text: String?  {
        didSet {
            
            guard let maskText = maskText else {
                super.text = text
                return
            }
            
            _ = textField(self, shouldChangeCharactersIn: NSMakeRange(0, maskText.count), replacementString: text ?? "")
        }
    }
    
    /// Manually refresh the mask field
    
     func refreshMask() {
        
        if guardMask {
            return
        }
        
        if maskStatus == .clear {
            if placeholder != nil {
                super.text = nil
            } else {
                super.text = maskTemplateText
            }
        } else {
            super.text = maskText
        }
        
        moveCarret()
    }
    
    weak var maskDelegate: CreditCardTextFieldDelegate?
    
     var maskStatus: CreditCardTextFieldStatus {
        
        let maskBlocksChars = maskBlocks.flatMap { $0.chars }
        let completedChars  = maskBlocksChars.filter { $0.status == .complete }
        
        switch completedChars.count {
        case 0                     : return .clear
        case maskBlocksChars.count : return .complete
        default                    : return .incomplete
        }
    }
    
    
     var maskBlocks: [CreditCardTextFieldBlock] = [CreditCardTextFieldBlock]()
    
    //  MARK: - Options
    
    /// Jumps to previous block when cursor is placed between brackets or before first character in current block.
    
     var jumpToPrevBlock: Bool = false
    
    //  MARK: - Displayed Properties
    
    fileprivate var maskText: String!
    
    fileprivate var maskTemplateText: String!
    
     override var placeholder: String?  {
        didSet {
            refreshMask()
        }
    }
    //  MARK: - Helper methods & Properties
    
    fileprivate var guardMask: Bool {
        guard let mask = maskExpression, !maskBlocks.isEmpty || !mask.isEmpty else {
            
            super.text = nil
            delegate = nil
            
            maskText = nil
            maskTemplateText = nil
            maskBlocks = []
            
            return true
        }
        return false
    }
    
    /// Returns next character from target location
    
    fileprivate func getNetCharacter(_ chars: [CreditCardTextFieldBlockCharacter], fromLocation location: Int) -> (char: CreditCardTextFieldBlockCharacter, outsideBlock: Bool) {
        
        var nextBlockIndex: Int!
        
        var lowerBound = 0
        var upperBound = chars.count
        
        while lowerBound < upperBound {
            
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            let charLocation = chars[midIndex].templateRange.location
            
            if charLocation == location {
                return (chars[midIndex], false)
            } else if charLocation < location {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
                nextBlockIndex = midIndex
            }
        }
        
        return (chars[nextBlockIndex], true)
    }
    
    /// Check if current character match with pattern
    
    fileprivate func matchTextCharacter(_ textCharacter: Character, withMaskCharacter maskCharacter: CreditCardTextFieldBlockCharacter) -> Bool {
        return !CreditCardTextFieldUtility
            .matchesInString(String(textCharacter),
                             pattern: maskCharacter.pattern.pattern()).isEmpty
    }
    
    fileprivate func updateMaskTemplateText() {
        CreditCardTextFieldUtility
            .replacingOccurrencesOfString(&maskTemplateText,
                                          target     : "[\(maskBlockBrackets.left)\(maskBlockBrackets.right)]",
                withString : "")
        
        maskText = maskTemplateText
        
        refreshMask()
    }
    
    fileprivate func updateMaskTemplateTextFromBlock(_ index: Int) {
        
        CreditCardTextFieldUtility
            .replace(&maskTemplateText,
                     withString : maskBlocks[index].template,
                     inRange    : maskBlocks[index].patternRange)
    }
    
    fileprivate struct CreditCardTextFieldProcessedBlock {
        var range  : NSRange?
        var string : String = ""
    }
    
    fileprivate func moveCarret() {
        var position: Int
        
        switch maskStatus {
        case .clear       : position = maskBlocks.first!.templateRange.location
        case .incomplete  : position = maskBlocks.flatMap { $0.chars.filter { $0.status == .clear } }.first!.templateRange.location
        case .complete    : position = maskBlocks.last!.templateRange.upperBound
        }
        
        CreditCardTextFieldUtility.maskField(self, moveCaretToPosition: position)
    }
    
    //  MARK: - UITextFieldDelegate
    
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldBeginEditing(self) ?? true
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        
        maskDelegate?.maskFieldDidBeginEditing(self)
        
        if guardMask { return }
        
        moveCarret()
    }
    
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldEndEditing(self) ?? true
    }
    
     func textFieldDidEndEditing(_ textField: UITextField) {
        maskDelegate?.maskFieldDidEndEditing(self)
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // CHECKS
        
        if guardMask { return false }
        
        if isVisited {
            isVisited = false
            return false
        }
        
        let maskBlocksChars = maskBlocks.flatMap { $0.chars }
        
        var event: CreditCardTextFieldEvents!
        
        var completed: Int = 0
        var cleared: Int   = 0
        
        var processedBlocks = [CreditCardTextFieldProcessedBlock]()
        
        let intersertRanges = CreditCardTextFieldUtility
            .findIntersection(maskBlocks.map { return $0.templateRange }, withRange: range)
        
        // b) Create an array with interserted blocks
        
        for (i, intersertRange) in intersertRanges.enumerated() {
            
            var processedBlock = CreditCardTextFieldProcessedBlock()
            processedBlock.range = intersertRange
            
            if let intersertRange = intersertRange {
                processedBlock.range?.location = abs(maskBlocks[i].templateRange.location - intersertRange.location)
            }
            processedBlocks.append(processedBlock)
        }
        
        // - - - - - - - - - - - -
        // STEP 2
        // Replacement string
        
        var location      = range.location
        var savedLocation = range.location
        
        for replacementCharacter in string {
            if location == maskText?.count { break }
            
            // Find next character
            // If character outside the block, jump to first character of the next block
            let nextCharacter = getNetCharacter(maskBlocksChars, fromLocation: location)
            
            var findMatches: Bool = false
            
            if nextCharacter.outsideBlock {
                
                // Check if replacement character match to mask template character in same location
                
                if replacementCharacter != Character(CreditCardTextFieldUtility.substring(maskTemplateText, withNSRange: NSMakeRange(location, 1))) &&
                    replacementCharacter != " " {
                    
                    savedLocation = location
                    findMatches = true
                }
            } else {
                findMatches = true
            }
            
            if findMatches {
                if matchTextCharacter(replacementCharacter, withMaskCharacter: nextCharacter.char) {
                    
                    location = nextCharacter.char.templateRange.location
                    let blockIndex = nextCharacter.char.blockIndex
                    
                    processedBlocks[blockIndex].string.append(replacementCharacter)
                    
                    if processedBlocks[blockIndex].range == nil {
                        processedBlocks[blockIndex].range =  NSMakeRange(nextCharacter.char.index, 0)
                    }
                } else {
                    
                    location = savedLocation
                    
                    event = .error
                    break
                }
            }
            
            location += 1
        }
        
        // USER PROCESSING
        
        for (i, processedBlock) in processedBlocks.enumerated() {
            if var _range = processedBlock.range {
                
                // Prepare data
                
                var _string = processedBlock.string
                
                // Grab all changed data
                let shouldChangeBlock = maskDelegate?
                    .maskField(self,
                               shouldChangeBlock : maskBlocks[i],
                               inRange           : &_range,
                               replacementString : &_string)
                    ?? true
                
                if shouldChangeBlock {
                    
                    // REVALIDATE
                    
                    // Selected range
                    
                    if  processedBlock.range!.location != _range.location ||
                        processedBlock.range!.length   != _range.length {
                        
                        if let validatedRange = CreditCardTextFieldUtility
                            .findIntersection([maskBlocks[i].templateRange], withRange: _range).first! as NSRange? {
                            
                            _range = validatedRange
                        }
                    }
                    
                    // Replacement string
                    
                    if processedBlock.string != _string {
                        
                        var validatedString = ""
                        
                        // Start carret position
                        var _location = _range.location
                        
                        for replacementCharacter in _string {
                            if _location > maskBlocks[i].templateRange.length { break }
                            
                            if matchTextCharacter(replacementCharacter, withMaskCharacter: maskBlocks[i].chars[_location]) {
                                validatedString.append(replacementCharacter)
                            } else {
                                event = .error
                                break
                            }
                            _location += 1
                        }
                        
                        _string = validatedString
                    }
                    
                    // UPDATE MASK TEXT
                    
                    // Replacement string
                    
                    if !_string.isEmpty {
                        
                        var maskTextRange = NSMakeRange(_range.location, _string.count)
                        
                        // Object
                        
                        for index in [Int](maskTextRange.location..<maskTextRange.location+maskTextRange.length) {
                            
                            maskBlocks[i].chars[index].status = .complete
                            completed += 1
                        }
                        
                        maskTextRange.location += maskBlocks[i].templateRange.location
                        
                        // Mask text
                        
                        CreditCardTextFieldUtility
                            .replace(&maskText,
                                     withString : _string,
                                     inRange    : maskTextRange)
                        
                        
                        // New carret position
                        location = maskTextRange.upperBound
                        
                        event = .insert
                        
                        // Prepare range for clearing
                        
                        _range.location += maskTextRange.length
                        _range.length   -= maskTextRange.length
                    }
                    
                    // - - - - - - - - - - - -
                    // Selected range
                    
                    if _range.length > 0 {
                        
                        var maskTextRange = _range
                        
                        // Object
                        
                        for index in [Int](_range.location..<_range.location+_range.length) {
                            maskBlocks[i].chars[index].status = .clear
                            cleared += 1
                        }
                        
                        // Mask text
                        
                        maskTextRange.location += maskBlocks[i].templateRange.location
                        
                        let cuttedTempalte = CreditCardTextFieldUtility
                            .substring(maskTemplateText, withNSRange: maskTextRange)
                        
                        CreditCardTextFieldUtility
                            .replace(&maskText,
                                     withString : cuttedTempalte,
                                     inRange    : maskTextRange)
                        
                    }
                }else{
                    return false
                }
            }
        }
        
        // DISPLAYED TEXT
        refreshMask()
        
        if maskStatus == .complete{
            isVisited = true
        }else{
            isVisited = false
        }
        
        if jumpToPrevBlock {
            for (i, maskBlock) in maskBlocks.enumerated().reversed() {
                
                if i > 0 {
                    
                    let min = maskBlock.templateRange.location
                    let max = maskBlocks[i-1].templateRange.location + maskBlocks[i-1].templateRange.length
                    
                    if min == location || (max < location && min > location) {
                        
                        location = max
                        
                        break
                    }
                }
            }
        }
        
        CreditCardTextFieldUtility.maskField(self, moveCaretToPosition: location)
        
        // EVENT
        
        if completed != 0 {
            event = cleared == 0 ? .insert : .replace
        } else {
            if cleared != 0 {
                event = .delete
            }
        }
        
        if let event = event {
            maskDelegate?.maskField(self, didChangedWithEvent: event)
        }
        
        return false
    }
    
     func textFieldShouldClear(_ textField: UITextField) -> Bool {
        text = nil
        
        return false
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return maskDelegate?.maskFieldShouldReturn(self) ?? true
    }
}
