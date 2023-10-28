Class {
	#name : #OPEdge,
	#superclass : #OPShape,
	#instVars : [
		'source',
		'target',
		'waypoints'
	],
	#category : #'OpenPonk-Core-Shapes'
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

{ #category : #'ston-core' }
OPEdge class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #source #target #waypoints )
]

{ #category : #accessing }
OPEdge >> innerWaypoints [

	^ waypoints copyFrom: 2 to: waypoints size - 1
]

{ #category : #accessing }
OPEdge >> innerWaypoints: aCollection [

	self isRendered ifTrue: [
		self waypoints:
			{ self roassalShape controlPoints first } , aCollection
			, { self roassalShape controlPoints last } ]
]

{ #category : #removing }
OPEdge >> remove [

	super remove.
	self source: nil.
	self target: nil
]

{ #category : #rendering }
OPEdge >> selectableInteraction [

	^ OPRSSelectable highlightColorBlue
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

{ #category : #'as yet unclassified' }
OPEdge >> updateFromRender [

	self waypoints: roassalShape controlPoints.
	super updateFromRender
]

{ #category : #'as yet unclassified' }
OPEdge >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	waypoints ifNotNil: [
		roassalShape innerControlPoints: self innerWaypoints.
		roassalShape to announce: (RSPositionChangedEvent new
				 oldPosition: roassalShape to position;
				 newPosition: roassalShape to position;
				 yourself).
		roassalShape update ].
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
