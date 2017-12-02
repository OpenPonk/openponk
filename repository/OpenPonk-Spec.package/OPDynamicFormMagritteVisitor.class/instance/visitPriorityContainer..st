visiting
visitPriorityContainer: aContainer
	(self shouldIncludeLabelFor: aContainer)
		ifTrue: [ form addLabel: aContainer label ].
	aContainer children do: [ :each | self visit: each ].
	form addSeparator