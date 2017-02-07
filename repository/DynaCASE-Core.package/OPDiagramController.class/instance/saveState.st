undo/redo
saveState
	| memento |
	memento := self memento.
	self autosaveManager saveState: memento.
	self editor updateUndoRedo.
	self editor workbench projectController autoSave: memento