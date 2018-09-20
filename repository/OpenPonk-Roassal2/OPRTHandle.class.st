"
I am a handle for DCRTConnection.
"
Class {
	#name : #OPRTHandle,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'edge',
		'index',
		'element',
		'pointLink'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #accessing }
OPRTHandle >> element [
	^ element
]

{ #category : #'as yet unclassified' }
OPRTHandle >> on: anEdge at: aPointLink [
	edge := anEdge.
	pointLink := aPointLink
]

{ #category : #'as yet unclassified' }
OPRTHandle >> onDragEnd [
	| previous next current |
	"remove the point if the angle between the two adjacent lines is near Pi"
	current := pointLink value.
	previous := pointLink hasPredecessor
		ifTrue: [ pointLink previousLink value ]
		ifFalse: [ edge from position ].
	next := pointLink hasSuccessor
		ifTrue: [ pointLink nextLink value ]
		ifFalse: [ edge to position ].
	(current onLineFrom: previous to: next within: 10)
		ifTrue: [ self removePoint ]
]

{ #category : #'as yet unclassified' }
OPRTHandle >> pointLink [
	^ pointLink
]

{ #category : #'as yet unclassified' }
OPRTHandle >> remove [
	self removeConnectedEdges.
	element remove.
	element := nil.
	edge := nil.
	pointLink := nil
]

{ #category : #'as yet unclassified' }
OPRTHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	element connectedEdges removeAll
]

{ #category : #'as yet unclassified' }
OPRTHandle >> removePoint [
	"destroy the handle and the underlying point"

	edge shape router removePointLink: pointLink for: edge
]

{ #category : #accessing }
OPRTHandle >> renderIn: aView [
	element := self shape elementOn: edge.
	aView add: element.
	element translateTo: pointLink value.
	element @ RTDraggableSnapToGrid center.
	"element @ DCRTRoundedDraggable."
	element addConnectedEdge: edge.
	element
		@
			(RTMenuActivable new
				item: 'Remove' action: [ :e | self removePoint ];
				item: 'Straighten' action: [ :e | self straightenConnection ]).
	element trachelShape
		addCallback:
			(TRTranslationCallback
				block: [ :shape :step | 
					pointLink value: pointLink value + step.
					edge announcer announce: OPRTHandleMoved new ]).
	element when: TRMouseDragEnd do: [ self onDragEnd ]
]

{ #category : #accessing }
OPRTHandle >> shape [
	^ RTEllipse new
		size: 9;
		color: [ :e | e shape colorFor: e ];
		borderColor: Color black;
		yourself
]

{ #category : #'as yet unclassified' }
OPRTHandle >> straightenConnection [
	"Remove all the handles of the connection"

	edge shape router removeAll
]
