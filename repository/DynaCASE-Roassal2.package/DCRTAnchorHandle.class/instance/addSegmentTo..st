adding
addSegmentTo: aPoint
	| factory corner segment |
	factory := DCRTHandleFactory new.
	corner := DCRTCornerHandle position: aPoint.
	segment := factory newHandleBetween: self and: corner.
	segment position: (self position + corner position) / 2.
	self hasSuccessor
		ifFalse: [ 
			self
				addPredecessor: corner;
				addPredecessor: segment ]
		ifTrue: [ 
			self
				addSuccessor: corner;
				addSuccessor: segment ].

	{corner.
	segment}
		do: [ :each | 
			each edge: edge.
			each renderIn: edge view ].
	edge update.
	edge signalUpdate