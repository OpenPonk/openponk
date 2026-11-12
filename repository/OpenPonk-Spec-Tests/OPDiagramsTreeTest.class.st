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
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
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
	self assertCollection: (treePresenter tree childrenFor: projectController viewModel) includesAll: { emptyModelViewModel }.
	self assertEmpty: (treePresenter tree childrenFor: emptyModelViewModel).

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
	self assertCollection: ((treePresenter tree childrenFor: modelViewModel) collect: #name) includesAll: { 'Renamed Diagram' }
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testRenameDiagramToExecutesTransaction [

	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter renameDiagram: diagram to: 'Renamed Diagram'.

	self assert: diagram name equals: 'Renamed Diagram'.
	self assertCollection: ((treePresenter tree childrenFor: modelViewModel) collect: #name) includesAll: { 'Renamed Diagram' }
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testRenameDiagramUndoRestoresOriginalNameAndUpdatesList [

	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	treePresenter renameDiagram: diagram to: 'Renamed Diagram'.
	undoManager undo.

	self assert: diagram name equals: 'Original Diagram'.
	self assertCollection: ((treePresenter tree childrenFor: modelViewModel) collect: #name) includesAll: { 'Original Diagram' }
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testSelectionQueriesDeletePermissionAndUndoRedoAnnouncement [
	| modelViewModel |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	self assert: treePresenter projectViewModel identicalTo: projectController viewModel.
	self deny: (treePresenter isDeleteAllowedFor: diagram)
		description: 'Deleting the only diagram of a model should not be allowed'.

	treePresenter tree selectItem: diagram.
	self assert: treePresenter selectedModelForNewDiagram identicalTo: model.
	treePresenter tree selectItem: modelViewModel.
	self assert: treePresenter selectedModelForNewDiagram identicalTo: model.
	treePresenter diagramUnfocused.
	self assert: treePresenter selectedItem isNil
		description: 'diagramUnfocused should clear selection in treePresenter'.
	self assert: treePresenter selectedModelForNewDiagram identicalTo: model.

	treePresenter createDiagramForModel: model named: 'Second Diagram'.
	self assert: (project diagramsOf: model) size equals: 2.
	self assert: (treePresenter isDeleteAllowedFor: diagram)
		description: 'Deleting a diagram should be allowed when model has multiple diagrams'.

	treePresenter undoRedoChanged: OPUndoRedoChanged new.
	self assert: (treePresenter tree childrenFor: modelViewModel) size equals: 2
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testTreeHierarchyHasProjectModelAndDiagramLevels [
	| projectViewModel modelViewModels modelViewModel diagrams |
	projectViewModel := projectController viewModel.
	self assertCollection: treePresenter tree roots hasSameElements: { projectViewModel }.
	self assert: (treePresenter tree isExpanded: #( 1 )) description: 'Root project node should be expanded'.
	modelViewModels := treePresenter tree childrenFor: projectController viewModel.
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	self assertCollection: modelViewModels hasSameElements: { modelViewModel }.
	self assert: (treePresenter tree isExpanded: #( 1 1 )) description: 'Model node should be expanded'.
	diagrams := treePresenter tree childrenFor: modelViewModel.
	self assertCollection: diagrams hasSameElements: { diagram }.
	self assertEmpty: (treePresenter tree childrenFor: diagram)
]
