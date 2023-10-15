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

	roassalShape
		translateTo: event position;
		signalUpdate
]

{ #category : #rendering }
OPInvisibleOnMouseShape >> removeRender [

	| canvas |
	self isRendered ifFalse: [ ^ self ].
	canvas := roassalShape canvas.
	canvas announcer unsubscribe: self.
	super removeRender.
	canvas signalUpdate
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
	
	roassalShape translateTo: self bounds position.

	roassalShape canvas
		when: RSMouseMove
		do: [ :event | self mouseMovedBy: event ]
		for: self
]
