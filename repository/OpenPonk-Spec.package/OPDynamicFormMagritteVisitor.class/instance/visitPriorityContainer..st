visiting
visitPriorityContainer: aContainer
	aContainer children do: [ :each | self visit: each ].
	form addSeparator