# CreditCardValidator

## (1) Problem Statement :-

### • To develop an EditText/TextField which only takes a valid Credit Card Number as an input.

### • Things to make sure:
#### ----------> “X” as placeholder for digits to be entered
#### ---------->  Auto formats according to the card brand as the user types
#### ---------->  Does basic Credit Card number validation - Luhn/Brand
#### ---------->  Error for invalid number
 
 ## (2) Solution :-
 
 • Application contains two custom views.
 
 ### -------> 1. `CreditCardView.swift` - The base view of the Credit Card.[subclass of `UIView`.]
 ### -------> 2. `CreditCardTextField.swift` on top of `CreditCardView.swift`. - holds the card number. [subclass of `UITextField`.]
 
 
 • Application contains the Credit card validation logic in - `CreditCardValidator.swift` & `CreditCardValidationType.swift`
 
 ### ------> `CreditCardValidator.swift` - It validates the logic for a valid credit card.
 ### ------> `CreditCardValidationType.swift` - It used to compare the values for equality, as it conforms to the `Equatable` protocol.
 
 • Application contain `CreditCardEntity.swift` as an entity.
 
  ### ------> `CreditCardEntity.swift` - It holds the types of Credit Cards.
  
  • Application contain `BaseViewController.swift` as controller.
  
  ## (3) Highlights :
  
  • No third party libs are used.
  
  • View hierarchies are written by code.
  
  
  Here above is the brief about the CreditCardValidator.
  
  # Thank You :)
 
 
