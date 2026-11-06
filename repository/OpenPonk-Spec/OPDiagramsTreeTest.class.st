"
Tests diagram list presentation, selection events, and diagram activation in the workbench.
"
Class {
	#name : 'OPDiagramsTreeTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'project',
		'undoManager',
		'projectController',
		'model',
		'treePresenter'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramsTreeTest >> setUp [
	super setUp.
	project := OPProject named: 'Test Project'.
	model := OPTestContainerModel new
		name: 'Test Model';
		yourself.
	project addModel: model.
	diagram := (OPOpenPonkDiagram forModelElement: model)
		name: 'Original Diagram';
		yourself.
	project addDiagram: diagram.

	projectController := project controllerClass forProject: project.
	undoManager := projectController undoManager.

	treePresenter := OPDiagramsTree new.
	treePresenter application: SpApplication defaultApplication.
	treePresenter projectController: projectController.
	treePresenter openOn: projectController viewModel.
	treePresenter build
]

{ #category : 'running' }
OPDiagramsTreeTest >> tearDown [
	treePresenter := nil.
	projectController := nil.
	undoManager := nil.
	project := nil.
	diagram := nil.
	model := nil.
	super tearDown
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testContextMenuForModelAndDiagram [
	| modelViewModel modelMenu modelMenuItemNames diagramMenu diagramMenuItemNames |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter tree selectItem: modelViewModel.
	modelMenu := treePresenter buildContextMenu.
	modelMenuItemNames := modelMenu menuGroups flatCollect: [ :eachGroup |
		eachGroup menuItems collect: #name ].
	self
		assertCollection: modelMenuItemNames
		includesAll: #( 'Create empty diagram' 'Remove' 'Inspect Model' ).

	treePresenter tree selectItem: diagram.
	diagramMenu := treePresenter buildContextMenu.
	diagramMenuItemNames := diagramMenu menuGroups flatCollect: [ :eachGroup |
		eachGroup menuItems collect: #name ].
	self
		assertCollection: diagramMenuItemNames
		includesAll: #( 'Open diagram' 'Copy diagram...' 'Rename diagram' 'Delete diagram' 'Inspect Diagram' )
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testModelWithoutDiagramsIsShownAndCanCreateDiagram [
	| emptyModel emptyModelViewModel createdDiagrams |
	emptyModel := OPTestContainerModel new
		name: 'Empty Model';
		yourself.
	project addModel: emptyModel.
	project announcer announce: (OPModelAdded model: emptyModel).

	emptyModelViewModel := projectController viewModelRegistry viewModelFor: emptyModel.
	self
		assertCollection: (treePresenter tree childrenFor: projectController viewModel)
		includesAll: { emptyModelViewModel }.
	self assert: (treePresenter tree childrenFor: emptyModelViewModel) isEmpty.

	treePresenter createDiagramForModel: emptyModel named: 'Created Diagram'.
	createdDiagrams := treePresenter tree childrenFor: emptyModelViewModel.
	self assert: createdDiagrams size equals: 1.
	self assert: createdDiagrams first name equals: 'Created Diagram'
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testRenameDiagramRedoReappliesNewNameAndUpdatesList [
	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter renameDiagram: diagram to: 'Renamed Diagram'.
	undoManager undo.
	undoManager redo.

	self assert: diagram name equals: 'Renamed Diagram'.
	self assert: (((treePresenter tree childrenFor: modelViewModel) collect: #name) includes: 'Renamed Diagram')
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testRenameDiagramToExecutesTransaction [
	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter renameDiagram: diagram to: 'Renamed Diagram'.

	self assert: diagram name equals: 'Renamed Diagram'.
	self assert: (((treePresenter tree childrenFor: modelViewModel) collect: #name) includes: 'Renamed Diagram')
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testRenameDiagramUndoRestoresOriginalNameAndUpdatesList [
	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter renameDiagram: diagram to: 'Renamed Diagram'.
	undoManager undo.

	self assert: diagram name equals: 'Original Diagram'.
	self assert: (((treePresenter tree childrenFor: modelViewModel) collect: #name) includes: 'Original Diagram')
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testTreeHierarchyHasProjectModelAndDiagramLevels [
	| projectViewModel modelViewModels modelViewModel diagrams |
	projectViewModel := projectController viewModel.
	self assertCollection: treePresenter tree roots hasSameElements: { projectViewModel }.
	self assert: (treePresenter tree isExpanded: #( 1 )).

	modelViewModels := treePresenter tree childrenFor: projectViewModel.
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	self assertCollection: modelViewModels hasSameElements: { modelViewModel }.
	self assert: (treePresenter tree isExpanded: #( 1 1 )).

	diagrams := treePresenter tree childrenFor: modelViewModel.
	self assertCollection: diagrams hasSameElements: { diagram }.
	self assert: (treePresenter tree childrenFor: diagram) isEmpty
]
