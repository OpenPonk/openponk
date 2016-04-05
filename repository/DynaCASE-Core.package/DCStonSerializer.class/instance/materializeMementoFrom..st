convenience
materializeMementoFrom: aString
	| memento |
	memento := self stonMaterialize: aString.
	self flag: 'STON has broken Dictionary materialization for referenced keys, so rehash it manually for now'.
	memento diagram rehash.
	^ memento