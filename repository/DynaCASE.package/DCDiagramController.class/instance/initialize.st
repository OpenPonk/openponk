initialization
initialize
	super initialize.
	modelToControllerMapping := Dictionary new.
	selectionHolder := [  ].
	deselectionHolder := [  ].
	hoverHolder := [  ].
	figureAdded := [ :figure |  ]