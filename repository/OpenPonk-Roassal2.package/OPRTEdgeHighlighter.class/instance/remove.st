protocol
remove
	self hasStore
		ifFalse: [ ^ self ].
	model shape color: self load.
	self clearStore.
	model update.
	model view signalUpdate