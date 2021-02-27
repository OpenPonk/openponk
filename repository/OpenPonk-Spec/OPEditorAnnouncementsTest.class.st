Class {
	#name : #OPEditorAnnouncementsTest,
	#superclass : #TestCase,
	#instVars : [
		'workbench',
		'editor',
		'announcer',
		'plugin',
		'project'
	],
	#category : #'OpenPonk-Spec-Tests'
}

{ #category : #initialization }
OPEditorAnnouncementsTest >> setUp [
	plugin := Mock new.
	plugin stub diagramControllerClass
		willReturn: OPTestDiagramController.
	(plugin stub isPluginFor: Any) willReturn: true.
	(plugin stub isForController: Any) willReturn: true.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: plugin).
	project := OPProject new.
	project addModel: OPTestContainerModel new.
	project addModel: OPTestContainerModel new.
	workbench := OPWorkbench new.
	announcer := workbench announcer.
	workbench openProject: project
]

{ #category : #running }
OPEditorAnnouncementsTest >> tearDown [
	super tearDown.
	OPPluginRegistry resetDefault
]

{ #category : #tests }
OPEditorAnnouncementsTest >> testEditorClosesAndUnfocuses [
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
]

{ #category : #tests }
OPEditorAnnouncementsTest >> testEditorCreatedAndFocused [
	| createdAnn focusedAnn model |
	model := project models second.
	announcer when: OPEditorCreated do: [ :ann | createdAnn := ann ].
	announcer when: OPEditorFocused do: [ :ann | focusedAnn := ann ].
	workbench openEditorOn: model.
	self assert: createdAnn isNotNil.
	self assert: createdAnn editor diagramController model equals: model.
	self assert: focusedAnn isNotNil.
	self assert: focusedAnn editor diagramController model equals: model
]

{ #category : #tests }
OPEditorAnnouncementsTest >> testEditorCreationChangesFocus [
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
]

{ #category : #tests }
OPEditorAnnouncementsTest >> testTabSwitchRefocuses [
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
]
