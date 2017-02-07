private
removeHandles
	isActive
		ifFalse: [ ^ self ].
	handles linksDo: #removeHandle.
	edge view signalUpdate.
	isActive := false