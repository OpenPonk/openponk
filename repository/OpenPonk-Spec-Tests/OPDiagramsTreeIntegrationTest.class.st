"
Integration test verifying synchronization between the diagrams list presenter and active workbench editors.
"
Class {
	#name : 'OPDiagramsTreeIntegrationTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'project',
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'running' }
OPDiagramsTreeIntegrationTest >> setUp [
	| containerModel |
	super setUp.
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	containerModel name: 'TestPackage'.
	project addModel: containerModel.
	diagram := (OPOpenPonkDiagram forModelElement: containerModel)
		name: 'Diagram Name';
		yourself.
	project addDiagram: diagram.

	workbench := OPWorkbench new.
	workbench pluginRegistry: (OPPluginRegistry new add: OPTestPlugin new; yourself).
	workbench openProject: project
]

{ #category : 'running' }
OPDiagramsTreeIntegrationTest >> tearDown [
	workbench ifNotNil: [
		workbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPDiagramsTreeIntegrationTest >> testActivateModelNodeDoesNotOpenSecondEditor [
	| listPresenter modelViewModel secondModel |
	listPresenter := workbench diagramsTree.
	secondModel := OPTestContainerModel new
		name: 'SecondPackage';
		yourself.
	project addModel: secondModel.
	project announcer announce: (OPModelAdded model: secondModel).
	modelViewModel := workbench projectController viewModelRegistry viewModelFor: secondModel.

	listPresenter activateItem: modelViewModel.
	self assert: workbench notebook pages size equals: 1
]

{ #category : 'tests' }
OPDiagramsTreeIntegrationTest >> testRenameDiagramReflectsInListAndSupportsUndoRedo [
	| listPresenter modelViewModel |
	listPresenter := workbench diagramsTree.
	modelViewModel := workbench projectController viewModelRegistry viewModelFor: diagram modelElement.

	listPresenter renameDiagram: diagram to: 'Updated Name'.
	self assert: diagram name equals: 'Updated Name'.
	self
		assertCollection: ((listPresenter tree childrenFor: modelViewModel) collect: #name)
		includesAll: #( 'Updated Name' ).

	workbench projectController undoManager undo.
	self assert: diagram name equals: 'Diagram Name'.
	self
		assertCollection: ((listPresenter tree childrenFor: modelViewModel) collect: #name)
		includesAll: #( 'Diagram Name' ).

	workbench projectController undoManager redo.
	self assert: diagram name equals: 'Updated Name'.
	self
		assertCollection: ((listPresenter tree childrenFor: modelViewModel) collect: #name)
		includesAll: #( 'Updated Name' )
]

{ #category : 'tests' }
OPDiagramsTreeIntegrationTest >> testRenameDiagramUpdatesTabTitleAndSupportsUndoRedo [
	| page |
	page := workbench pageFor: diagram.
	self assert: page title equals: '[Diagram Name] TestPackage'.

	workbench diagramsTree renameDiagram: diagram to: 'Updated Name'.
	self assert: page title equals: '[Updated Name] TestPackage'.

	workbench projectController undoManager undo.
	self assert: page title equals: '[Diagram Name] TestPackage'.

	workbench projectController undoManager redo.
	self assert: page title equals: '[Updated Name] TestPackage'
]

{ #category : 'tests' }
OPDiagramsTreeIntegrationTest >> testRenameRootModelUpdatesDiagramsWidgetAndSupportsUndoRedo [

	| containerModel containerViewModel projectTree diagramsTree assertProjectAndModel assertProjectTree assertDiagramsTree assertTrees projectRefreshes diagramsRefreshes |
	containerModel := diagram modelElement.
	containerViewModel := workbench projectController viewModelRegistry viewModelFor: containerModel.

	projectTree := workbench projectTree tree.
	diagramsTree := workbench diagramsTree tree.

	projectRefreshes := 0.
	diagramsRefreshes := 0.
	projectTree whenRootsChangedDo: [ projectRefreshes := projectRefreshes + 1 ].
	diagramsTree whenRootsChangedDo: [ diagramsRefreshes := diagramsRefreshes + 1 ].

	assertProjectAndModel := [ :treePresenter :projectName :modelName |
		                         | projectNode modelNodes modelNode |
		                         self assertCollection: treePresenter roots hasSameElements: { workbench projectController viewModel }.
		                         projectNode := treePresenter roots anyOne.
		                         self assert: (treePresenter display value: projectNode) equals: projectName.
		                         modelNodes := treePresenter childrenFor: projectNode.
		                         self assert: modelNodes size equals: 1.
		                         modelNode := modelNodes anyOne.
		                         self assert: (treePresenter display value: modelNode) equals: modelName.
		                         modelNode ].
	assertProjectTree := [ :projectName :modelName | assertProjectAndModel value: projectTree value: projectName value: modelName ].
	assertDiagramsTree := [ :projectName :modelName :diagramName |
		                      | modelNode diagramNodes diagramNode |
		                      modelNode := assertProjectAndModel value: diagramsTree value: projectName value: modelName.
		                      diagramNodes := diagramsTree childrenFor: modelNode.
		                      self assert: diagramNodes size equals: 1.
		                      diagramNode := diagramNodes anyOne.
		                      self assert: (diagramsTree display value: diagramNode) equals: diagramName.
		                      diagramNode ].
	assertTrees := [ :projectName :modelName :diagramName |
		               assertProjectTree value: projectName value: modelName.
		               assertDiagramsTree value: projectName value: modelName value: diagramName ].

	assertTrees value: 'Unnamed project (Project)' value: 'TestPackage (Test Container Model)' value: 'Diagram Name (Diagram)'.
	self assert: projectRefreshes equals: 0.
	self assert: diagramsRefreshes equals: 0.

	workbench projectController undoManager execute: (OPPropertyChangeCommand
			 viewModel: containerViewModel
			 selector: #name
			 oldValue: 'TestPackage'
			 newValue: 'RenamedPackage').

	assertTrees value: 'Unnamed project (Project)' value: 'RenamedPackage (Test Container Model)' value: 'Diagram Name (Diagram)'.
	self assert: projectRefreshes equals: 1.
	self assert: diagramsRefreshes equals: 1.

	workbench projectController undoManager undo.

	assertTrees value: 'Unnamed project (Project)' value: 'TestPackage (Test Container Model)' value: 'Diagram Name (Diagram)'.
	self assert: projectRefreshes equals: 2.
	self assert: diagramsRefreshes equals: 2.

	workbench projectController undoManager redo.

	assertTrees value: 'Unnamed project (Project)' value: 'RenamedPackage (Test Container Model)' value: 'Diagram Name (Diagram)'.
	self assert: projectRefreshes equals: 3.
	self assert: diagramsRefreshes equals: 3
]
