undo/redo
loadState: aMemento
	| oldModel |
	aMemento ifNil: [ ^ self ].
	oldModel := self model.
	model := aMemento model.
	model announcer: oldModel announcer.
	self rebuild.
	self diagram: aMemento diagram.
	self logCr: aMemento diagram.
	self editor updateUndoRedo