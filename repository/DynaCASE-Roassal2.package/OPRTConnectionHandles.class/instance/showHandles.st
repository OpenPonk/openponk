as yet unclassified
showHandles
	isActive
		ifTrue: [ ^ self ].
	edge shape router linksDo: [ :each | handles add: (OPRTHandle new on: edge at: each) ].
	handles do: [ :each | each renderIn: edge view ].
	self showMidpointHandlesFor: edge.
	edge signalUpdate.
	isActive := true