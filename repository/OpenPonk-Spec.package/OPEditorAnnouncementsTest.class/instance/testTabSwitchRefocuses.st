tests
testTabSwitchRefocuses
	| unfocusedAnn focusedAnn oldModel newModel |
	oldModel := project models first.
	newModel := project models second.
	workbench openEditorOn: oldModel.
	workbench openEditorOn: newModel.
	workbench tabManager tabs first buildWithSpec.
	workbench tabManager tabs second buildWithSpec.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ].
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ].
	workbench tabManager selectedTab: workbench tabManager tabs first.
	self assert: unfocusedAnn isNotNil.
	self assert: unfocusedAnn editor diagramController model equals: newModel.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: oldModel