selection handling
focusOnController: aController
	| element |
	element := aController view.
	focusedElement = element
		ifFalse: [ 
			focusedElement := element.
			element announce: DCTRFocused.
			self owner focusOn: aController.
			self signalUpdate ]