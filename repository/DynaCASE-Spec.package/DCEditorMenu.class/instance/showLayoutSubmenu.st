as yet unclassified
showLayoutSubmenu
	| choice opt |
	choice := UIManager default chooseFrom: self layoutOptions title: 'Choices'.
	choice = 0
		ifTrue: [ ^ self ].
	opt := ((self layoutOptions at: choice) copyWithoutAll: ' ') asSymbol.
	self editor diagramController applyRTBasedLayout: (self layoutFor: choice)