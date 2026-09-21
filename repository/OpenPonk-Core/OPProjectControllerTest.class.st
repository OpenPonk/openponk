"
Unit tests for OPProjectController. 
Verifies the management of open diagrams, projects, model additions/removals, and persistence boundaries (saving projects).
"
Class {
	#name : 'OPProjectControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'project'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPProjectControllerTest >> setUp [
	super setUp.
	project := OPProject new.
	controller := OPProjectController forProject: project.
	OPPluginRegistry setDefaultForTesting
]

{ #category : 'running' }
OPProjectControllerTest >> tearDown [

	OPPluginRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPProjectControllerTest >> testAddController [
	| diagramController model |
	diagramController := OPDiagramController new.
	model := OPTestContainerModel new.
	controller addDiagramController: diagramController.
	diagramController model: model.
	self assert: controller controllers asArray equals: { diagramController }
]

{ #category : 'tests' }
OPProjectControllerTest >> testRemoveController [
	| diagramController model |
	diagramController := OPDiagramController new.
	model := OPTestContainerModel new.
	controller addDiagramController: diagramController.
	diagramController model: model.
	controller removeDiagramController: diagramController.
	self deny: (controller hasModel: model).
	self deny: (model announcer hasSubscriber: diagramController)
]

{ #category : 'tests' }
OPProjectControllerTest >> testRenameDiagramTransactively [
	| diagram |
	diagram := OPOpenPonkDiagram new.
	diagram name: 'Old Name'.
	project addDiagram: diagram.

	controller renameDiagram: diagram to: 'New Name'.

	self assert: diagram name equals: 'New Name'.

	controller undoManager undo.
	self assert: diagram name equals: 'Old Name'.

	controller undoManager redo.
	self assert: diagram name equals: 'New Name'
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectEmpty [
	| root store |
	root := FileSystem memory / 'project.opp'.
	controller workbench: OPWorkbench new.
	self deny: root exists.
	controller saveProjectTo: root.
	self assert: root exists.
	store := (FileSystem zip: root) open.
	self assert: (store / 'project' / 'project.json') exists
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectWithModel [

	| memoryRoot root |
	project addModel: OPTestContainerModel new.
	memoryRoot := FileSystem memory / 'project'.
	controller workbench: OPWorkbench new.
	self deny: memoryRoot exists.
	controller saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open root.
	self assert: (root / 'project' / 'project.json') exists.
	self
		assert: ((root / 'project' / 'models') children collect: #basename)
		equals: { project models first uuid asString }.
	self
		assertCollection:
			(((root / 'project' / 'models') children anyOne / 'model') children 
				 collect: #basename)
		includesAll: (Array with: 'model.ston')
]
