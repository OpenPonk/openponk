Class {
	#name : 'OPEdgeCreationTargetController',
	#superclass : 'Object',
	#instVars : [
		'edgeController',
		'diagramElement'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'rendering' }
OPEdgeCreationTargetController class >> renderForEdgeController: aController [

	^ self new
		  edgeController: aController;
		  render;
		  yourself
]

{ #category : 'accessing' }
OPEdgeCreationTargetController >> diagramElement [

	^ diagramElement
]

{ #category : 'accessing' }
OPEdgeCreationTargetController >> edgeController: aController [

	edgeController := aController
]

{ #category : 'accessing' }
OPEdgeCreationTargetController >> remove [

	diagramElement ifNil: [ ^ self ].

	edgeController diagramController roassalShape removeKey:
		#ignoredElementsForEvents.

	edgeController target = self ifTrue: [
		edgeController target: nil.
		edgeController removeDiagramElement ].
	diagramElement remove.
	diagramElement := nil
]

{ #category : 'hooks' }
OPEdgeCreationTargetController >> render [

	diagramElement := OPInvisibleOnMouseShape
		                  renderToPosition:
		                  edgeController source roassalShape position
		                  onCanvas:
		                  edgeController source diagramController canvas.

	edgeController target: self.
	edgeController
		diagramController: edgeController source diagramController;
		renderSimplified.

	edgeController diagramController roassalShape
		propertyAt: #ignoredElementsForEvents
		put: (Set
				 with: diagramElement roassalShape
				 with: edgeController roassalShape)
]
