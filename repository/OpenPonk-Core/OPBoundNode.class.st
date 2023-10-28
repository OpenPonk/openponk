Class {
	#name : #OPBoundNode,
	#superclass : #OPNode,
	#instVars : [
		'bounds'
	],
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #'ston-core' }
OPBoundNode class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #bounds )
]

{ #category : #'as yet unclassified' }
OPBoundNode >> allOwnedShapesPositionableByUser [

	self isRendered ifFalse: [ ^ #(  ) ].
	self isPositionableByUser ifFalse: [ 
		^ super allOwnedShapesPositionableByUser ].
	^ { self } , super allOwnedShapesPositionableByUser
]

{ #category : #accessing }
OPBoundNode >> bounds [

	^ bounds
]

{ #category : #accessing }
OPBoundNode >> bounds: anObject [

	bounds := anObject
]

{ #category : #accessing }
OPBoundNode >> extent [

	^ (roassalShape ifNil: [ self bounds ]) extent
]

{ #category : #'as yet unclassified' }
OPBoundNode >> isResizableByUser [

	^ true
]

{ #category : #'as yet unclassified' }
OPBoundNode >> moveToEmptySpace [

	| spacing neededSpace canvasRectangle possibleCanvas occupiedRectangles |
	spacing := 30 @ 30.
	neededSpace := self extent rounded + (spacing * 2).
	canvasRectangle := self canvas encompassingRectangle rounded.
	possibleCanvas := Rectangle
		                  origin: canvasRectangle origin - spacing
		                  corner: canvasRectangle corner
			                  +
			                  ((800 - canvasRectangle width max: 0)
			                   @ neededSpace y).
	occupiedRectangles := SortedCollection sortBlock: [ :a :b |
		                      a right > b right ].
	occupiedRectangles add:
		(possibleCanvas topLeft corner: possibleCanvas bottomLeft).
	occupiedRectangles addAll:
		((self allShapesPositionableByUser copyWithout: self) collect: [
			 :each | each encompassingRectangle rounded ]).

	occupiedRectangles
		inject: possibleCanvas top
		into: [ :maxFoundOccupiedY :each |
			| filledSpace |
			filledSpace := Rectangle
				               origin: each right @ maxFoundOccupiedY
				               extent: neededSpace.
			(filledSpace corner <= possibleCanvas corner and: [
				 each bottom > maxFoundOccupiedY ]) ifTrue: [
				^ self translateTo: filledSpace center ].
			maxFoundOccupiedY max: each bottom ]
]

{ #category : #accessing }
OPBoundNode >> position [

	^ (roassalShape ifNil: [ self bounds ]) position
]

{ #category : #rendering }
OPBoundNode >> renderIn: aCanvas [

	self isRendered ifTrue: [ ^ self ].
	super renderIn: aCanvas.
	self bounds ifNil: [
		self movesWithOtherShape ifFalse: [ self moveToEmptySpace ] ].
	^ roassalShape
]

{ #category : #'as yet unclassified' }
OPBoundNode >> updateFromRender [

	self isResizableByUser | self isPositionableByUser ifTrue: [
		self bounds: (OPNodeBounds new
				 position: roassalShape position
				 extent: roassalShape extent) ].
	super updateFromRender
]

{ #category : #roassal }
OPBoundNode >> updateRenderFromBounds [

	bounds ifNil: [ ^ self ].
	self isResizableByUser ifTrue: [ roassalShape extent: bounds extent ].
	self isPositionableByUser ifTrue: [
		roassalShape translateTo: bounds position ]
]

{ #category : #roassal }
OPBoundNode >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self updateRenderFromBounds.
	super updateRenderFromSelf
]
