rebuilding
cleanView
	self view clean.
	self view canvas shapes copy
		do: [ :each | 
			(each isKindOf: TRCanvasGridShape)
				ifFalse: [ each remove ] ].
	self view canvas fixedShapes copy do: #remove