Class {
	#name : #OPEdgeCreationTargetController,
	#superclass : #Object,
	#instVars : [
		'edgeController',
		'diagramElement'
	],
	#category : #'OpenPonk-Spec'
}

{ #category : #rendering }
OPEdgeCreationTargetController class >> renderForEdgeController: aController [

	^ self new
		  edgeController: aController;
		  render;
		  yourself
]

{ #category : #accessing }
OPEdgeCreationTargetController >> diagramElement [

	^ diagramElement
]

{ #category : #accessing }
OPEdgeCreationTargetController >> edgeController: aController [

	edgeController := aController
]

{ #category : #accessing }
OPEdgeCreationTargetController >> remove [

	diagramElement ifNil: [ ^ self ].
	edgeController target = self ifTrue: [ 
		edgeController target: nil.
		edgeController removeDiagramElement ].
	diagramElement remove.
	diagramElement := nil
]

{ #category : #hooks }
OPEdgeCreationTargetController >> render [

	diagramElement := OPNoShape
		                  renderToPosition:
		                  edgeController source roassalShape position
		                  onCanvas:
		                  edgeController source diagramController canvas.

	edgeController target: self.
	edgeController
		diagramController: edgeController source diagramController;
		renderSimplified
]
