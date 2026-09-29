"
Command representing the creation of a node element within a domain container and a diagram.
Preserves domain and diagram element identities across Undo/Redo cycles without holding transient UI element controller references.
"
Class {
	#name : 'OPCreateNodeCommand',
	#superclass : 'OPCreateElementCommand',
	#instVars : [
		'position'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPCreateNodeCommand class >> controller: aController parentModel: aParentModel diagramController: aDiagramController [
	^ self
		controller: aController
		parentModel: aParentModel
		diagramController: aDiagramController
		position: nil
]

{ #category : 'instance creation' }
OPCreateNodeCommand class >> controller: aController parentModel: aParentModel diagramController: aDiagramController position: aPoint [
	^ self new
		controller: aController;
		parentModel: aParentModel;
		diagramController: aDiagramController;
		diagram: aDiagramController diagramElement;
		position: aPoint;
		yourself
]

{ #category : 'instance creation' }
OPCreateNodeCommand class >> controllerClass: aControllerClass parentModel: aParentModel diagramController: aDiagramController position: aPoint [
	^ self
		controller: aControllerClass new
		parentModel: aParentModel
		diagramController: aDiagramController
		position: aPoint
]

{ #category : 'executing' }
OPCreateNodeCommand >> completeFirstExecution [

	| extent |
	position ifNil: [ ^ self ].
	extent := (diagramElement bounds ifNil: [ diagramElement roassalShape ] ifNotNil: [ :bounds | bounds ]) extent.
	diagramElement bounds: (OPNodeBounds withPosition: position extent: extent).
	diagramElement updateRenderFromSelf
]

{ #category : 'accessing' }
OPCreateNodeCommand >> position [
	^ position
]

{ #category : 'accessing' }
OPCreateNodeCommand >> position: aPoint [
	position := aPoint
]

{ #category : 'executing' }
OPCreateNodeCommand >> restoreDiagramElementGeometry [

	| extent |
	position ifNil: [ ^ self ].
	extent := (diagramElement bounds ifNil: [ diagramElement roassalShape ] ifNotNil: [ :bounds | bounds ]) extent.
	diagramElement bounds: (OPNodeBounds withPosition: position extent: extent)
]
