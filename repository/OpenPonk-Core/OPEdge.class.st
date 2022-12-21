Class {
	#name : #OPEdge,
	#superclass : #OPDiagramElement,
	#instVars : [
		'source',
		'target',
		'waypoints'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPEdge class >> renderForController: aController [

	^ self new
		  modelElement: aController model;
		  source: aController source diagramElement;
		  target: aController target diagramElement;
		  renderIn: aController diagramController canvas;
		  yourself
]

{ #category : #rendering }
OPEdge class >> renderSimplifiedForController: aController [

	^ self new
		  modelElement: aController model;
		  source: aController source diagramElement;
		  target: aController target diagramElement;
		  renderBasicShapeIn: aController diagramController canvas;
		  yourself
]

{ #category : #deprecated }
OPEdge >> from [

	self
		deprecated: 'Use #source'
		transformWith: '`@receiver from' -> '`@receiver source'.
	^ self source
]

{ #category : #removing }
OPEdge >> remove [

	super remove.
	self source: nil.
	self target: nil
]

{ #category : #accessing }
OPEdge >> source [

	^ source
]

{ #category : #accessing }
OPEdge >> source: anElement [

	source := SRToOneLink
		          on: self
		          slot: #source
		          oppositeSlot: #sourceEdges
		          updateFrom: source
		          to: anElement
]

{ #category : #accessing }
OPEdge >> target [

	^ target
]

{ #category : #accessing }
OPEdge >> target: anElement [

	target := SRToOneLink
		          on: self
		          slot: #target
		          oppositeSlot: #targetEdges
		          updateFrom: target
		          to: anElement
]

{ #category : #deprecated }
OPEdge >> to [

	self
		deprecated: 'Use #target'
		transformWith: '`@receiver to' -> '`@receiver target'.
	^ self target
]

{ #category : #'as yet unclassified' }
OPEdge >> updateFromRender [

	self waypoints: roassalShape controlPoints.
	super updateFromRender
]

{ #category : #'as yet unclassified' }
OPEdge >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	waypoints ifNotNil: [ roassalShape controlPoints: waypoints ].
	super updateRenderFromSelf
]

{ #category : #accessing }
OPEdge >> waypoints [

	^ waypoints
]

{ #category : #accessing }
OPEdge >> waypoints: anObject [

	waypoints := anObject
]
