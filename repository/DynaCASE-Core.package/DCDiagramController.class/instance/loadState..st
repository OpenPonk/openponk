undo/redo
loadState: aMemento
	|oldModel|
	aMemento ifNil: [ ^ self ].
"	1halt."
	oldModel := self model.
	model := aMemento model.
	model announcer: oldModel announcer.
"	self model
		silentlyDo: [ self model name: aMemento model name.
			self model removeAll.
			self model addAll: aMemento model elements ]."
	self rebuildView.
	self diagram: aMemento diagram.
	self editor updateUndoRedo