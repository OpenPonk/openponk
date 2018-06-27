protocol
remove
	| overlay |
	self hasStore
		ifFalse: [ ^ self ].
	overlay := self load.
	self clearStore.
	overlay remove.
	model view signalUpdate