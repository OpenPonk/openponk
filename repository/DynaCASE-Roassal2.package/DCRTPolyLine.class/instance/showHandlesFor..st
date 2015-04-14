public
showHandlesFor: anEdge
	handlesActive
		ifTrue: [ ^ self ].
	points linksDo: [ :each | handles add: (DCRTHandle new on: anEdge at: each) ].
	handles do: [ :each | each renderIn: anEdge view ].
	self showMidpointHandlesFor: anEdge.
	anEdge signalUpdate.
	handlesActive := true