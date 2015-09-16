initialization
showHandles
	visible
		ifFalse: [ 
			edge shape showHandlesFor: edge.
			visible := true ]