Class {
	#name : 'OPControllerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'tests' }
OPControllerTest >> testAbstractHooksAndDefaultFlags [
	| baseController plainController |
	self should: [ OPController viewModelClass ] raise: SubclassResponsibility.
	baseController := OPController new.
	self should: [ baseController diagramController ] raise: SubclassResponsibility.
	self should: [ baseController projectController ] raise: SubclassResponsibility.
	self should: [ baseController ensureDeselected ] raise: SubclassResponsibility.
	self should: [ baseController showWithoutDependentInDiagram: nil ] raise: SubclassResponsibility.
	self should: [ baseController updateAfterDiagramFocused ] raise: SubclassResponsibility.

	plainController := OPTestPlainController new.
	self deny: (plainController canBeSourceFor: plainController) description: 'Controller should not be source by default'.
	self deny: (plainController canBeTargetFor: plainController) description: 'Controller should not be target by default'.
	self deny: plainController isDiagramOnly description: 'Controller should not be diagram-only by default'.
	self deny: plainController isHideable description: 'Controller should not be hideable by default'.
	self assertEmpty: plainController dependentControllers
]

{ #category : 'tests' }
OPControllerTest >> testModelUuidValidationAndDiagramElementManagement [
	| project projectController modelWithoutUuid validModel controller element |
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	controller := OPTestPlainController new.
	controller projectController: projectController.

	modelWithoutUuid := OPTestEntityModel new.
	modelWithoutUuid instVarNamed: #uuid put: nil.
	self
		should: [ controller model: modelWithoutUuid ]
		raise: Error.

	validModel := OPTestEntityModel new.
	controller model: validModel.
	self assert: controller model identicalTo: validModel.

	element := OPTestPlainDiagramElement new.
	controller diagramElement: element.
	self assert: controller ensureDiagramElement identicalTo: element.
	self assert: element modelElement identicalTo: validModel.

	controller removeDiagramElement.
	self
		deny: controller diagramElement exists
		description: 'Removed diagramElement should be replaced by OPNoShape'
]

{ #category : 'tests' }
OPControllerTest >> testSourceTargetGuardsAndCreationCommandExecution [
	| sourceCtrl targetCtrl createdCtrl mockDiagramCtrl undoMgr cmd |
	sourceCtrl := OPTestPlainController new.
	targetCtrl := OPTestPlainController new.
	createdCtrl := OPTestPlainController new.

	self
		should: [ sourceCtrl addAsSourceFor: createdCtrl ]
		raise: Error.
	self
		should: [ targetCtrl addAsTargetFor: createdCtrl onPosition: 10 @ 20 ]
		raise: Error.

	cmd := OPUndoTestLoggingCommand new.
	cmd log: OrderedCollection new.
	mockDiagramCtrl := Mock new.
	mockDiagramCtrl stub undoManager willReturn: nil.

	targetCtrl canBeTarget: true.
	targetCtrl diagramController: mockDiagramCtrl.
	createdCtrl creationCommand: cmd.

	targetCtrl addAsTargetFor: createdCtrl onPosition: 10 @ 20.
	self assert: (cmd instVarNamed: #log) size equals: 1.

	undoMgr := OPUndoManager new.
	mockDiagramCtrl stub undoManager willReturn: undoMgr.
	targetCtrl addAsTargetFor: createdCtrl onPosition: 30 @ 40.
	self assert: (cmd instVarNamed: #log) size equals: 2.
	self assert: undoMgr canUndo description: 'UndoManager should record creation command outside transaction'.

	undoMgr inTransaction: [
		targetCtrl addAsTargetFor: createdCtrl onPosition: 50 @ 60 ].
	self assert: (cmd instVarNamed: #log) size equals: 3.

	sourceCtrl removeFromDiagramController.
	self assert: sourceCtrl deselectedCount equals: 0
]
