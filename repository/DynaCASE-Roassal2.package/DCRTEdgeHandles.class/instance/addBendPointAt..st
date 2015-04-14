adding
addBendPointAt: aPoint
	| index |
	index := self findPositionFor: aPoint.
	bendPoints
		ifEmpty: [ bendPoints add: aPoint ]
		ifNotEmpty: [ bendPoints add: (self fixedPositionFor: aPoint index: index) beforeIndex: index ].
	self isVisible
		ifTrue: [ self updateHandles ]