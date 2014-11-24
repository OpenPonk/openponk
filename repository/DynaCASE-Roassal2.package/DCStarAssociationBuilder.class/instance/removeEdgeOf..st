removing
removeEdgeOf: aRTElement
	| edge |
	edge := self edgeOf: aRTElement.
	edge
		ifNotNil: [ 
			edge remove.
			(sources includes: aRTElement)
				ifTrue: [ sources remove: aRTElement ]
				ifFalse: [ targets remove: aRTElement ].
			aRTElement trachelShape
				removeCallback: transCallback ifAbsent: [ self fail: 'callback should have been added by "self added:" method' ];
				removeCallback: extentCallback ifAbsent: [ self fail: 'callback should have been added by "self added:" method' ].
			self update ]