as yet unclassified
initialize
	super initialize.
	groups := OrderedCollection new.
	background := RTBox new
		borderColor: Color black;
		fillColor: Color transparent;
		element.
	translator := RTLayoutTranslator default