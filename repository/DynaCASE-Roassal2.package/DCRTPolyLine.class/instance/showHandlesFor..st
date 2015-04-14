public
showHandlesFor: anEdge
	handles ifNotEmpty: [ ^ self ].
	points linksDo: [ :each | handles add: (DCRTHandle new on: anEdge at: each) ].
	handles do: [ :each | each renderIn: anEdge view ].
	anEdge signalUpdate