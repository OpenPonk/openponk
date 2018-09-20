tests
testEditorCreatedAndFocused
	| createdAnn focusedAnn model |
	model := project models second.
	announcer when: OPEditorCreated do: [ :ann | createdAnn := ann ].
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ].
	workbench openEditorOn: model.
	self assert: createdAnn isNotNil.
	self assert: createdAnn editor diagramController model equals: model.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: model