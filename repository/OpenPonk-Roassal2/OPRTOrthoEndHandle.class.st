"
I am a non-draggable handle at the end points of an orthogonal connection. I primarily manage creation of new polyline segments.
"
Class {
	#name : #OPRTOrthoEndHandle,
	#superclass : #OPRTOrthoHandle,
	#instVars : [
		'endElement'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #'instance creation' }
OPRTOrthoEndHandle class >> endElement: anElement positionLink: aLink edge: anEdge [
	^ self new
		endElement: anElement;
		positionLink: aLink;
		edge: anEdge;
		yourself
]

{ #category : #accessing }
OPRTOrthoEndHandle >> endElement: anElement [
	endElement := anElement.
	endElement addCallback: (TRTranslationCallback block: [ :e :step | self movedBy: step ])
]

{ #category : #testing }
OPRTOrthoEndHandle >> isEnd [
	^ true
]

{ #category : #testing }
OPRTOrthoEndHandle >> isInsideEndElement: aPosition [
	"containsPoint: is not used, because it uses strict comparison (so the element can't be on the border of the rectangle"

	| rect |
	rect := endElement encompassingRectangle.
	^ rect origin <= aPosition and: [ aPosition <= rect corner ]
]

{ #category : #positioning }
OPRTOrthoEndHandle >> moveBy: aVector from: aNeighbor [
	| targetPosition |
	targetPosition := self position + aVector.
	(self isInsideEndElement: targetPosition)
		ifTrue: [ ^ self basicMoveBy: aVector ].
	self
		basicMoveTo:
			((RTLineSegment from: self position to: targetPosition)
				intersectRectangle: endElement encompassingRectangle) anyOne.
	self newCornerAt: targetPosition
]

{ #category : #'as yet unclassified' }
OPRTOrthoEndHandle >> moveToBorder: aLine [
	(aLine intersectRectangle: endElement encompassingRectangle)
		ifNotEmpty: [ :set | self basicMoveTo: set anyOne ]
]

{ #category : #'as yet unclassified' }
OPRTOrthoEndHandle >> movedBy: aVector [
	self basicMoveBy: aVector.
	self hasPredecessor
		ifTrue: [ self previous
				moveBy: (self constraintVector: aVector for: self previous)
				from: self ].
	self hasSuccessor
		ifTrue: [ self next moveBy: (self constraintVector: aVector for: self next) from: self ]
]

{ #category : #'as yet unclassified' }
OPRTOrthoEndHandle >> newCornerAt: aPosition [
	| cornerPosition corner |
	cornerPosition := DoubleLink value: aPosition.
	corner := OPRTOrthoCornerHandle positionLink: cornerPosition edge: edge.
	self hasSuccessor
		ifTrue: [ positionLink addSuccessor: cornerPosition.
			self addSuccessor: corner ]
		ifFalse: [ positionLink addPredecessor: cornerPosition.
			self addPredecessor: corner ].
	element ifNotNil: [ corner renderIn: edge view ].
	edge update.
	edge signalUpdate
]

{ #category : #'as yet unclassified' }
OPRTOrthoEndHandle >> removeIfNeeded: aCorner [
	(self isInsideEndElement: aCorner position)
		ifTrue: [ self removeNeighborCorner ]
]

{ #category : #'as yet unclassified' }
OPRTOrthoEndHandle >> removeNeighborCorner [
	self hasSuccessor
		ifTrue:
			[ self
				moveToBorder: (RTLineSegment from: self nextLink position to: self nextLink nextLink position).
			self nextLink remove ]
		ifFalse:
			[ self
				moveToBorder: (RTLineSegment from: self previousLink position to: self previousLink previousLink position).
			self previousLink remove ]
]
