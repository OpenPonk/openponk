Class {
	#name : #OPDIBounds,
	#superclass : #Object,
	#instVars : [
		'x',
		'y',
		'width',
		'height'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'instance creation' }
OPDIBounds class >> withEncompassingRectangle: aRectangle [

	^ self new
		  extent: aRectangle extent;
		  origin: aRectangle origin;
		  yourself
]

{ #category : #'instance creation' }
OPDIBounds class >> withPosition: aPositionPoint extent: anExtentPoint [

	^ self new
		  position: aPositionPoint extent: anExtentPoint;
		  yourself
]

{ #category : #accessing }
OPDIBounds >> extent [

	^ self width @ self height
]

{ #category : #accessing }
OPDIBounds >> extent: aPoint [

	self
		width: aPoint x;
		height: aPoint y
]

{ #category : #accessing }
OPDIBounds >> height [

	^ height
]

{ #category : #accessing }
OPDIBounds >> height: anObject [

	height := anObject
]

{ #category : #accessing }
OPDIBounds >> origin [

	^ self x @ self y
]

{ #category : #accessing }
OPDIBounds >> origin: aPoint [

	self
		x: aPoint x;
		y: aPoint y
]

{ #category : #accessing }
OPDIBounds >> position [

	"center point"

	^ self origin + (self extent / 2)
]

{ #category : #accessing }
OPDIBounds >> position: aPositionPoint extent: anExtentPoint [

	"center point and size"

	self
		extent: anExtentPoint;
		origin: aPositionPoint - (anExtentPoint / 2)
]

{ #category : #accessing }
OPDIBounds >> width [

	^ width
]

{ #category : #accessing }
OPDIBounds >> width: anObject [

	width := anObject
]

{ #category : #accessing }
OPDIBounds >> x [

	^ x
]

{ #category : #accessing }
OPDIBounds >> x: anObject [

	x := anObject
]

{ #category : #accessing }
OPDIBounds >> y [

	^ y
]

{ #category : #accessing }
OPDIBounds >> y: anObject [

	y := anObject
]
