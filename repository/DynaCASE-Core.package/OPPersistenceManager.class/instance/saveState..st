save/load
saveState: aMemento
	self resetFuture.
	current ifNotNil: [ history addLast: current ].
	current := DCFsmGraphML new export: aMemento model withLayout: aMemento layout.
	(self autosaveFileFor: aMemento id)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: current ]