Class {
	#name : #OPInvisibleOnMouseShape,
	#superclass : #OPShape,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPInvisibleOnMouseShape class >> renderToPosition: aPoint onCanvas: aCanvas [

	^ self new
		  bounds: (OPDIBounds withPosition: aPoint extent: 0 @ 0);
		  renderIn: aCanvas;
		  yourself
]

{ #category : #rendering }
OPInvisibleOnMouseShape >> mouseMovedBy: event [

	| position block |
	roassalShape
		translateTo: event position;
		signalUpdate.

	position := event position.

	block := [ :list :pos | 
	         list reverseDo: [ :s | 
		         (s shapeWithActionForPosition: pos) ifNotNil: [ :shape | 
			         ^ shape announcer announce: event ] ] ].
	block
		value: event canvas fixedShapes
		value: (event camera fromSpaceToPixel: position).
	block
		value:
		(event canvas shapes copyWithoutAll: roassalShape connectedLines)
		value: position
]

{ #category : #rendering }
OPInvisibleOnMouseShape >> removeRender [

	self isRendered ifFalse: [ ^ self ].
	roassalShape canvas announcer unsubscribe: self.
	roassalShape canvas removeKey: #shapesIgnoringMouseMoveBlock.
	super removeRender
]

{ #category : #rendering }
OPInvisibleOnMouseShape >> renderBasicShape [

	^ RSBox new
		  size: 0;
		  color: Color transparent;
		  yourself
]

{ #category : #rendering }
OPInvisibleOnMouseShape >> renderShapeDetails [

	super renderShapeDetails.

	roassalShape canvas
		propertyAt: #shapesIgnoringMouseMoveBlock
		put: [ roassalShape connectedLines , { roassalShape } ].
	roassalShape canvas
		when: RSMouseMove
		do: [ :event | self mouseMovedBy: event ]
]
