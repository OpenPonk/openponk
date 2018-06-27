protocol
remove
	self hasStore
		ifFalse: [ ^ self ].
	model canvas color: self load.
	self clearStore.
	model signalUpdate