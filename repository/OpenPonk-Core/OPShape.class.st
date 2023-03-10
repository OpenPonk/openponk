Class {
	#name : #OPShape,
	#superclass : #OPNode,
	#instVars : [
		'bounds'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'ston-core' }
OPShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #bounds )
]

{ #category : #'as yet unclassified' }
OPShape >> allOwnedShapesPositionableByUser [

	self isRendered ifFalse: [ ^ #(  ) ].
	self isPositionableByUser ifFalse: [ 
		^ super allOwnedShapesPositionableByUser ].
	^ { self } , super allOwnedShapesPositionableByUser
]

{ #category : #accessing }
OPShape >> bounds [

	^ bounds
]

{ #category : #accessing }
OPShape >> bounds: anObject [

	bounds := anObject
]

{ #category : #accessing }
OPShape >> extent [

	^ (roassalShape ifNil: [ self bounds ]) extent
]

{ #category : #'as yet unclassified' }
OPShape >> moveToEmptySpace [

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
OPShape >> position [

	^ (roassalShape ifNil: [ self bounds ]) position
]

{ #category : #rendering }
OPShape >> renderIn: aCanvas [

	self isRendered ifTrue: [ ^ self ].
	super renderIn: aCanvas.
	self bounds ifNil: [ 
		self isPositionableByUser ifTrue: [ self moveToEmptySpace ] ].
	^ roassalShape
]

{ #category : #'as yet unclassified' }
OPShape >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: roassalShape position
			 extent: roassalShape extent).
	super updateFromRender
]

{ #category : #roassal }
OPShape >> updateRenderFromBounds [

	bounds ifNotNil: [ 
		roassalShape
			extent: bounds extent;
			translateTo: bounds position ]
]

{ #category : #roassal }
OPShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self updateRenderFromBounds.
	super updateRenderFromSelf
]
