private
removeElement: aRTElement edge: aRTEdge
	aRTEdge remove.
	(targets includes: aRTElement)
		ifTrue: [ targets remove: aRTElement ]
		ifFalse: [ sources remove: aRTElement ].
	aRTElement trachelShape
		removeCallback: transCallback ifAbsent: [ self error: 'callback should have been added by "self added:" method' ];
		removeCallback: extentCallback ifAbsent: [ self error: 'callback should have been added by "self added:" method' ].
	self update