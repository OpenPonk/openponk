initialization
initialize
	super initialize.
	model whenChangedDo: [ model value whenChanged: [ figure ifNotNil: [ self refreshFigure ] ] ]