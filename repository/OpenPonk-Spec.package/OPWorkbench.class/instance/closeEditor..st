opening
closeEditor: anEditor
	topToolbar activeEditor: nil.
	editors removeKey: anEditor diagramController model.
	focusedEditor = anEditor
		ifTrue: [ focusedEditor := nil.
			self announce: (OPEditorUnfocused on: anEditor) ].
	self announce: (OPEditorClosed on: anEditor)