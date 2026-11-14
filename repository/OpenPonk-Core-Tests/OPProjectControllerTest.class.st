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
	(self currentWorld submorphs select: [ :each | each isKindOf: GrowlMorph ])
		do: [ :each | each delete ].
	project := OPProject new.
	controller := OPProjectController forProject: project.
	OPPluginRegistry setDefaultForTesting
]

{ #category : 'running' }
OPProjectControllerTest >> tearDown [
	(self currentWorld submorphs select: [ :each | each isKindOf: GrowlMorph ])
		do: [ :each | each delete ].
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
OPProjectControllerTest >> testDefaultProjectFileNameFallbackAndFromDirectoryWithoutExportInfo [
	| folder loadedProject |
	project name: nil.
	self assert: controller defaultProjectFileName equals: 'project.opp'.
	project name: '   '.
	self assert: controller defaultProjectFileName equals: 'project.opp'.

	folder := FileSystem memory root / 'plain-project-dir'.
	folder ensureCreateDirectory.
	project name: 'Directory Project'.
	controller persistenceManager
		directory: folder;
		saveProject: project withMementos: controller modelMementos.
	loadedProject := OPProjectController fromDirectory: folder.
	self assert: loadedProject name equals: 'Directory Project'
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
OPProjectControllerTest >> testMergeModelsAndDiagramsValidationAndSingleModelMultipleDiagrams [
	| growls model1 diag1 nonMergeablePlugin secondModel nonMergeableModel1 nonMergeableModel2 model2 diag2 mockConfirm capturedAccept mockWorkbench mockEditor realDiagCtrl testLayouter |
	capturedAccept := nil.
	growls := [ self currentWorld submorphs select: [ :each | each isKindOf: GrowlMorph ] ].

	"1. Empty project"
	controller mergeModelsAndDiagramsByPlugin.
	controller mergeModelsAndDiagramsIntoOne.
	self assert: growls value size equals: 1.
	growls value do: #delete.

	"2. Single model with a single diagram"
	model1 := OPTestContainerModel new.
	diag1 := OPOpenPonkDiagram forModelElement: model1.
	project addModel: model1.
	project addDiagram: diag1.
	controller mergeModelsAndDiagramsIntoOne.
	self assert: growls value size equals: 1.
	growls value do: #delete.

	"3. Two different plugins with one model each"
	nonMergeablePlugin := OPTestNonMergeablePlugin new.
	OPPluginRegistry default add: nonMergeablePlugin.
	secondModel := nonMergeablePlugin modelClass new.
	project addModel: secondModel.
	controller mergeModelsAndDiagramsIntoOne.
	self assert: growls value size equals: 1.
	growls value do: #delete.
	project removeModel: secondModel.

	"4. Plugin that does not support merging with two models"
	nonMergeableModel1 := nonMergeablePlugin modelClass new.
	nonMergeableModel2 := nonMergeablePlugin modelClass new.
	project removeModel: model1.
	project removeDiagram: diag1.
	project addModel: nonMergeableModel1.
	project addModel: nonMergeableModel2.
	controller mergeModelsAndDiagramsIntoOne.
	self assert: growls value size equals: 1.
	growls value do: #delete.

	"5. Single model with two diagrams confirmed via SpConfirmDialog"
	OPPluginRegistry setDefaultForTesting.
	project removeModel: nonMergeableModel1.
	project removeModel: nonMergeableModel2.
	model2 := OPTestContainerModel new.
	diag1 := OPOpenPonkDiagram forModelElement: model2.
	diag2 := OPOpenPonkDiagram forModelElement: model2.
	project addModel: model2.
	project addDiagram: diag1.
	project addDiagram: diag2.

	testLayouter := OPTestCountingLayouter new.
	realDiagCtrl := OPTestDiagramController new.
	realDiagCtrl layouter: testLayouter.
	mockEditor := Mock new.
	mockEditor stub diagramController willReturn: realDiagCtrl.
	mockWorkbench := Mock new.
	mockWorkbench stub pluginRegistry willReturn: OPPluginRegistry default.
	mockWorkbench stub closeEditorOfDiagram: Any.
	(mockWorkbench stub openEditorOnDiagram: Any) willReturn: mockEditor.
	controller workbench: mockWorkbench.

	mockConfirm := Mock new.
	SpConfirmDialog stub new willReturn: mockConfirm.
	mockConfirm stub title: Any.
	mockConfirm stub message: Any.
	mockConfirm stub acceptLabel: Any.
	mockConfirm stub cancelLabel: Any.
	mockConfirm stub onAccept: [ :block | capturedAccept := block ].
	mockConfirm stub openDialog.

	controller mergeModelsAndDiagramsIntoOne.
	capturedAccept value.
	self assert: project diagrams size equals: 1.
	self assert: testLayouter dominanceTreeLayoutCount equals: 1
]

{ #category : 'tests' }
OPProjectControllerTest >> testMergeModelsAndDiagramsValidationIsolatesFromLeakedGrowlMorphs [
	| leakedGrowl |
	leakedGrowl := (GrowlMorph label: 'Leaked' contents: 'From previous test') openInWorld.
	[
		self setUp.
		self testMergeModelsAndDiagramsValidationAndSingleModelMultipleDiagrams ]
		ensure: [ leakedGrowl delete ]
]

{ #category : 'tests' }
OPProjectControllerTest >> testOpenFileDialogHelpersFromFileDoAndMergeFromFile [
	| sourceProject sourceController archiveFile mockOpenPresenter capturedBlock loadedFromDialog |
	capturedBlock := nil.
	loadedFromDialog := nil.
	sourceProject := OPProject name: 'Source For Dialog'.
	sourceProject addModel: (OPTestContainerModel new name: 'DialogPkg'; yourself).
	sourceProject ensureModelsHaveDiagrams.
	sourceController := OPProjectController forProject: sourceProject.
	archiveFile := FileSystem memory root / 'dialog-open.opp'.
	sourceController saveProjectTo: archiveFile.

	mockOpenPresenter := Mock new.
	StOpenFilePresenter stub new willReturn: mockOpenPresenter.
	mockOpenPresenter stub title: Any.
	mockOpenPresenter stub extensions: Any named: Any.
	mockOpenPresenter stub okAction: [ :block | capturedBlock := block ].
	mockOpenPresenter stub open.

	OPProjectController fromFileDo: [ :proj | loadedFromDialog := proj ].
	capturedBlock value: archiveFile.
	self assert: loadedFromDialog name equals: 'Source For Dialog'.

	controller mergeFromFile.
	capturedBlock value: archiveFile.
	self assert: project models size equals: 1.
	self assert: project diagrams size equals: 1
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
OPProjectControllerTest >> testSaveProjectAndCancelSaveProjectAs [
	| targetFile cancelPresenter savedNotifications |
	targetFile := FileSystem memory root / 'direct-save.opp'.
	project storageFile: targetFile.
	savedNotifications := OrderedCollection new.
	[ controller saveProject ]
		on: ProvideAnswerNotification
		do: [ :notif |
			savedNotifications add: notif messageText.
			notif resume: true ].
	self assert: targetFile exists description: 'saveProject should write archive to existing storageFile'.
	self assert: savedNotifications size equals: 1.

	cancelPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: cancelPresenter.
	cancelPresenter stub title: Any.
	cancelPresenter stub extensions: Any named: Any.
	cancelPresenter stub defaultFolder: Any.
	cancelPresenter stub nameText: Any.
	cancelPresenter stub openModal.
	cancelPresenter stub cancelled willReturn: true.
	cancelPresenter stub selectedEntry willReturn: nil.

	self
		should: [ controller saveProjectAs ]
		raise: InformativeNotification
]

{ #category : 'tests' }
OPProjectControllerTest >> testSaveProjectAsAcceptedAndUnwritableFallback [
	| existingParent acceptPresenter savedNotifications selectedTarget dirAsFile |
	existingParent := FileLocator temp.
	project storageFile: existingParent / 'missing-existing-parent.opp'.
	selectedTarget := FileSystem memory root / 'save-as-target.opp'.
	acceptPresenter := Mock new.
	StSaveFilePresenter stub new willReturn: acceptPresenter.
	acceptPresenter stub title: Any.
	acceptPresenter stub extensions: Any named: Any.
	acceptPresenter stub defaultFolder: Any.
	acceptPresenter stub nameText: Any.
	acceptPresenter stub openModal.
	acceptPresenter stub cancelled willReturn: false.
	acceptPresenter stub selectedEntry willReturn: selectedTarget.

	savedNotifications := OrderedCollection new.
	[ controller saveProjectAs ]
		on: ProvideAnswerNotification
		do: [ :notif |
			savedNotifications add: notif messageText.
			notif resume: true ].
	self assert: selectedTarget exists description: 'saveProjectAs should save project to selected file'.

	dirAsFile := FileSystem memory root / 'unwritable-directory'.
	dirAsFile ensureCreateDirectory.
	project storageFile: dirAsFile.
	self
		deny: (controller canProjectBeSavedToFile: dirAsFile)
		description: 'Existing directory cannot be created as file'.
	self
		assert: controller writableProjectFile
		equals: selectedTarget
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

{ #category : 'tests' }
OPProjectControllerTest >> testWorkbenchDelegationOpenDiagramsMergeWithAndUpdateDiagram [
	| mockWorkbench mockApp mockEditor mockDiagramCtrl baseModel diag1 diag2 otherProject otherModel otherDiag titleUpdated |
	mockApp := Mock new.
	mockEditor := Mock new.
	mockDiagramCtrl := Mock new.
	mockWorkbench := Mock new.
	titleUpdated := false.

	mockWorkbench stub application willReturn: mockApp.
	(mockWorkbench stub openEditorOnDiagram: Any) willReturn: mockEditor.
	mockWorkbench stub focusEditorOf: Any.
	mockWorkbench stub focusedEditor willReturn: mockEditor.
	mockWorkbench stub updateTitle will: [ titleUpdated := true ].
	mockEditor stub diagramController willReturn: mockDiagramCtrl.

	controller workbench: mockWorkbench.
	self assert: controller spApplication identicalTo: mockApp.
	self assert: controller viewModel identicalTo: controller viewModelRegistry projectViewModel.
	self assert: OPProjectController new undoManager isNotNil description: 'Lazy undoManager initialization should return an instance'.

	baseModel := OPTestContainerModel new.
	diag1 := (OPOpenPonkDiagram forModelElement: baseModel) isOpen: false; isSelected: false; yourself.
	diag2 := (OPOpenPonkDiagram forModelElement: baseModel) isOpen: false; isSelected: false; yourself.
	project addDiagram: diag1.
	project addDiagram: diag2.
	controller openDiagrams.
	mockWorkbench should receive openEditorOnDiagram: diag1.
	mockWorkbench should receive openEditorOnDiagram: diag2.

	diag1 isOpen: true; isSelected: true.
	diag2 isOpen: false; isSelected: false.
	controller openDiagrams.
	mockWorkbench should receive focusEditorOf: diag1.

	otherModel := OPTestContainerModel new.
	otherDiag := OPOpenPonkDiagram forModelElement: otherModel.
	otherProject := OPProject new.
	otherProject addModel: otherModel.
	otherProject addDiagram: otherDiag.
	controller mergeWith: otherProject.
	mockWorkbench should receive openEditorOnDiagram: otherDiag.

	controller saveProjectTo: FileSystem memory root / 'wb-title.opp'.
	self assert: titleUpdated description: 'saveProjectTo: should call updateTitle on attached workbench'.

	mockDiagramCtrl stub diagramElement willReturn: diag1.
	mockDiagramCtrl stub validate.
	controller addDiagramController: mockDiagramCtrl.
	controller updateDiagram: diag1.
	self assert: diag1 isSelected description: 'updateDiagram: should mark diagram as selected when its controller is focused'
]
