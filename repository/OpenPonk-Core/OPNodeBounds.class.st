Class {
	#name : 'OPNodeBounds',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'width',
		'height'
	],
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'instance creation' }
OPNodeBounds class >> withEncompassingRectangle: aRectangle [

	^ self new
		  extent: aRectangle extent;
		  origin: aRectangle origin;
		  yourself
]

{ #category : 'instance creation' }
OPNodeBounds class >> withPosition: aPositionPoint extent: anExtentPoint [

	^ self new
		  position: aPositionPoint extent: anExtentPoint;
		  yourself
]

{ #category : 'accessing' }
OPNodeBounds >> extent [

	^ self width @ self height
]

{ #category : 'accessing' }
OPNodeBounds >> extent: aPoint [

	self
		width: aPoint x;
		height: aPoint y
]

{ #category : 'accessing' }
OPNodeBounds >> height [

	^ height
]

{ #category : 'accessing' }
OPNodeBounds >> height: anObject [

	height := anObject rounded
]

{ #category : 'accessing' }
OPNodeBounds >> origin [

	^ self x @ self y
]

{ #category : 'accessing' }
OPNodeBounds >> origin: aPoint [

	self
		x: aPoint x;
		y: aPoint y
]

{ #category : 'accessing' }
OPNodeBounds >> position [

	"center point"

	^ self origin + (self extent / 2)
]

{ #category : 'accessing' }
OPNodeBounds >> position: aPoint [

	"center point"

	self
		assert: self extent isNotNil
		description:
		'Extent (width and height) must be set before setting position (origin x and y)'.
	self origin: aPoint - (self extent / 2)
]

{ #category : 'accessing' }
OPNodeBounds >> position: aPositionPoint extent: anExtentPoint [

	"center point and size"

	self
		extent: anExtentPoint;
		position: aPositionPoint
]

{ #category : 'accessing' }
OPNodeBounds >> translateTo: aPoint [

	"center point"

	self position: aPoint
]

{ #category : 'accessing' }
OPNodeBounds >> width [

	^ width
]

{ #category : 'accessing' }
OPNodeBounds >> width: anObject [

	width := anObject rounded
]

{ #category : 'accessing' }
OPNodeBounds >> x [

	^ x
]

{ #category : 'accessing' }
OPNodeBounds >> x: anObject [

	x := anObject rounded
]

{ #category : 'accessing' }
OPNodeBounds >> y [

	^ y
]

{ #category : 'accessing' }
OPNodeBounds >> y: anObject [

	y := anObject rounded
]
