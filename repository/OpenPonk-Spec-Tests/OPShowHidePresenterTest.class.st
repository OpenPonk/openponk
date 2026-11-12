"
Verifies OPShowHidePresenter, OPCherryPickShowHidePresenter, and OPTypesShowHidePresenter element visibility toggling and announcements.
"
Class {
	#name : 'OPShowHidePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'entityA',
		'entityB',
		'diagram',
		'projectController',
		'diagramController',
		'pluginRegistry',
		'window'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'running' }
OPShowHidePresenterTest >> setUp [

	| editor testCanvas project container workbench |
	super setUp.
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: OPTestPlugin new.
	project := OPProject new.
	container := OPTestContainerModel new.
	entityA := OPTestEntityModel new.
	entityB := OPTestEntityModel new.
	container
		add: entityA;
		add: entityB.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	workbench := OPWorkbench new.
	workbench pluginRegistry: pluginRegistry.
	projectController := OPProjectController forProject: project.
	projectController workbench: workbench.
	workbench instVarNamed: #projectController put: projectController.
	editor := OPEditor new.
	editor instVarNamed: #workbench put: workbench.
	diagramController := OPTestDiagramController new.
	diagramController instVarNamed: #editor put: editor.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new
				 canvas: testCanvas;
				 yourself).
	diagramController showInDiagramModel: entityA.
	window := nil
]

{ #category : 'running' }
OPShowHidePresenterTest >> tearDown [

	window ifNotNil: [ :theWindow | theWindow close ].
	super tearDown
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testCherryPickAndTypesPresentersToggleVisibility [
	| cherryPick typesPresenter viewModelA viewModelB selectedAnnouncements unselectedAnnouncements rootTypeNode |
	viewModelA := projectController viewModelRegistry viewModelFor: entityA.
	viewModelB := projectController viewModelRegistry viewModelFor: entityB.
	cherryPick := OPCherryPickShowHidePresenter on: diagramController.
	self
		assert: cherryPick hasIcon
		description: 'OPCherryPickShowHidePresenter should provide icons for view models'.
	self
		assert: (cherryPick isSelected: viewModelA)
		description: 'Entity A is shown in diagram and should be marked selected'.
	self
		deny: (cherryPick isSelected: viewModelB)
		description: 'Entity B is not shown in diagram and should not be marked selected'.
	selectedAnnouncements := OrderedCollection new.
	unselectedAnnouncements := OrderedCollection new.
	cherryPick whenSelectionChangedDo: [ :ann |
		(ann isKindOf: OPShowHideElementsSelected)
			ifTrue: [ selectedAnnouncements add: ann ]
			ifFalse: [ unselectedAnnouncements add: ann ] ].
	cherryPick processAndUpdateSelected: viewModelB.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Selecting viewModelB in cherry-pick presenter should show entityB in diagram'.
	self assert: selectedAnnouncements size equals: 1.
	cherryPick processAndUpdateUnselected: viewModelA.
	self
		deny: (diagramController hasControllerForModel: entityA)
		description: 'Unselecting viewModelA in cherry-pick presenter should hide entityA from diagram'.
	self assert: unselectedAnnouncements size equals: 1.
	typesPresenter := OPTypesShowHidePresenter on: diagramController.
	self
		deny: typesPresenter hasIcon
		description: 'OPTypesShowHidePresenter does not define #iconFor: and should report hasIcon = false'.
	rootTypeNode := typesPresenter initialRoots first.
	self denyEmpty: (typesPresenter nameFor: rootTypeNode).
	typesPresenter processAndUpdateUnselected: rootTypeNode.
	self
		deny: (diagramController hasControllerForModel: entityB)
		description: 'Unselecting root type node should hide remaining shown entities'.
	typesPresenter processAndUpdateSelected: rootTypeNode.
	self
		assert: (diagramController hasControllerForModel: entityA)
		description: 'Selecting root type node should show entityA in diagram'.
	self
		assert: (diagramController hasControllerForModel: entityB)
		description: 'Selecting root type node should show entityB in diagram'
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testShowHidePresenterPagesInitialization [
	| presenter |
	presenter := OPShowHidePresenter on: diagramController.
	self assert: (presenter instVarNamed: #notebook) pages size equals: 2.
	presenter refreshCurrentPage
]

{ #category : 'tests' }
OPShowHidePresenterTest >> testShowHidePresenterWindowAndTabSwitching [

	| presenter notebook cherryPick typesPresenter |
	presenter := OPShowHidePresenter on: diagramController.
	self assert: presenter defaultKeyboardFocus identicalTo: presenter.

	window := presenter open.
	self assert: window title equals: 'Show / Hide Elements in ' , diagram name , ' - OpenPonk'.
	notebook := presenter instVarNamed: #notebook.
	self assert: notebook pages size equals: 2.
	cherryPick := notebook selectedPage activePresenter.
	self assert: cherryPick class identicalTo: OPCherryPickShowHidePresenter.
	self assert: presenter defaultKeyboardFocus identicalTo: cherryPick.
	self denyEmpty: cherryPick selectedItems.

	notebook selectPage: notebook pages second.
	presenter refreshCurrentPage.
	typesPresenter := notebook selectedPage activePresenter.
	self assert: typesPresenter class identicalTo: OPTypesShowHidePresenter.
	self denyEmpty: typesPresenter selectedItems
]
