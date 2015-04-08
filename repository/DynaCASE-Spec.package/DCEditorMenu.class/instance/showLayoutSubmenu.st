as yet unclassified
showLayoutSubmenu
	| choice |
	choice := UIManager default chooseFrom: self layoutOptions title: 'Choices'.
	choice = 0
		ifTrue: [ ^ self ].
	self editor diagramController applyRTBasedLayout: (self layoutFor: choice)