as yet unclassified
initialize
	super initialize.
	groups := OrderedCollection new.
	background := RTBox new
		borderColor: Color black;
		element.
	translator := RTLayoutTranslator default