as yet unclassified
showLayoutSubmenu
	| choice opt |
	choice := UIManager default chooseFrom: self layoutOptions title: 'Choices'.
	choice = 0
		ifTrue: [ ^ self ].
	opt := ((self layoutOptions at: choice) copyWithoutAll: ' ') asSymbol.
	self editor model applyRTBasedLayout: (self layoutFor: choice)