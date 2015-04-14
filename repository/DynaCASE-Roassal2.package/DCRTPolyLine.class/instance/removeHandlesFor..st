public
removeHandlesFor: anEdge
	handlesActive
		ifFalse: [ ^ self ].
	handles do: #remove.
	handles := OrderedCollection new.
	midpointHandles do: #remove.
	midpointHandles := OrderedCollection new.
	anEdge signalUpdate.
	handlesActive := false