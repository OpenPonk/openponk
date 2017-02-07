accessing
zoom: aScale
	"1: default zoom (it should be 1.0001, but who cares)
	2: zoomed in to 200%"

	self logCr: aScale.
	(aScale between: 0.25 and: 4)
		ifTrue: [ roassalView canvas camera scale: aScale ]