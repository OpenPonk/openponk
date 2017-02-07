options
addOptionsFor: aClass to: aPane
	(aClass isKindOf: RTAbstractGraphLayout class)
		ifTrue: [ self optionsForAbstractGraphLayoutTo: aPane ].
	(aClass isKindOf: RTForceBasedLayout class)
		ifTrue: [ self optionsForForceBasedLayoutTo: aPane ].
	(aClass isKindOf: RTAbstractGridLayout class)
		ifTrue: [ self optionsForAbstractGridLayoutTo: aPane ].
	(aClass isKindOf: RTAbstractRegularTreeLayout class)
		ifTrue: [ self optionsForAbstractRegularTreeLayoutTo: aPane ]