Class {
	#name : #OPRTBendHandle,
	#superclass : #OPRTHandle,
	#instVars : [
		'index',
		'pointLink'
	],
	#category : #'OpenPonk-Roassal2-Connection'
}

{ #category : #'as yet unclassified' }
OPRTBendHandle >> on: anEdge at: aPointLink [
	edge := anEdge.
	pointLink := aPointLink
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> onDragEnd [

	| previous next current |
	"remove the point if the angle between the two adjacent lines is near Pi"
	current := pointLink value.
	previous := pointLink hasPredecessor
		            ifTrue: [ pointLink previousLink value ]
		            ifFalse: [ edge from position ].
	next := pointLink hasSuccessor
		        ifTrue: [ pointLink nextLink value ]
		        ifFalse: [ edge to position ].
	(current onLineFrom: previous to: next within: 10) ifTrue: [ 
		^ self removePoint ].
	element pushFront
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> pointLink [
	^ pointLink
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> remove [

	self removeConnectedEdges.
	super remove.
	pointLink := nil
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	element connectedEdges removeAll
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> removePoint [
	"destroy the handle and the underlying point"

	edge shape router removePointLink: pointLink for: edge
]

{ #category : #accessing }
OPRTBendHandle >> renderIn: aView [

	element := self shape elementOn: edge.
	clickBox := self clickBoxShape elementOn: edge.
	aView
		add: element;
		add: clickBox.
	clickBox translateTo: pointLink value.
	(RTConstraint on: element background: clickBox) stick.
	clickBox @ OPRTDraggableSnapToGrid center.
	element addConnectedEdge: edge.
	element @ (RTMenuActivable new
		 item: 'Remove' action: [ :e | self removePoint ];
		 item: 'Straighten' action: [ :e | self straightenConnection ]).
	element trachelShape addCallback:
		(TRTranslationCallback block: [ :shape :step | 
			 pointLink value: pointLink value + step.
			 edge announcer announce: OPRTHandleMoved new ]).
	clickBox when: TRMouseDragEnd do: [ self onDragEnd ]
]

{ #category : #accessing }
OPRTBendHandle >> size [

	^ 9
]

{ #category : #'as yet unclassified' }
OPRTBendHandle >> straightenConnection [
	"Remove all the handles of the connection"

	edge shape router removeAll
]
