Class {
	#name : #OPNoShape,
	#superclass : #OPShape,
	#instVars : [
		'moveSubscription'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #rendering }
OPNoShape class >> renderToPosition: aPoint onCanvas: aCanvas [

	^ self new
		  bounds: (OPDIBounds withPosition: aPoint extent: 2 @ 2);
		  renderIn: aCanvas;
		  yourself
]

{ #category : #rendering }
OPNoShape >> removeRender [

	self isRendered ifFalse: [ ^ self ].
	roassalShape canvas announcer unsubscribe: self.
	super removeRender
]

{ #category : #rendering }
OPNoShape >> renderBasicShape [

	roassalShape := RSBox new
		                color: Color transparent;
		                borderColor: Color transparent;
		                yourself
]

{ #category : #rendering }
OPNoShape >> renderShapeDetails [

	moveSubscription := roassalShape canvas
		                    when: RSMouseMove
		                    do: [ :event | 
			                    roassalShape
				                    translateTo: event position;
				                    signalUpdate ]
]
