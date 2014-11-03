initialization
initialize
	super initialize.
	modelToControllerMapping := Dictionary new.
	selectionHolder := [  ].
	hoverHolder := [  ].
	figureAdded := [ :figure |  ]