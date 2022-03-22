Class {
	#name : #OPRTSVGDoubleArrowHeadMarker,
	#superclass : #RTSVGAbstractMarker,
	#category : #'OpenPonk-Roassal2-Exporter'
}

{ #category : #adding }
OPRTSVGDoubleArrowHeadMarker >> addPath: stream [

	| halfX minusHalfX |
	halfX := (xExtent / 2) rounded.
	minusHalfX := halfX negated.
	"<1p> = half of width"
	"<2p> = move needed from middle of shape to attach point"
	"<3p> = opposite of <2p>"
	"<4p> = x furthest from attach point"
	stream nextPutAll:
		(' d="M <4p> <1p> l 0 <1p> l <2p> -<1p> l 0 <1p> l <2p> -<1p> l <3p> -<1p> l 0 <1p> l <3p> -<1p> z" '
			 expandMacrosWith: (yExtent / 2) rounded
			 with: (self isOnStart
					  ifTrue: [ minusHalfX ]
					  ifFalse: [ halfX ])
			 with: (self isOnStart
					  ifTrue: [ halfX ]
					  ifFalse: [ minusHalfX ])
			 with: (self isOnStart
					  ifTrue: [ xExtent ]
					  ifFalse: [ 0 ]))
]

{ #category : #adding }
OPRTSVGDoubleArrowHeadMarker >> addSize: stream [

	stream nextPutAll: ('markerWidth = "<1p>" markerHeight = "<2p>" '
			 expandMacrosWith: 2 * size
			 with: size)
]

{ #category : #initialization }
OPRTSVGDoubleArrowHeadMarker >> initialize [

	super initialize.
	xExtent := 20.
	yExtent := 10
]
