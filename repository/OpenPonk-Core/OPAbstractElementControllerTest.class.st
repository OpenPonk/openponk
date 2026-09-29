"
Abstract base class for testing specific diagram element controllers. 
Verifies essential interactions such as rendering, detachment from the canvas, relation building, and correct target creation.
"
Class {
	#name : 'OPAbstractElementControllerTest',
	#superclass : 'OPBaseControllerTest',
	#instVars : [
		'diagramController',
		'creationTargetController'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'constants' }
OPAbstractElementControllerTest class >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : 'testing' }
OPAbstractElementControllerTest class >> isAbstract [

	^ self = OPAbstractElementControllerTest
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> allElements [
	"override in order to redefine how to gather all elements in the entire model, even hidden ones and ones deep inside other elements"

	^ diagramController model allElements
]

{ #category : 'constants' }
OPAbstractElementControllerTest >> creationTargetControllerClass [

	^ self diagramControllerClass
]

{ #category : 'constants' }
OPAbstractElementControllerTest >> creationTargetModelClass [

	^ self diagramModelClass
]

{ #category : 'constants' }
OPAbstractElementControllerTest >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> diagramElementClass [
    ^ self class diagramElementClass
]

{ #category : 'constants' }
OPAbstractElementControllerTest >> diagramModelClass [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPAbstractElementControllerTest >> prepareToShow [

	self showDependenciesInDiagram.
	controller model: model.
	self registerModel
]

{ #category : 'initialization' }
OPAbstractElementControllerTest >> registerModel [

	controller viewModel registerModelIn:
		(creationTargetController parentWhenTargetFor: controller)
]

{ #category : 'running' }
OPAbstractElementControllerTest >> setUp [
	| rootModel project projectController |
	super setUp.
	rootModel := self diagramModelClass new.
	project := OPProject new.
	project addModel: rootModel.

	projectController := OPProjectController forProject: project.

	diagramController := self diagramControllerClass new.
	diagramController canvasPresenter: (OPCanvasPresenter new
		canvas: RSCanvas new;
		yourself).
	diagramController diagramElement: (OPOpenPonkDiagram forModelElement: rootModel).

	projectController addDiagramController: diagramController.
	diagramController model: rootModel.

	controller diagramController: diagramController.

	self setUpCreationTarget
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTarget [

	self creationTargetControllerClass = self diagramControllerClass
		ifTrue: [ ^ creationTargetController := diagramController ].

	self setUpCreationTargetController.
	self setUpCreationTargetModel
]

{ #category : 'initialization' }
OPAbstractElementControllerTest >> setUpCreationTargetController [

	creationTargetController := self creationTargetControllerClass new.
	creationTargetController diagramController: diagramController
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTargetModel [

	^ creationTargetController createModelIn: diagramController model
]

{ #category : 'initialization' }
OPAbstractElementControllerTest >> showDependenciesInDiagram [

	creationTargetController showWithoutDependentInDiagram:
		diagramController
]

{ #category : 'initialization' }
OPAbstractElementControllerTest >> showInDiagram [

	self prepareToShow.
	controller showWithoutDependentInDiagram: diagramController
]

{ #category : 'tests - controllers' }
OPAbstractElementControllerTest >> testAddController [

	self prepareToShow.
	diagramController addController: controller.
	self
		assert: (diagramController controllerForModel: self model)
		equals: controller.
	self assert: controller diagramController equals: diagramController
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testBeingCopiedWithDiagram [
	| diagram diagramElement diagramControllerOfCopy |
	self assertEmpty: diagramController controllers.
	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self assert: (diagramController hasControllerForModel: self model).
	self assertCollection: diagram allOwnedElements includesAll: { diagramElement }.
	self assertCollection: diagramController controllers includesAll: { controller }.

	diagramControllerOfCopy := self diagramControllerClass new.
	diagramController projectController addDiagramController: diagramControllerOfCopy.
	diagramControllerOfCopy model: diagramController model.
	diagramControllerOfCopy diagramElement: diagram newCopy.
	diagramControllerOfCopy canvasPresenter: (OPCanvasPresenter new
		canvas: RSCanvas new;
		yourself).
	diagramControllerOfCopy diagramFocused.

	self
		assertCollection: (diagramControllerOfCopy diagram allOwnedElements collect: #modelElement)
		hasSameElements: (diagramController diagram allOwnedElements collect: #modelElement).
	self
		assertCollection: (diagramControllerOfCopy controllers collect: #model)
		hasSameElements: (diagramController controllers collect: #model)
]

{ #category : 'tests - ui interaction' }
OPAbstractElementControllerTest >> testBeingKeptWhenEditorFocusChanges [

	self
		assertCollection: diagramController controllers
		hasSameElements: {  }.
	self showInDiagram.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	diagramController diagramFocused.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testBeingRemovedAfterModelRemovalWhenNotRendered [
	| diagram diagramElement newDiagramControllerBlock diagramControllerOfCopy controllerOfCopy recreatedDiagramController diagramOfCopy diagramElementOfCopy recreatedDiagram |
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.

	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self
		assertCollection: (diagramController controllers collect: #model)
		includesAll: { model }.
	self
		assertCollection: (diagramController controllers collect: #model)
		includesAll: { model }.
	self assert: diagramElement isRendered.

	diagramController removeController.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self
		denyCollection: (diagramController controllers collect: #model)
		includesAll: { model }.
	self deny: diagramElement isRendered.

	newDiagramControllerBlock := [ :copyOfDiagram |
		| newDiagramController |
		newDiagramController := self diagramControllerClass new.
		diagramController projectController addDiagramController: newDiagramController.
		newDiagramController model: diagramController model.
		newDiagramController diagramElement: copyOfDiagram.
		newDiagramController canvasPresenter: (OPCanvasPresenter new
			canvas: RSCanvas new;
			yourself).
		newDiagramController diagramFocused.
		newDiagramController ].

	diagramControllerOfCopy := newDiagramControllerBlock value: diagram newCopy.
	controllerOfCopy := diagramControllerOfCopy controllerForModel: model.
	diagramOfCopy := diagramControllerOfCopy diagram.
	diagramElementOfCopy := controllerOfCopy diagramElement.
	diagramControllerOfCopy validate.

	self
		assertCollection: diagramControllerOfCopy controllers
		includesAll: { controllerOfCopy }.
	self
		assertCollection: diagramOfCopy allOwnedElements
		includesAll: { diagramElementOfCopy }.
	self
		assertCollection: (diagramControllerOfCopy controllers collect: #model)
		includesAll: { model }.
	self assert: diagramElementOfCopy isRendered.

	controllerOfCopy viewModel removeModel.
	recreatedDiagramController := newDiagramControllerBlock value: diagram.
	recreatedDiagram := recreatedDiagramController diagramElement.
	recreatedDiagramController validate.

	self
		denyCollection: (recreatedDiagramController controllers collect: #model)
		includesAll: { model }.
	self deny: diagramElement isRendered
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testBeingRemovedAfterModelRemovalWhenRendered [
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self showInDiagram.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	controller viewModel removeModel.
	controller model: model.
	diagramController diagramFocused.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testClassSideModelClass [

	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : 'tests - construction' }
OPAbstractElementControllerTest >> testCreateAndShow [

	controller
		createModelIn: creationTargetController model
		andShowInDiagram: diagramController.
	self denyCollection: self allElements hasSameElements: {  }.
	self
		assertCollection: diagramController controllers asArray
		includesAll: { controller }.
	self
		assertCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	self
		assert: diagramController isRendered
		description:
		'Diagram controller not showing as rendered when element is'
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testCreateController [
	self assert: controller class equals: self controllerClass
]

{ #category : 'tests - creation' }
OPAbstractElementControllerTest >> testCreateDiagramElement [

	self prepareToShow.
	controller diagramController: diagramController.
	controller ensureShownDependenciesInDiagram: diagramController.
	controller createDiagramElement.
	self
		assert: controller diagramElement class
		equals: self diagramElementClass
]

{ #category : 'tests - construction' }
OPAbstractElementControllerTest >> testCreateModel [

	| createdModel |
	createdModel := controller createModelIn:
		                creationTargetController model.
	self assert: controller model isNotNil.
	self assert: createdModel equals: controller model.
	self assert: controller model class equals: self modelClass.
	self
		assertCollection: self allElements
		includesAll: { controller model }
]

{ #category : 'tests - transactions' }
OPAbstractElementControllerTest >> testCreateUndoRedo [
	| undoManager createdModel createdDiagramElement |
	self testCreateUsingAddAsTarget.
	undoManager := diagramController undoManager.
	createdModel := controller model.
	createdDiagramElement := controller diagramElement.

	undoManager undo.
	self denyCollection: (diagramController controllers collect: #model) includesAny: { createdModel }.
	self deny: createdDiagramElement isRendered.

	undoManager redo.
	self assertCollection: (diagramController controllers collect: #model) includesAll: { createdModel }.
	self assert: createdDiagramElement isRendered.

	undoManager undo.
	self denyCollection: (diagramController controllers collect: #model) includesAny: { createdModel }.
	self deny: createdDiagramElement isRendered.

	undoManager redo.
	self assertCollection: (diagramController controllers collect: #model) includesAll: { createdModel }.
	self assert: createdDiagramElement isRendered
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testCreateUsingAddAsTarget [

	self showDependenciesInDiagram.
	self denyCollection: self allElements includesAll: { model }.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self
		denyCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	creationTargetController addAsTargetFor: controller.
	self deny: controller model equals: model.
	model := controller model.
	self assertCollection: self allElements includesAll: { model }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	self
		assertCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	self
		assert: controller diagramElement class
		equals: self diagramElementClass
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testDescriptionName [

	| diagramElement |
	model := Mock new.
	model stub class willReturn: self modelClass.
	model stub name willReturn: 'bravo'.
	diagramElement := Mock new.
	diagramElement stub class willReturn: self diagramElementClass.
	controller diagramController: diagramController.
	controller model: model.
	controller diagramElement: diagramElement.
	controller viewModel descriptionName accessor
		write: 'charlie'
		to: controller.
	model should receive name: 'charlie'.
	self
		assert:
		(controller viewModel descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]

{ #category : 'tests - undo/redo' }
OPAbstractElementControllerTest >> testHideUndoRedo [
	| undoManager elementModel hideCommand |
	self testCreateUsingAddAsTarget.
	self assert: controller isHideable.
	undoManager := diagramController undoManager.
	elementModel := controller model.

	hideCommand := OPHideDiagramElementCommand
		model: elementModel
		diagramController: diagramController.
	undoManager inTransaction: [ undoManager execute: hideCommand ].

	self deny: (diagramController hasControllerForModel: elementModel).
	self assertCollection: self allElements includesAll: { elementModel }.

	undoManager undo.
	self assert: (diagramController hasControllerForModel: elementModel).
	self assertCollection: self allElements includesAll: { elementModel }.

	undoManager redo.
	self deny: (diagramController hasControllerForModel: elementModel).
	self assertCollection: self allElements includesAll: { elementModel }.

	undoManager undo.
	self assert: (diagramController hasControllerForModel: elementModel).
	self assertCollection: self allElements includesAll: { elementModel }
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testIsSupported [

	self assert:
		(diagramController hasSupportForModel: self controllersByModelsKey)
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testModelClass [
	self assert: controller modelClass equals: self modelClass
]

{ #category : 'tests - controllers' }
OPAbstractElementControllerTest >> testModelForFigure [

	self showInDiagram.
	self
		assert:
		(diagramController modelForRoassalShape: controller roassalShape)
		equals: self model
]

{ #category : 'testing - consistency' }
OPAbstractElementControllerTest >> testMultiLineFormFieldsProperlyWrapInDiagramShapes [

	| form multiLinePresenters |
	self showInDiagram.

	form := OPPropertiesForm new.
	[
		form viewModel: controller viewModel.

		multiLinePresenters := form focusOrder select: [ :presenter |
			                       (presenter isKindOf: SpTextPresenter) or: [ presenter isKindOf: OPLongTextPresenter ] ].

		multiLinePresenters do: [ :presenter |
				| originalText sentinel labelsWithNewline |
				originalText := presenter text ifNil: [ '' ] ifNotNil: [ :text | text asString ].
				sentinel := 'TEST_L1_' , UUID new asString , String cr , 'TEST_L2'.

				presenter text: sentinel.
				controller modelChanged.

				labelsWithNewline := diagramController canvas allChildren select: [ :shape |
						                     (shape isKindOf: RSLabel) and: [
								                     shape text notNil and: [
										                     (shape text includesSubstring: sentinel) or: [
											                     (shape text includesSubstring: 'TEST_L1_') and: [
												                     (shape text includes: Character cr) or: [ shape text includes: Character lf ] ] ] ] ] ].

				self assert: labelsWithNewline isEmpty description: [
						String streamContents: [ :stream |
								stream
									nextPutAll: 'Inconsistency in controller ';
									nextPutAll: controller className;
									nextPutAll: ': form field (';
									nextPutAll: presenter className;
									nextPutAll: ') propagates multiline text directly to single-line ';
									nextPutAll: labelsWithNewline first className;
									nextPutAll: ' in diagram element ';
									nextPutAll: controller diagramElement className;
									nextPutAll: '. Cairo cannot wrap this text and renders tofu glyphs.' ] ].

				presenter text: originalText.
				controller modelChanged ] ] ensure: [ form viewModel: nil ]
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testNaturalExtentNotOverriddenByFallback [
	(controller diagramElement respondsTo: #shouldBeResizableByUser) ifFalse: [ ^ self ].
	controller diagramElement shouldBeResizableByUser ifFalse: [ ^ self ].

	self testCreateUsingAddAsTarget.

	self
		deny: controller diagramElement bounds extent
		equals: 50 @ 50
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testNaturalExtentPreservedOnCreation [
	| expectedExtent actualExtent |
	self diagramElementClass isNode ifFalse: [ ^ self ].

	self showDependenciesInDiagram.
	creationTargetController addAsTargetFor: controller onPosition: (100 @ 100).

	(controller diagramElement respondsTo: #shouldBeResizableByUser) ifFalse: [ ^ self ].
	controller diagramElement shouldBeResizableByUser ifFalse: [ ^ self ].

	expectedExtent := controller diagramElement renderBasicShape extent.
	actualExtent := controller diagramElement bounds extent.

	self
		assert: (actualExtent x closeTo: expectedExtent x precision: 1.0)
		description: [ 'Expected width close to ' , expectedExtent x asString , ' but got ' , actualExtent x asString ].
	self
		assert: (actualExtent y closeTo: expectedExtent y precision: 1.0)
		description: [ 'Expected height close to ' , expectedExtent y asString , ' but got ' , actualExtent y asString ].
	(expectedExtent closeTo: (50 @ 50)) ifFalse: [
		self deny: actualExtent equals: (50 @ 50) ]
]

{ #category : 'tests - controllers' }
OPAbstractElementControllerTest >> testNewControllerFor [

	controller := diagramController newControllerFor: self controllersByModelsKey.
	self assert: controller class equals: self controllerClass
]

{ #category : 'tests - ui interaction' }
OPAbstractElementControllerTest >> testOpenInForm [

	| form |
	self showInDiagram.
	form := OPPropertiesForm new.
	diagramController stub form willReturn: form.
	self assert: form layout children isEmpty.
	diagramController openInForm: controller viewModel.
	self assert: form layout children isNotEmpty
]

{ #category : 'tests - destruction' }
OPAbstractElementControllerTest >> testRemoveController [

	| totalShapesAmount |
	self assert: diagramController canvas shapes size equals: 0.
	self showInDiagram.
	totalShapesAmount := diagramController canvas shapes size.
	self
		assertCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	controller removeControllerAndDiagramElement.
	self
		should: [ diagramController controllerForModel: model ]
		raise: NotFound.
	self assert: diagramController canvas shapes size < totalShapesAmount
]

{ #category : 'tests - destruction' }
OPAbstractElementControllerTest >> testRemoveFigureAndModel [

	| totalShapesAmount |
	self assert: diagramController canvas shapes size equals: 0.
	self showInDiagram.
	totalShapesAmount := diagramController canvas shapes size.
	self
		assertCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	diagramController removeModelOfRoassalShape: controller roassalShape.
	self
		should: [ diagramController controllerForModel: model ]
		raise: NotFound.
	self assert: diagramController canvas shapes size < totalShapesAmount
]

{ #category : 'tests - destruction' }
OPAbstractElementControllerTest >> testRemoveModel [

	self showInDiagram.
	self assertCollection: self allElements includesAll: { model }.
	controller viewModel removeModel.
	self denyCollection: self allElements includesAll: { model }
]

{ #category : 'tests - undo/redo' }
OPAbstractElementControllerTest >> testRemoveUndoRedo [
	| undoManager createdModel |
	self testCreateUsingAddAsTarget.
	undoManager := diagramController undoManager.
	createdModel := controller model.

	diagramController removeModelElement: createdModel.
	self deny: (diagramController hasControllerForModel: createdModel).
	self denyCollection: self allElements includesAny: { createdModel }.

	undoManager undo.
	self assert: (diagramController hasControllerForModel: createdModel).
	self assertCollection: self allElements includesAll: { createdModel }.

	undoManager redo.
	self deny: (diagramController hasControllerForModel: createdModel).
	self denyCollection: self allElements includesAny: { createdModel }.

	undoManager undo.
	self assert: (diagramController hasControllerForModel: createdModel).
	self assertCollection: self allElements includesAll: { createdModel }
]

{ #category : 'tests - controllers' }
OPAbstractElementControllerTest >> testRoassalShapeForModel [

	self showInDiagram.
	self
		assert: (diagramController roassalShapeForModel: self model)
		equals: controller roassalShape
]

{ #category : 'tests - construction' }
OPAbstractElementControllerTest >> testRoassalShapeWasRendered [

	self showInDiagram.
	self assert:
		(diagramController canvas nodes includes: controller roassalShape)
]

{ #category : 'tests - construction' }
OPAbstractElementControllerTest >> testShowInDiagram [

	self showInDiagram.
	self
		assert:
		(diagramController controllerForRoassalShape:
			 controller roassalShape)
		equals: controller.
	self assert: (diagramController canvas shapes anySatisfy: [ :each |
			 each model isNotNil and: [ each model modelElement = self model ] ])
]

{ #category : 'tests - undo/redo' }
OPAbstractElementControllerTest >> testShowUndoRedo [
	| undoManager elementModel showCommand |
	self testCreateUsingAddAsTarget.
	undoManager := diagramController undoManager.
	elementModel := controller model.

	diagramController hideModelFromDiagram: elementModel.
	self deny: (diagramController hasControllerForModel: elementModel).

	showCommand := OPShowDiagramElementCommand
		model: elementModel
		diagramController: diagramController.
	undoManager inTransaction: [ undoManager execute: showCommand ].

	self assert: (diagramController hasControllerForModel: elementModel).

	undoManager undo.
	self deny: (diagramController hasControllerForModel: elementModel).

	undoManager redo.
	self assert: (diagramController hasControllerForModel: elementModel).

	undoManager undo.
	self deny: (diagramController hasControllerForModel: elementModel)
]
