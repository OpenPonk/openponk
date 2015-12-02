private
removeHandles
	visible
		ifFalse: [ ^ self ].
	handles do: #remove.
	handles := OrderedCollection new.
	midpointHandles do: #remove.
	midpointHandles := OrderedCollection new.
	edge signalUpdate.
	visible := false