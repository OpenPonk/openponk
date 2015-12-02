as yet unclassified
showHandles
	visible
		ifTrue: [ ^ self ].
	edge shape router linksDo: [ :each | handles add: (DCRTHandle new on: edge at: each) ].
	handles do: [ :each | each renderIn: edge view ].
	self showMidpointHandlesFor: edge.
	edge signalUpdate.
	visible := true