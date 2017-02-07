*OpenPonk-Roassal2
resize: backElement bounds: encompassingRectangle padding: aPadding
	"it translates backElement, but does not trigger events."

	| newRec |
	newRec := encompassingRectangle topLeft - (aPadding @ aPadding)
		extent: (encompassingRectangle width + (aPadding * 2)) @ (encompassingRectangle height + (aPadding * 2)).

	backElement extent: (encompassingRectangle width + (aPadding * 2)) @ (encompassingRectangle height + (aPadding * 2)).
	backElement translateTo: encompassingRectangle center