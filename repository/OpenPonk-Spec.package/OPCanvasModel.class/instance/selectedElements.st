accessing
selectedElements
	roassalView attributes
		at: OPRTSelectableView
		ifPresent: [ :els | els ifNotEmpty: [ ^ els ] ].
	^ {self lastSelectedFigure}