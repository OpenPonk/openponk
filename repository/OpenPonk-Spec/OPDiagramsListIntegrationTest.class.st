Class {
	#name : 'OPDiagramsListIntegrationTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'project',
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramsListIntegrationTest >> setUp [
	| containerModel |
	super setUp.
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	containerModel name: 'TestPackage'.
	project addModel: containerModel.
	diagram := (OPOpenPonkDiagram forModelElement: containerModel)
		name: 'Initial Name';
		yourself.
	project addDiagram: diagram.

	workbench := OPWorkbench new.
	workbench pluginRegistry: (OPPluginRegistry new add: OPTestPlugin new; yourself).
	workbench openProject: project
]

{ #category : 'running' }
OPDiagramsListIntegrationTest >> tearDown [
	workbench ifNotNil: [
		workbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPDiagramsListIntegrationTest >> testRenameDiagramReflectsInListAndSupportsUndoRedo [
	| listPresenter |
	listPresenter := workbench diagramsList.

	"1. Execute rename through list presenter"
	listPresenter renameDiagram: diagram to: 'Updated Name'.
	self assert: diagram name equals: 'Updated Name'.
	self
		assertCollection: (listPresenter list items collect: #name)
		includesAll: #( 'Updated Name' ).

	"2. Undo via projectController undoManager"
	workbench projectController undoManager undo.
	self assert: diagram name equals: 'Initial Name'.
	self
		assertCollection: (listPresenter list items collect: #name)
		includesAll: #( 'Initial Name' ).

	"3. Redo via projectController undoManager"
	workbench projectController undoManager redo.
	self assert: diagram name equals: 'Updated Name'.
	self
		assertCollection: (listPresenter list items collect: #name)
		includesAll: #( 'Updated Name' )
]

{ #category : 'tests' }
OPDiagramsListIntegrationTest >> testRenameDiagramUpdatesTabTitleAndSupportsUndoRedo [
	| page |
	page := workbench pageFor: diagram.
	self assert: page title equals: '[Initial Name] TestPackage'.

	workbench diagramsList renameDiagram: diagram to: 'Updated Name'.
	self assert: page title equals: '[Updated Name] TestPackage'.

	workbench projectController undoManager undo.
	self assert: page title equals: '[Initial Name] TestPackage'.

	workbench projectController undoManager redo.
	self assert: page title equals: '[Updated Name] TestPackage'
]
