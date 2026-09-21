"
Reversible command that coordinates the atomic removal and restoration of a domain model element, its ViewModel registration, its peer relationships, and its diagram elements across diagrams.
"
Class {
	#name : 'OPRemoveModelElementCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'model',
		'projectController',
		'viewModel',
		'parentModel',
		'diagramElementDescriptors',
		'associatedDiagrams',
		'sourceModel',
		'targetModel'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPRemoveModelElementCommand class >> model: aModel diagramController: aDiagramController [
	^ self new
		setModel: aModel
		projectController: aDiagramController projectController;
		yourself
]

{ #category : 'instance creation' }
OPRemoveModelElementCommand class >> model: aModel projectController: aProjectController [
	^ self new
		setModel: aModel
		projectController: aProjectController;
		yourself
]

{ #category : 'instance creation' }
OPRemoveModelElementCommand class >> model: aModel projectController: aProjectController activeControllers: aCollection [

	| resolvedProjectController |
	resolvedProjectController := aCollection
		                             detect: [ :eachController | eachController projectController isNotNil ]
		                             ifFound: [ :foundController | foundController projectController ]
		                             ifNone: [ nil ].
	^ self model: aModel projectController: resolvedProjectController
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> availableDiagrams [
	| diagrams |
	diagrams := Set new.
	self project ifNotNil: [ :currentProject |
		diagrams addAll: currentProject diagrams ].
	projectController ifNotNil: [ :currentProjectController |
		currentProjectController controllers do: [ :eachDiagramController |
			eachDiagramController diagramElement ifNotNil: [ :diagramElement |
				diagrams add: diagramElement ] ] ].
	^ diagrams
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> captureDiagramElements [
	self availableDiagrams do: [ :eachDiagram |
		| matchingElements |
		matchingElements := eachDiagram allOwnedElements select: [ :eachDiagramElement |
			eachDiagramElement modelElements includes: model ].
		matchingElements do: [ :eachDiagramElement |
			diagramElementDescriptors add: (OPDiagramElementRemovalDescriptor new
				diagram: eachDiagram;
				captureFrom: eachDiagramElement;
				yourself) ] ]
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> captureDiagrams [
	associatedDiagrams := OrderedCollection new.
	self project ifNotNil: [ :project |
		associatedDiagrams addAll: (project diagramsOf: model) ]
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> captureRelationEndpoints [
	sourceModel := viewModel modelSource.
	targetModel := viewModel modelTarget
]

{ #category : 'private' }
OPRemoveModelElementCommand >> captureState [

	viewModel := self viewModelRegistry viewModelFor: model.
	parentModel := viewModel parentContainerModel.
	self captureRelationEndpoints.
	self captureDiagramElements.
	self captureDiagrams
]

{ #category : 'testing' }
OPRemoveModelElementCommand >> diagramElementDescriptors [
	^ diagramElementDescriptors
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> execute [

	viewModel ifNil: [ ^ self ].

	"1. Cascade remove dependent elements within transaction."
	viewModel dependentElements asSet do: [ :dependentModel |
			(self isModelPresent: dependentModel) ifTrue: [
					| dependentCommand |
					dependentCommand := self class model: dependentModel projectController: projectController.
					self undoManager execute: dependentCommand ] ].

	"2. Detach visual elements from closed diagrams."
	diagramElementDescriptors do: [ :descriptor | descriptor diagram isRendered ifFalse: [ descriptor diagramElement remove ] ].

	"3. Remove all associated diagrams of the model from the project."
	self project ifNotNil: [ :currentProject |
			associatedDiagrams do: [ :diagram |
					currentProject removeDiagram: diagram.
					currentProject announcer announce: (OPDiagramRemoved diagram: diagram) ] ].

	"4. Perform domain removal and announce."
	viewModel basicRemoveModel.
	viewModel unsubscribeFromModel.
	viewModel unregisterFromRegistry.
	viewModel announceRemoval.
	self project ifNotNil: [ :currentProject | currentProject announcer announce: (OPModelRemoved model: model) ]
]

{ #category : 'initialization' }
OPRemoveModelElementCommand >> initialize [
	super initialize.
	diagramElementDescriptors := OrderedCollection new
]

{ #category : 'testing' }
OPRemoveModelElementCommand >> isModelPresent: aModelObject [

	^ self viewModelRegistry hasViewModelFor: aModelObject
]

{ #category : 'accessing' }
OPRemoveModelElementCommand >> project [

	^ projectController project
]

{ #category : 'accessing' }
OPRemoveModelElementCommand >> projectController [

	^ projectController
]

{ #category : 'accessing' }
OPRemoveModelElementCommand >> projectController: aProjectController [

	projectController := aProjectController
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> reRenderInActiveDiagrams [
	projectController ifNotNil: [ :currentProjectController |
		currentProjectController controllers do: [ :openDiagramController |
			(diagramElementDescriptors select: [ :descriptor | descriptor diagram == openDiagramController diagramElement ]) do: [ :descriptor |
				openDiagramController showDiagramElement: descriptor diagramElement ] ] ]
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> redo [
	self execute
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> restoreDiagramElements [
	diagramElementDescriptors do: [ :eachDescriptor |
		eachDescriptor restoreDiagramElement ]
]

{ #category : 'executing' }
OPRemoveModelElementCommand >> restoreRelationEndpoints [
	viewModel restoreEndpointsWithSource: sourceModel target: targetModel
]

{ #category : 'initialization' }
OPRemoveModelElementCommand >> setModel: aModel projectController: aProjectController [

	model := aModel.
	projectController := aProjectController.
	self captureState
]

{ #category : 'undo/redo' }
OPRemoveModelElementCommand >> undo [
	self undoModel.
	self undoDiagram
]

{ #category : 'undo/redo' }
OPRemoveModelElementCommand >> undoDiagram [
	self reRenderInActiveDiagrams
]

{ #category : 'accessing' }
OPRemoveModelElementCommand >> undoManager [

	^ self projectController undoManager
]

{ #category : 'undo/redo' }
OPRemoveModelElementCommand >> undoModel [
	"1. Restore model to registry and parent container"

	self viewModelRegistry registerViewModel: viewModel for: model.
	viewModel subscribeToModel.

	parentModel ifNotNil: [ viewModel registerModelIn: parentModel ].

	self project ifNotNil: [ :project | project announcer announce: (OPModelAdded model: model) ].

	"2. Restore associated diagrams back into the project"
	self project ifNotNil: [ :project |
			associatedDiagrams do: [ :diagram |
					project addDiagram: diagram.
					project announcer announce: (OPDiagramAdded diagram: diagram) ] ].

	"3. Restore visual links and shapes metadata"
	self restoreRelationEndpoints.
	self restoreDiagramElements
]

{ #category : 'accessing' }
OPRemoveModelElementCommand >> viewModelRegistry [

	^ self projectController viewModelRegistry
]
