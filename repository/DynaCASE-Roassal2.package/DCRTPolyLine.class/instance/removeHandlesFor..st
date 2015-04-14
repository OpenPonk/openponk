public
removeHandlesFor: anEdge
	handles do: #remove.
	handles := OrderedCollection new.
	anEdge signalUpdate