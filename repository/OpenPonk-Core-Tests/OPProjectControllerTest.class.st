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
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
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
OPProjectControllerTest >> testAddDiagramControllerIsIdempotent [
	| diagramController |
	diagramController := OPDiagramController new.
	controller addDiagramController: diagramController.
	controller addDiagramController: diagramController.
	self assert: controller controllers size equals: 1
]

{ #category : 'tests' }
OPProjectControllerTest >> testMergeModelsAndDiagramsByPluginPreservesOwnedElementsAndNotifiesTrees [
	| model1 model2 entity1 entity2 diag1 diag2 canvas1 canvas2 diagCtrl1 diagCtrl2 node1 node2 note addedModels removedModels mergedDiagram |
	model1 := OPTestContainerModel new name: 'Package 1'; yourself.
	model2 := OPTestContainerModel new name: 'Package 2'; yourself.
	entity1 := OPTestEntityModel new name: 'Entity 1'; yourself.
	entity2 := OPTestEntityModel new name: 'Entity 2'; yourself.
	model1 add: entity1.
	model2 add: entity2.
	canvas1 := RSCanvas new.
	canvas2 := RSCanvas new.
	diag1 := OPOpenPonkDiagram forModelElement: model1.
	diag1 canvas: canvas1.
	diag2 := OPOpenPonkDiagram forModelElement: model2.
	diag2 canvas: canvas2.
	project addDiagram: diag1.
	project addDiagram: diag2.
	diagCtrl1 := OPTestDiagramController new.
	controller addDiagramController: diagCtrl1.
	diagCtrl1
		model: model1;
		diagramElement: diag1;
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: canvas1; yourself).
	node1 := (diagCtrl1 showInDiagramModel: entity1) diagramElement.
	diagCtrl2 := OPTestDiagramController new.
	controller addDiagramController: diagCtrl2.
	diagCtrl2
		model: model2;
		diagramElement: diag2;
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: canvas2; yourself).
	node2 := (diagCtrl2 showInDiagramModel: entity2) diagramElement.
	note := OPNote new text: 'Merged Note'; owningElement: diag2; yourself.
	addedModels := OrderedCollection new.
	removedModels := OrderedCollection new.
	project announcer
		when: OPModelAdded do: [ :ann | addedModels add: ann model ] for: self;
		when: OPModelRemoved do: [ :ann | removedModels add: ann model ] for: self.
	controller mergeModelsAndDiagramsByPlugin.
	project announcer unsubscribe: self.
	self assert: project models size equals: 1.
	self assert: project diagrams size equals: 1.
	self assertCollection: project models first entities hasSameElements: { entity1 . entity2 }.
	mergedDiagram := project diagrams first.
	self assertCollection: mergedDiagram ownedElements hasSameElements: { node1 . node2 . note }.
	self assertCollection: removedModels hasSameElements: { model1 . model2 }.
	self assert: addedModels asArray equals: { project models first }
]

{ #category : 'tests' }
OPProjectControllerTest >> testProjectControllerQueriesAndFileabilityAndDiagramUpdates [

	| container diagram testCanvas diagramController entity memoryFile |
	container := OPTestContainerModel new.
	entity := OPTestEntityModel new.
	container add: entity.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	diagramController := OPTestDiagramController new.
	controller addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPHeadlessCanvasPresenter new
				 canvas: testCanvas;
				 yourself).
	diagramController showInDiagramModel: entity.
	self
		assert: (controller hasDiagram: diagram)
		description: 'Project controller should report hasDiagram: true for registered diagram'.
	self
		assert: (controller hasModel: container diagram: diagram)
		description: 'Project controller should report hasModel:diagram: true for registered model and diagram'.
	self assert: controller enabledPlugins isCollection description: 'enabledPlugins should answer a collection'.
	self assert: controller recentProjects isDictionary description: 'recentProjects should answer a Dictionary'.
	self assert: controller modelMementos size equals: 1.
	controller selectInDiagram: entity.
	controller updateDiagrams.
	self assert: diagram isOpen description: 'Diagram with active controller should be marked open after updateDiagrams'.
	memoryFile := FileSystem memory root / 'test-save.opp'.
	self
		deny: (controller canProjectBeSavedToFile: nil)
		description: 'canProjectBeSavedToFile: should return false for nil file reference'.
	self
		assert: (controller canProjectBeSavedToFile: memoryFile)
		description: 'canProjectBeSavedToFile: should return true for writable in-memory file'
]

{ #category : 'tests' }
OPProjectControllerTest >> testRemoveController [
	| diagramController model |
	diagramController := OPDiagramController new.
	model := OPTestContainerModel new.
	controller addDiagramController: diagramController.
	diagramController model: model.
	controller removeDiagramController: diagramController.
	self
		deny: (controller hasModel: model)
		description: 'Project controller should no longer have the model after removing its diagram controller'.
	self
		deny: (model announcer hasSubscriber: diagramController)
		description: 'Removed diagram controller must be unsubscribed from model announcer'
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
OPProjectControllerTest >> testRenameProjectToSameNameDoesNotRecordUndoCommand [
	project name: 'Same Name'.
	controller renameProjectTo: 'Same Name'.
	self assert: project name equals: 'Same Name'.
	self
		deny: controller undoManager canUndo
		description: 'Renaming project to the identical name must not record an undo command'
]

{ #category : 'tests' }
OPProjectControllerTest >> testRenameProjectTransactively [
	project name: 'Old Project'.
	controller renameProjectTo: 'New Project'.
	self assert: project name equals: 'New Project'.
	controller undoManager undo.
	self assert: project name equals: 'Old Project'.
	controller undoManager redo.
	self assert: project name equals: 'New Project'
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveAndLoadFromFileAndMergeFromFile [
	| archiveFile loadedProject targetProject targetController mergedModelsCount |
	project name: 'Saved Project'.
	project addModel: (OPTestContainerModel new name: 'Pkg1'; yourself).
	project ensureModelsHaveDiagrams.
	archiveFile := FileSystem memory root / 'roundtrip.opp'.
	controller saveProjectTo: archiveFile.
	loadedProject := OPProjectController fromFile: archiveFile.
	self assert: loadedProject name equals: 'Saved Project'.
	self assert: loadedProject storageFile equals: archiveFile.
	self assert: loadedProject models size equals: 1.
	self assert: loadedProject diagrams size equals: 1.
	targetProject := OPProject name: 'Target Project'.
	targetController := OPProjectController forProject: targetProject.
	mergedModelsCount := 0.
	targetProject announcer when: OPModelAdded do: [ :ann | mergedModelsCount := mergedModelsCount + 1 ] for: self.
	targetController mergeFrom: archiveFile.
	self assert: targetProject models size equals: 1.
	self assert: targetProject diagrams size equals: 1.
	self assert: mergedModelsCount equals: 1.
	targetProject announcer unsubscribe: self
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectEmpty [
	| root store |
	root := FileSystem memory / 'project.opp'.
	self
		deny: root exists
		description: 'Target archive file should not exist before saving'.
	controller saveProjectTo: root.
	self
		assert: root exists
		description: 'Target archive file should exist after saving'.
	store := (FileSystem zip: root) open.
	self
		assert: (store / 'project' / 'project.json') exists
		description: 'Saved project archive must contain project/project.json'
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectWithModel [
	| memoryRoot root |
	project addModel: OPTestContainerModel new.
	memoryRoot := FileSystem memory / 'project'.
	self
		deny: memoryRoot exists
		description: 'Target archive file should not exist before saving'.
	controller saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open root.
	self
		assert: (root / 'project' / 'project.json') exists
		description: 'Saved project archive must contain project/project.json'.
	self
		assert: ((root / 'project' / 'models') children collect: #basename)
		equals: { project models first uuid asString }.
	self
		assertCollection:
			(((root / 'project' / 'models') children anyOne / 'model') children
				collect: #basename)
		includesAll: (Array with: 'model.ston')
]

{ #category : 'tests' }
OPProjectControllerTest >> testUndoRedoDelegationAndRemoveDiagramAndModel [
	| container diagram |
	container := OPTestContainerModel new name: 'ModelToRemove'; yourself.
	diagram := OPOpenPonkDiagram forModelElement: container.
	project addDiagram: diagram.
	self deny: controller canUndo description: 'Fresh controller should not have undoable commands'.
	self deny: controller canRedo description: 'Fresh controller should not have redoable commands'.
	controller renameProjectTo: 'Updated Name'.
	self assert: controller canUndo description: 'Controller should be able to undo after rename'.
	controller undo.
	self assert: project name equals: 'Unnamed project'.
	self assert: controller canRedo description: 'Controller should be able to redo after undo'.
	controller redo.
	self assert: project name equals: 'Updated Name'.
	controller removeDiagram: diagram.
	self assertEmpty: project diagrams.
	controller removeModel: container.
	self assertEmpty: project models
]
