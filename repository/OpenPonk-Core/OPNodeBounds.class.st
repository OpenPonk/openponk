"
Represents the spatial boundaries (position and extent) of a node within a diagram.
"
Class {
	#name : 'OPNodeBounds',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'width',
		'height'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
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

{ #category : 'comparing' }
OPNodeBounds >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ x = anObject x and: [ 
		y = anObject y and: [ 
			width = anObject width and: [ 
				height = anObject height ] ] ]
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

{ #category : 'comparing' }
OPNodeBounds >> hash [
	^ (((x hash hashMultiply
		bitXor: y hash) hashMultiply
		bitXor: width hash) hashMultiply
		bitXor: height hash)
]

{ #category : 'accessing' }
OPNodeBounds >> height [

	^ height
]

{ #category : 'accessing' }
OPNodeBounds >> height: aNumber [
	height := aNumber
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

{ #category : 'transforming' }
OPNodeBounds >> round [

	self x: self x rounded.
	self y: self y rounded.
	self width: self width rounded.
	self height: self height rounded
]

{ #category : 'transforming' }
OPNodeBounds >> translateTo: aPoint [

	"center point"

	self position: aPoint
]

{ #category : 'accessing' }
OPNodeBounds >> width [

	^ width
]

{ #category : 'accessing' }
OPNodeBounds >> width: aNumber [
	width := aNumber
]

{ #category : 'accessing' }
OPNodeBounds >> x [

	^ x
]

{ #category : 'accessing' }
OPNodeBounds >> x: aNumber [
	x := aNumber
]

{ #category : 'accessing' }
OPNodeBounds >> y [

	^ y
]

{ #category : 'accessing' }
OPNodeBounds >> y: aNumber [
	y := aNumber
]
