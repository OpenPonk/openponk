protocol-events
whenFigureAdded: aBlock
	figureAdded := aBlock ifNil: [ [ :figure |  ] ]