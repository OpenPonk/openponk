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
OPDiagramsTreeTest >> testContextMenuForDiagramExecutesActionsAndEvaluatesEnablement [

	| mockWorkbench uiManager diagramMenu allItems itemByName deleteItem |
	mockWorkbench := Mock new.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub openEditorOnDiagram: Any.
	mockWorkbench stub deleteDiagram: Any.
	treePresenter owner: mockWorkbench.

	treePresenter tree unselectAll.
	self assert: treePresenter buildContextMenu identicalTo: nil.
	self assert: treePresenter tree contextMenu value identicalTo: nil.

	treePresenter tree selectItem: diagram.
	diagramMenu := treePresenter contextMenuForDiagram: diagram.
	allItems := diagramMenu menuGroups flatCollect: #menuItems.
	itemByName := [ :itemName | allItems detect: [ :eachItem | eachItem name = itemName ] ].

	deleteItem := itemByName value: 'Delete diagram'.
	self deny: deleteItem isEnabled description: 'Delete diagram menu item must be disabled for the only diagram'.

	uiManager := UIManager default.
	(uiManager stub request: Any initialAnswer: Any title: Any) willReturn: nil.
	(uiManager stub confirm: Any label: 'Delete') willReturn: false.
	diagram stub inspect willReturn: diagram.
	[
		(itemByName value: 'Open diagram') action value.
		mockWorkbench should receive openEditorOnDiagram: diagram.
		(itemByName value: 'Copy diagram...') action value.
		(itemByName value: 'Rename diagram') action value.
		(itemByName value: 'Delete diagram') action value.
		(itemByName value: 'Inspect Diagram') action value.
		diagram should receive inspect ] ensure: [
			uiManager recoverFromGHMutation.
			diagram recoverFromGHMutation ]
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
OPDiagramsTreeTest >> testCopyRenameAndDeleteDiagramDialogs [

	| uiManager mockWorkbench copyResponses renameResponses announcedDiagrams copiedDiagram |
	mockWorkbench := Mock new.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub openEditorOnDiagram: Any.
	mockWorkbench stub deleteDiagram: Any.
	treePresenter owner: mockWorkbench.

	announcedDiagrams := OrderedCollection new.
	project announcer when: OPDiagramAdded do: [ :announcement | announcedDiagrams add: announcement diagram ] for: self.

	uiManager := UIManager default.
	[
		(uiManager stub request: Any initialAnswer: Any title: 'Copy') willReturn: nil.
		treePresenter copyDiagram: diagram.
		self assert: (project diagramsOf: model) size equals: 1.

		copyResponses := OrderedCollection with: '' with: diagram name with: 'Copied Diagram'.
		(uiManager stub request: Any initialAnswer: Any title: 'Copy') will: [ copyResponses removeFirst ].
		treePresenter copyDiagram: diagram.
		self assert: (project diagramsOf: model) size equals: 2.
		copiedDiagram := announcedDiagrams first.
		self assert: copiedDiagram name equals: 'Copied Diagram'.
		mockWorkbench should receive openEditorOnDiagram: copiedDiagram.

		(uiManager stub request: Any initialAnswer: Any title: 'Rename') willReturn: nil.
		treePresenter renameDiagram: diagram.
		self assert: diagram name equals: 'Original Diagram'.

		renameResponses := OrderedCollection with: diagram name with: 'Prompt Renamed'.
		(uiManager stub request: Any initialAnswer: Any title: 'Rename') will: [ renameResponses removeFirst ].
		treePresenter renameDiagram: diagram.
		self assert: diagram name equals: 'Prompt Renamed'.

		(uiManager stub confirm: Any label: 'Delete') willReturn: false.
		treePresenter deleteDiagram: diagram.
		mockWorkbench should not receive deleteDiagram: diagram.

		(uiManager stub confirm: Any label: 'Delete') willReturn: true.
		treePresenter deleteDiagram: diagram.
		mockWorkbench should receive deleteDiagram: diagram ] ensure: [
			uiManager recoverFromGHMutation.
			project announcer unsubscribe: self ]
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testExpansionScrollRestorationAndEdgeFallbacks [

	| standaloneTree mockOwner treeWidget initialShowIndex modelViewModel collapseAnnouncement |
	standaloneTree := OPDiagramsTree newApplication: SpApplication defaultApplication.
	self assertEmpty: standaloneTree expandedViewModels.
	standaloneTree refresh.
	standaloneTree selectActiveDiagram.
	self assertEmpty: (standaloneTree childrenForNode: nil).
	standaloneTree
		expandNode: nil
		atPath: #( 1 )
		currentDepth: 4
		maxDepth: 3.

	mockOwner := Mock new.
	mockOwner stub projectController willReturn: projectController.
	mockOwner stub workbench willReturn: mockOwner.
	standaloneTree owner: mockOwner.
	self assert: standaloneTree projectController identicalTo: projectController.
	self assert: standaloneTree workbench identicalTo: mockOwner.

	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	collapseAnnouncement := Mock new.
	collapseAnnouncement stub expanded willReturn: false.
	collapseAnnouncement stub item willReturn: modelViewModel.
	treePresenter handleExpandChanged: collapseAnnouncement.
	self denyCollection: treePresenter expandedViewModels includesAny: { modelViewModel }.
	treePresenter handleExpandChanged: collapseAnnouncement.

	1 to: 40 do: [ :index |
			| extraDiagram |
			extraDiagram := (OPOpenPonkDiagram forModelElement: model)
				                name: 'ExtraDiagram ' , index asString;
				                yourself.
			project addDiagram: extraDiagram ].
	treePresenter refresh.
	treeWidget := treePresenter tree adapter widget.
	treeWidget extent: 300 @ 400.
	treeWidget recalculateVerticalScrollBar.
	treeWidget moveShowIndexTo: 20.
	initialShowIndex := treeWidget showIndex.
	self deny: initialShowIndex equals: 1.
	treePresenter refresh.
	self assert: treeWidget showIndex equals: initialShowIndex
]

{ #category : 'tests' }
OPDiagramsTreeTest >> testModelWithoutDiagramsIsShownAndReactsToDiagramAdded [

	| emptyModel emptyModelViewModel createdDiagram createdDiagrams |
	emptyModel := OPTestContainerModel new
		              name: 'Empty Model';
		              yourself.
	project addModel: emptyModel.
	project announcer announce: (OPModelAdded model: emptyModel).

	emptyModelViewModel := projectController viewModelRegistry viewModelFor: emptyModel.
	self assertCollection: (treePresenter tree childrenFor: projectController viewModel) includesAll: { emptyModelViewModel }.
	self assertEmpty: (treePresenter tree childrenFor: emptyModelViewModel).

	createdDiagram := (OPOpenPonkDiagram forModelElement: emptyModel)
		                  name: 'Created Diagram';
		                  yourself.
	project addDiagram: createdDiagram.
	project announcer announce: (OPDiagramAdded diagram: createdDiagram).
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

	| modelViewModel secondDiagram |
	modelViewModel := projectController viewModelRegistry viewModelFor: model.
	self assert: treePresenter projectViewModel identicalTo: projectController viewModel.
	self deny: (treePresenter isDeleteAllowedFor: diagram) description: 'Deleting the only diagram of a model should not be allowed'.

	treePresenter tree selectItem: diagram.
	self assert: treePresenter selectedItem identicalTo: diagram.
	treePresenter tree selectItem: modelViewModel.
	self assert: treePresenter selectedItem identicalTo: modelViewModel.
	treePresenter diagramUnfocused.
	self assert: treePresenter selectedItem identicalTo: nil.

	secondDiagram := (OPOpenPonkDiagram forModelElement: model)
		                 name: 'Second Diagram';
		                 yourself.
	project addDiagram: secondDiagram.
	project announcer announce: (OPDiagramAdded diagram: secondDiagram).
	self assert: (project diagramsOf: model) size equals: 2.
	self
		assert: (treePresenter isDeleteAllowedFor: diagram)
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
