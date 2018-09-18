opening
focusEditorOf: aView
	| editorTabPair |
	(focusedEditor isNotNil and: [ focusedEditor diagramController diagramView = aView ])
		ifTrue: [ ^ self ].
	focusedEditor
		ifNotNil: [ focusedEditor diagramController diagramView
				ifNotNil: [ :oldView | oldView isSelected: false ].
			self announce: (OPEditorUnfocused on: focusedEditor) ].
	editorTabPair := editors at: aView.
	focusedEditor := editorTabPair first.
	aView isSelected: true.
	editorTabPair second selected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor