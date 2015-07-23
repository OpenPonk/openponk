hooks
removeHandles
	handles ifEmpty: [ ^ self ].

	handles do: #remove.
	handles := #().

	element view signalUpdate