opening
focusEditorOfModel: aModel
	| editorTabPair |
	(focusedEditor isNotNil and: [ focusedEditor diagramController model = aModel ])
		ifTrue: [ ^ self ].
	focusedEditor ifNotNil: [ self announce: (OPEditorUnfocused on: focusedEditor) ].
	editorTabPair := editors at: aModel.
	focusedEditor := editorTabPair first.
	editorTabPair second selected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor