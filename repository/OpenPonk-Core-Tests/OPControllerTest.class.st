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
	self deny: (baseController canBeTargetFor: plainController) description: 'Base controller should not be target by default'.
	self deny: (plainController canBeSourceFor: plainController) description: 'Controller should not be source by default'.
	self deny: (plainController canBeTargetFor: plainController) description: 'Controller should not be target by default'.
	self deny: plainController isDiagramOnly description: 'Controller should not be diagram-only by default'.
	self deny: plainController isHideable description: 'Controller should not be hideable by default'.
	self assertEmpty: plainController dependentControllers
]

{ #category : 'tests' }
OPControllerTest >> testHandleModelRemovedRemovesMatchingControllerAndIgnoresOtherModels [

	| project projectController diagramController model otherModel controller viewModel element |
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	diagramController := OPDiagramController new.
	model := OPTestEntityModel new.
	otherModel := OPTestEntityModel new.
	controller := OPTestPlainController new.
	element := OPTestPlainDiagramElement new.
	controller
		projectController: projectController;
		model: model;
		diagramElement: element.
	viewModel := controller viewModel.
	diagramController addController: controller.

	viewModel announcer announce: (OPModelRemoved model: otherModel).
	viewModel announcer announce: (OPModelRemoved model: nil).
	self assert: controller viewModel identicalTo: viewModel.
	self assert: controller diagramElement identicalTo: element.
	self assertCollection: diagramController controllers includesAll: { controller }.

	viewModel announcer announce: (OPModelRemoved model: model).
	self assert: controller viewModel identicalTo: nil.
	self deny: controller diagramElement exists description: 'Removed diagramElement should be replaced by OPNoShape'.
	self denyCollection: diagramController controllers includesAny: { controller }.
	self assertEmpty: viewModel announcer subscriptions subscriptions
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

{ #category : 'tests' }
OPControllerTest >> testSubscribeToViewModelUsesWeakMessageSends [

	| viewModel controller subscriptions removedSubscription |
	viewModel := OPTestEntityViewModel forModel: OPTestEntityModel new.
	controller := OPTestPlainController new.
	[
		controller viewModel: viewModel.
		subscriptions := viewModel announcer subscriptions subscriptions.
		self assert: subscriptions size equals: 3.
		self assertCollection: (subscriptions collect: #announcementClass) hasSameElements: {
				OPModelChanged.
				OPElementFormNeedsRebuild.
				OPModelRemoved }.
		subscriptions do: [ :each |
				self assert: each class identicalTo: WeakAnnouncementSubscription.
				self assert: each subscriber identicalTo: controller.
				self assert: each action class identicalTo: WeakMessageSend.
				self assert: each action receiver identicalTo: controller ].
		removedSubscription := subscriptions detect: [ :each | each announcementClass == OPModelRemoved ].
		self assert: removedSubscription action selector equals: #handleModelRemoved: ] ensure: [ controller viewModel: nil ]
]
