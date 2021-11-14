"
I am a pseudo handle between two real handles. When dragged I am promoted to a real DCRTHandle.
"
Class {
	#name : #OPRTMidpointHandle,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'element',
		'edge',
		'nearStart',
		'nearEnd'
	],
	#category : #'OpenPonk-Roassal2-Connection'
}

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> beNearEnd [
	nearEnd := true
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> beNearStart [
	nearStart := true
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> constraintFor: anElement [

	| moveBlock b callback |
	moveBlock := [ 
	             anElement translateTo: self fromPoint + self toPoint / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> element [
	^ element
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> from [
	^ from
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> fromPoint [

	^ nearStart
		  ifTrue: [ edge shape attachPoint startingPointOf: edge ]
		  ifFalse: [ from position ]
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> initialize [
	super initialize.
	nearStart := nearEnd := false
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> on: anEdge between: fromElement and: toElement [
	edge := anEdge.
	from := fromElement.
	to := toElement
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> promote [
	edge shape router handler promoteFor: edge handle: self
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> remove [
	element remove
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> renderIn: aView [

	element := self shape elementOn: edge trachelShape.
	element @ (OPRTConditionallyDraggable onCondition: [ 
		 (self fromPoint distanceTo: self toPoint) > 10 ]).
	self constraintFor: element.
	element when: TRMouseDragStart do: [ :event | 
		(self fromPoint distanceTo: self toPoint) > 10 ifTrue: [ 
			self promote ] ].
	aView add: element
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> shape [
	^ RTEllipse new
		size: 6;
		color: #color;
		borderColor: Color black;
		yourself
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> to [
	^ to
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> toPoint [

	^ nearEnd
		  ifTrue: [ edge shape attachPoint endingPointOf: edge ]
		  ifFalse: [ to position ]
]
