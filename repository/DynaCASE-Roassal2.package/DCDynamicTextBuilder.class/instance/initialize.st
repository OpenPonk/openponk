initialization
initialize
	super initialize.
	elements := RTGroup new.
	textHolders := OrderedCollection new.
	nest := RTNest new.
	background := RTBox new
		borderColor: Color black;
		fillColor: Color transparent;
		element.
	translator := RTLayoutTranslator default.
	callbacks := OrderedCollection new.
	view := nil.
	draggableBackground := true.
	backgroundWidth := nil.
	parent := nil