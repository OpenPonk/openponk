"
I am an abstract command managing the visual visibility (show/hide) of domain models in a diagram without modifying domain semantics.
"
Class {
	#name : 'OPDiagramElementVisibilityCommand',
	#superclass : 'OPDiagramCommand',
	#instVars : [
		'descriptors'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPDiagramElementVisibilityCommand class >> model: aModel diagramController: aDiagramController [
	^ self new
		setModel: aModel diagramController: aDiagramController;
		yourself
]

{ #category : 'factory' }
OPDiagramElementVisibilityCommand >> createDescriptorFor: aDiagramElement [

	^ OPDiagramElementRemovalDescriptor new
		captureFrom: aDiagramElement;
		yourself
]

{ #category : 'accessing' }
OPDiagramElementVisibilityCommand >> diagramController [
	"Answer the currently active diagram controller dynamically to prevent memory leaks in history."
	^ self openDiagramController
]

{ #category : 'execution' }
OPDiagramElementVisibilityCommand >> reRenderInDiagram [
	self openDiagramController ifNotNil: [ :openDiagramController |
		(descriptors reject: [ :eachDescriptor | eachDescriptor diagramElement isEdge ]) do: [ :eachDescriptor |
			openDiagramController showDiagramElement: eachDescriptor diagramElement ].
		(descriptors select: [ :eachDescriptor | eachDescriptor diagramElement isEdge ]) do: [ :eachDescriptor |
			openDiagramController showDiagramElement: eachDescriptor diagramElement ].
		openDiagramController updateCanvas ]
]

{ #category : 'executing' }
OPDiagramElementVisibilityCommand >> redo [
	self execute
]

{ #category : 'executing' }
OPDiagramElementVisibilityCommand >> restoreDiagramElement: aDescriptor [
	aDescriptor restoreDiagramElement
]

{ #category : 'executing' }
OPDiagramElementVisibilityCommand >> restoreDiagramElements [
	(descriptors reject: [ :eachDescriptor | eachDescriptor diagramElement isEdge ]) do: [ :eachDescriptor |
		self restoreDiagramElement: eachDescriptor ].
	(descriptors select: [ :eachDescriptor | eachDescriptor diagramElement isEdge ]) do: [ :eachDescriptor |
		self restoreDiagramElement: eachDescriptor ]
]

{ #category : 'initialization' }
OPDiagramElementVisibilityCommand >> setModel: aModel diagramController: aDiagramController [
	model := aModel.
	diagram := aDiagramController diagramElement.
	projectController := aDiagramController projectController.
	descriptors := OrderedCollection new
]
