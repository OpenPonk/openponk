"
Unit tests verifying the correct dispatching of lifecycle announcements (such as focused, unfocused, and closed events) by the OpenPonk workbench editors.
"
Class {
	#name : 'OPEditorAnnouncementsTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench',
		'announcer',
		'plugin',
		'project'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'running' }
OPEditorAnnouncementsTest >> setUp [

	super setUp.
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

	OPPluginRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorClosesAndUnfocuses [

	| closedAnn unfocusedAnn oldModel |
	oldModel := project models first.
	unfocusedAnn := nil.
	closedAnn := nil.
	announcer when: OPEditorClosed do: [ :ann | closedAnn := ann ] for: self.
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ] for: self.
	workbench openProject: project.
	workbench openEditorOn: oldModel.
	self deny: unfocusedAnn diagramController model equals: oldModel.
	self assert: closedAnn isNil description: 'OPEditorClosed must not be announced before closing tab'.
	workbench notebook pages first removeFromNotebook.
	self assert: unfocusedAnn isNotNil description: 'Removing active page must announce OPEditorUnfocused'.
	self assert: unfocusedAnn diagramController model equals: oldModel.
	self assert: closedAnn isNotNil description: 'Removing active page must announce OPEditorClosed'.
	self assert: closedAnn diagramController model equals: oldModel.
	workbench withWindowDo: #close
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorCreatedAndFocused [

	| createdAnn focusedAnn model |
	model := project models second.
	createdAnn := nil.
	focusedAnn := nil.
	announcer when: OPEditorCreated do: [ :ann | createdAnn := ann ] for: self.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ] for: self.
	workbench openProject: project.
	workbench openEditorOn: model.
	self assert: createdAnn isNotNil description: 'Opening editor on model must announce OPEditorCreated'.
	self assert: createdAnn editor diagramController model equals: model.
	self assert: focusedAnn isNotNil description: 'Opening editor on model must announce OPEditorFocused'.
	self assert: focusedAnn editor diagramController model equals: model.
	workbench withWindowDo: #close
]

{ #category : 'tests' }
OPEditorAnnouncementsTest >> testEditorCreationChangesFocus [

	| focusedAnn unfocusedAnn oldModel newModel |
	oldModel := project models first.
	workbench openProject: project.
	workbench openEditorOn: oldModel.
	focusedAnn := nil.
	unfocusedAnn := nil.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ] for: self.
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ] for: self.
	newModel := project models second.
	workbench openEditorOn: newModel.
	self assert: unfocusedAnn isNotNil description: 'Opening a second editor must unfocus the previously active editor'.
	self assert: unfocusedAnn editor diagramController model equals: oldModel.
	self assert: focusedAnn isNotNil description: 'Opening a second editor must focus the newly created editor'.
	self assert: focusedAnn editor diagramController model equals: newModel.
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
	focusedAnn := nil.
	unfocusedAnn := nil.
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ] for: self.
	announcer when: OPEditorUnfocused do: [ :ann | unfocusedAnn := ann ] for: self.
	workbench notebook selectPageIndex: 1.
	self assert: unfocusedAnn isNotNil description: 'Switching notebook tab must announce OPEditorUnfocused for previous tab'.
	self assert: unfocusedAnn editor diagramController model equals: oldModel.
	self assert: focusedAnn isNotNil description: 'Switching notebook tab must announce OPEditorFocused for selected tab'.
	self assert: focusedAnn editor diagramController model equals: newModel.
	workbench withWindowDo: #close
]
