Class {
	#name : 'OPEditorAnnouncementsTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench',
		'editor',
		'announcer',
		'plugin',
		'project'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'initialization' }
OPEditorAnnouncementsTest >> setUp [

	plugin := Mock new.
	plugin stub diagramControllerClass willReturn:
		OPTestDiagramController.
	(plugin stub isPluginFor: Any) willReturn: true.
	(plugin stub isForController: Any) willReturn: true.
	plugin stub supportsHidingElements willReturn: true.
	plugin stub supportsMergingModels willReturn: false.
	plugin stub icon willReturn: (Form extent: 0 @ 0).
	plugin stub layouterClass willReturn: OPNoLayouter.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: plugin).
	project := OPProject new.
	2 timesRepeat: [ project addModel: OPTestContainerModel new ].
	workbench := OPWorkbench new.
	announcer := workbench announcer
]

{ #category : 'running' }
OPEditorAnnouncementsTest >> tearDown [
	super tearDown.
	OPPluginRegistry resetDefault
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorClosesAndUnfocuses [

	| unfocusedAnn closedAnn oldModel |
	oldModel := project models first.
	announcer
		when: OPEditorClosed
		do: [ :ann | closedAnn := ann ]
		for: self.
	announcer
		when: OPEditorUnfocused
		do: [ :ann | unfocusedAnn := ann ]
		for: self.
	workbench openProject: project.
	workbench openEditorOn: oldModel.
	self deny: unfocusedAnn diagramController model equals: oldModel.
	self assert: closedAnn isNil.
	workbench notebook pages first removeFromNotebook.
	self assert: unfocusedAnn isNotNil.
	self assert: unfocusedAnn diagramController model equals: oldModel.
	self assert: closedAnn isNotNil.
	self assert: closedAnn diagramController model equals: oldModel.
	workbench withWindowDo: #close
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorCreatedAndFocused [

	| createdAnn focusedAnn model |
	model := project models second.
	announcer
		when: OPEditorCreated
		do: [ :ann | createdAnn := ann ]
		for: self.
	announcer
		when: OPEditorFocused
		do: [ :ann | focusedAnn := ann ]
		for: self.
	workbench openProject: project.
	workbench openEditorOn: model.
	self assert: createdAnn isNotNil.
	self assert: createdAnn editor diagramController model equals: model.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: model.
	workbench withWindowDo: #close
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorCreationChangesFocus [

	| focusedAnn unfocusedAnn oldModel newModel |
	oldModel := project models first.
	workbench openProject: project.
	workbench openEditorOn: oldModel.
	announcer
		when: OPEditorFocused
		do: [ :ann | focusedAnn := ann ]
		for: self.
	announcer
		when: OPEditorUnfocused
		do: [ :ann | unfocusedAnn := ann ]
		for: self.
	newModel := project models second.
	workbench openEditorOn: newModel.
	self assert: unfocusedAnn isNotNil.
	self
		assert: unfocusedAnn editor diagramController model
		equals: oldModel.
	self assert: focusedAnn isNotNil.
	self
		assert: focusedAnn editor diagramController model
		equals: newModel.
	workbench withWindowDo: #close
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testTabSwitchRefocuses [

	| unfocusedAnn focusedAnn oldModel newModel |
	newModel := project models first.
	oldModel := project models second.
	workbench openProject: project.
	workbench openEditorOn: newModel.
	workbench openEditorOn: oldModel.
	workbench notebook selectPageIndex: 2.
	announcer
		when: OPEditorFocused
		do: [ :ann | focusedAnn := ann ]
		for: self.
	announcer
		when: OPEditorUnfocused
		do: [ :ann | unfocusedAnn := ann ]
		for: self.
	workbench notebook selectPageIndex: 1.
	self assert: unfocusedAnn isNotNil.
	self
		assert: unfocusedAnn editor diagramController model
		equals: oldModel.
	self assert: focusedAnn isNotNil.
	self
		assert: focusedAnn editor diagramController model
		equals: newModel.
	workbench withWindowDo: #close
]
