undo/redo
undo
	self assert: [ self hasUndo ].
	self loadState: self autosaveManager loadPrevious