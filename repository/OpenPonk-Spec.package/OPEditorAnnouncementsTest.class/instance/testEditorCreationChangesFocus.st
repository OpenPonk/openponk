tests
testEditorCreationChangesFocus
	| focusedAnn unfocusedAnn oldModel newModel |
	oldModel := OPTestContainerModel new.
	workbench openEditorOn: oldModel.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ].
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ].
	newModel := OPTestContainerModel new.
	workbench openEditorOn: newModel.
	self assert: unfocusedAnn isNotNil.
	self assert: unfocusedAnn editor diagramController model equals: oldModel.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: newModel