tests
testEditorCreationChangesFocus
	| focusedAnn unfocusedAnn oldModel newModel |
	oldModel := project models first.
	workbench openEditorOn: oldModel.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ].
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ].
	newModel := project models second.
	workbench openEditorOn: newModel.
	self assert: unfocusedAnn isNotNil.
	self assert: unfocusedAnn editor diagramController model equals: oldModel.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: newModel