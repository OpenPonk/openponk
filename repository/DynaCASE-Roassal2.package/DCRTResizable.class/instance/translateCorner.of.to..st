translating
translateCorner: aCorner of: anElement to: aPosition
	| selector |
	selector := ('translate' , aCorner capitalized , 'Of:to:') asSymbol.
	RTDirectLayoutTranslator new perform: selector with: anElement with: aPosition