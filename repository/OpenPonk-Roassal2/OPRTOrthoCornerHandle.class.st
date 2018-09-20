"
I am a draggable handle manager for the corners of an orthogonal handle.
"
Class {
	#name : #OPRTOrthoCornerHandle,
	#superclass : #OPRTOrthoHandle,
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #'instance creation' }
OPRTOrthoCornerHandle class >> positionLink: aLink edge: anEdge [
	^ self new
		positionLink: aLink;
		edge: anEdge;
		yourself
]

{ #category : #positioning }
OPRTOrthoCornerHandle >> moveBy: aVector from: aNeighbor [
	self basicMoveBy: aVector.
	aNeighbor position = self position
		ifTrue: [ self remove.
			^ self removeIfNecessary: aNeighbor ].
	self removeIfNecessary
]

{ #category : #positioning }
OPRTOrthoCornerHandle >> movedBy: aVector [
	positionLink value: positionLink value + aVector.
	self previous
		ifNotNil: [ :n | n moveBy: (self constraintVector: aVector for: n) from: self ].
	self next
		ifNotNil: [ :n | n moveBy: (self constraintVector: aVector for: n) from: self ].
	self removeIfNecessary
]

{ #category : #removing }
OPRTOrthoCornerHandle >> remove [
	self removeHandle.
	positionLink removeLink.
	self removeLink.
	edge update.
	edge signalUpdate
]

{ #category : #removing }
OPRTOrthoCornerHandle >> removeIfNecessary [
	(self hasPredecessor and: [ self previous isEnd ])
		ifTrue: [ self previous removeIfNeeded: self ].
	(self hasSuccessor and: [ self next isEnd ])
		ifTrue: [ self next removeIfNeeded: self ]
]

{ #category : #removing }
OPRTOrthoCornerHandle >> removeIfNecessary: aHandle [
	(aHandle isEnd not
		and: [ aHandle position onLineFrom: aHandle previous position to: aHandle next position ])
		ifTrue: [ aHandle remove ]
]

{ #category : #rendering }
OPRTOrthoCornerHandle >> renderIn: aView [
	super renderIn: aView.
	element @ OPRTRoundedDraggable.
	element addCallback: (TRTranslationCallback block: [ :aShape :step | self movedBy: step ])
]
