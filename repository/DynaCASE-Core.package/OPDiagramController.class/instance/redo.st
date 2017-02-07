undo/redo
redo
	self assert: [ self hasRedo ].
	self loadState: self autosaveManager loadNext