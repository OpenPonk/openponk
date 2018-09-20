tests
testEditorClosesAndUnfocuses
	| unfocusedAnn closedAnn oldModel |
	oldModel := project models first.
	announcer when: OPEditorClosed do: [ :ann | closedAnn := ann ].
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ].
	workbench openEditorOn: oldModel.
	workbench tabManager tabs first buildWithSpec.
	workbench tabManager tabs first widget widget delete.
	self assert: unfocusedAnn isNotNil.
	self assert: unfocusedAnn editor diagramController model equals: oldModel.
	self assert: closedAnn isNotNil.
	self assert: closedAnn editor diagramController model equals: oldModel