menus for editor
activeEditor: anEditor
	activeEditor := anEditor.
	activeEditor ifNil: [ self removeEditorMenu ] ifNotNil: [ self addEditorMenu ].
	self rebuildWidget