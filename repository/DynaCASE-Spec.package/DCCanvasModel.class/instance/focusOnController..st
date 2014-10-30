selection handling
focusOnController: aController
	| element form |
	element := aController view.
	focusedElement = element
		ifFalse: [ 
			focusedElement := element.
			element announce: DCTRFocused.
			form := self workbench openFormOn: aController.
			element when: DCTRUnfocused do: [ form editController: nil ].
			self signalUpdate ]