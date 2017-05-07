controllers management
cachedControllerForFigure: aFigure
	| ctrl |
	figureToControllerCache
		ifNil: [ figureToControllerCache := Dictionary new.
			self controllers
				do: [ :each | figureToControllerCache at: each figure put: each ] ].
	ctrl := figureToControllerCache at: aFigure ifPresent: #yourself.
	(self controllers includes: ctrl)
		ifTrue: [ ^ ctrl ].
	ctrl := self controllers detect: [ :fresh | fresh figure = aFigure ].
	figureToControllerCache at: aFigure put: ctrl.
	^ ctrl