destruction
removeFromView: aFigure
	aFigure ifNil: [ ^ self ].
	(self controllerForFigure: aFigure) removeFull