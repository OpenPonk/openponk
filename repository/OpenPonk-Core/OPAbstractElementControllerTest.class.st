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

{ #category : 'testing' }
OPAbstractElementControllerTest class >> isAbstract [

	^ self = OPAbstractElementControllerTest
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> allElements [
	"override in order to redefine how to gather all elements in the entire model, even hidden ones and ones deep inside other elements"

	^ diagramController model allElements
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> creationTargetControllerClass [

	^ self diagramControllerClass
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> creationTargetModelClass [

	^ self diagramModelClass
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : 'construction' }
OPAbstractElementControllerTest >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> diagramModelClass [
	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPAbstractElementControllerTest >> prepareToShow [

	self showDependenciesInDiagram.
	controller model: model.
	self registerModel
]

{ #category : 'as yet unclassified' }
OPAbstractElementControllerTest >> registerModel [

	controller registerModelIn:
		(creationTargetController parentWhenTargetFor: controller)
]

{ #category : 'running' }
OPAbstractElementControllerTest >> setUp [

	super setUp.
	diagramController := self diagramControllerClass new.
	diagramController model: self diagramModelClass new.
	diagramController canvasPresenter: (OPCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	diagramController diagramElement:
		(OPOpenPonkDiagram forModelElement: diagramController model).
	self setUpCreationTarget
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTarget [

	self creationTargetControllerClass = self diagramControllerClass
		ifTrue: [ ^ creationTargetController := diagramController ].

	self setUpCreationTargetController.
	self setUpCreationTargetModel
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTargetController [

	creationTargetController := self creationTargetControllerClass new.
	creationTargetController diagramController: diagramController
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTargetModel [

	^ creationTargetController createModelIn: diagramController model
]

{ #category : 'as yet unclassified' }
OPAbstractElementControllerTest >> showDependenciesInDiagram [

	creationTargetController showWithoutDependentInDiagram:
		diagramController
]

{ #category : 'as yet unclassified' }
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

{ #category : 'tests - ui interaction' }
OPAbstractElementControllerTest >> testBeingCopiedWithDiagram [

	| diagram diagramElement diagramControllerOfCopy |
	self assertEmpty: diagramController controllers.
	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self assert: (diagramController hasControllerForModel: self model).
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	diagramControllerOfCopy := self diagramControllerClass new.
	diagramControllerOfCopy model: diagramController model.
	self
		shouldnt: [ diagramControllerOfCopy diagramElement: diagram newCopy ]
		raise: OPInvalidWarning.
	diagramControllerOfCopy canvasPresenter: (OPCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	diagramControllerOfCopy diagramFocused.
	self
		assertCollection:
			(diagramControllerOfCopy diagram allOwnedElements collect:
				 #modelElement)
		hasSameElements:
		(diagramController diagram allOwnedElements collect: #modelElement).
	self
		assertCollection:
		(diagramControllerOfCopy controllers collect: #model)
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

{ #category : 'tests - ui interaction' }
OPAbstractElementControllerTest >> testBeingRemovedAfterModelRemovalWhenNotRendered [

	| diagram diagramElement newDiagramControllerBlock diagramControllerOfCopy controllerOfCopy recreatedDiagramController |
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	self assert: diagramElement isRendered.
	diagramController removeController.
	self
		assertCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self deny: diagramElement isRendered.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	newDiagramControllerBlock := [ :copyOfDiagram |
	                             | newDiagramController |
	                             newDiagramController := self
		                                                     diagramControllerClass
		                                                     new.
	                             newDiagramController model:
		                             diagramController model.
	                             newDiagramController diagramElement:
		                             copyOfDiagram.
	                             newDiagramController canvasPresenter:
		                             (OPCanvasPresenter new
			                              canvas: RSCanvas new;
			                              yourself).
	                             newDiagramController diagramFocused.
	                             newDiagramController ].


	self
		shouldnt: [
			diagramControllerOfCopy := newDiagramControllerBlock value:
				                           diagram newCopy ]
		raise: OPInvalidWarning.
	controllerOfCopy := diagramControllerOfCopy controllerForModel: model.
	controllerOfCopy removeModel.
	recreatedDiagramController := newDiagramControllerBlock value:
		                              diagram.
	recreatedDiagramController validate.
	self
		denyCollection: diagram allOwnedElements
		includesAll: { diagramElement }.
	self deny: diagramElement isRendered.
	self
		denyCollection: recreatedDiagramController controllers
		includesAll: { controller }
]

{ #category : 'tests - ui interaction' }
OPAbstractElementControllerTest >> testBeingRemovedAfterModelRemovalWhenRendered [

	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self showInDiagram.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	controller removeModel.
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
	model stub name willReturn: 'bravo'.
	diagramElement := Mock new.
	controller model: model.
	controller diagramElement: diagramElement.
	controller diagramController: diagramController.
	controller descriptionName accessor write: 'charlie' to: controller.
	model should receive name: 'charlie'.
	self
		assert: (controller descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
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
		assert: (diagramController modelForFigure: controller roassalShape)
		equals: self model
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
	form := OPDynamicForm new.
	diagramController stub form willReturn: form.
	self assert: form layout children isEmpty.
	diagramController openInForm: controller.
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
	controller removeModel.
	self denyCollection: self allElements includesAll: { model }
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
