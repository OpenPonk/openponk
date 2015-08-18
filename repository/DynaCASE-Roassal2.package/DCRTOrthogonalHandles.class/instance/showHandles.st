hooks
showHandles
	| path |
	isActive
		ifTrue: [ ^ self ].
	path := edge shape pathFor: edge.
	self addHandlesFor: path.
	handles
		do: [ :each | 
			each edge: edge.
			each renderIn: edge view ].
	edge shape handleList: handles.
	edge update.
	edge signalUpdate.
	isActive := true