"
Command representing the creation of a directional relationship (edge) between two diagram elements.
Preserves domain relationship lifecycle and visual link attachment across Undo/Redo cycles without holding transient UI element controller references across history.
"
Class {
	#name : 'OPCreateEdgeCommand',
	#superclass : 'OPCreateElementCommand',
	#instVars : [
		'sourceDiagramElement',
		'sourceModel',
		'targetDiagramElement',
		'targetModel'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPCreateEdgeCommand class >> controller: aController source: aSource target: aTarget parentModel: aParentModel diagramController: aDiagramController [
	^ self new
		controller: aController;
		sourceModel: aSource model;
		targetModel: aTarget model;
		sourceDiagramElement: aSource diagramElement;
		targetDiagramElement: aTarget diagramElement;
		parentModel: aParentModel;
		diagramController: aDiagramController;
		diagram: aDiagramController diagramElement;
		yourself
]

{ #category : 'instance creation' }
OPCreateEdgeCommand class >> controllerClass: aControllerClass source: aSource target: aTarget parentModel: aParentModel diagramController: aDiagramController [
	^ self
		controller: aControllerClass new
		source: aSource
		target: aTarget
		parentModel: aParentModel
		diagramController: aDiagramController
]

{ #category : 'executing' }
OPCreateEdgeCommand >> completeFirstExecution [
	diagramElement ifNotNil: [
		sourceDiagramElement := diagramElement source.
		targetDiagramElement := diagramElement target ]
]

{ #category : 'executing' }
OPCreateEdgeCommand >> prepareControllerBeforeCreation [
	controller source ifNil: [
		controller source: (diagramController controllerForModel: sourceModel) ].
	controller target ifNil: [
		controller target: (diagramController controllerForModel: targetModel) ]
]

{ #category : 'executing' }
OPCreateEdgeCommand >> redoDomainModel [

	| sourceViewModel targetViewModel |
	super redoDomainModel.
	sourceModel ifNil: [ ^ self ].
	targetModel ifNil: [ ^ self ].
	sourceViewModel := self viewModelRegistry viewModelFor: sourceModel.
	targetViewModel := self viewModelRegistry viewModelFor: targetModel.
	viewModel attachModelFrom: sourceViewModel to: targetViewModel
]

{ #category : 'executing' }
OPCreateEdgeCommand >> restoreDiagramElementGeometry [
	diagramElement source: sourceDiagramElement.
	diagramElement target: targetDiagramElement
]

{ #category : 'accessing' }
OPCreateEdgeCommand >> sourceDiagramElement: aDiagramElement [
	sourceDiagramElement := aDiagramElement
]

{ #category : 'accessing' }
OPCreateEdgeCommand >> sourceModel: aModel [
	sourceModel := aModel
]

{ #category : 'accessing' }
OPCreateEdgeCommand >> targetDiagramElement: aDiagramElement [
	targetDiagramElement := aDiagramElement
]

{ #category : 'accessing' }
OPCreateEdgeCommand >> targetModel: aModel [
	targetModel := aModel
]

{ #category : 'executing' }
OPCreateEdgeCommand >> undoDiagramElement [
	super undoDiagramElement.
	diagramElement source: nil.
	diagramElement target: nil
]
