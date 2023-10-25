Class {
	#name : #OPRSMarkerBuilder,
	#superclass : #Object,
	#category : #'OpenPonk-Roassal-Markers'
}

{ #category : #shapes }
OPRSMarkerBuilder class >> arrow [

	^ self fromShape: self arrowShape
]

{ #category : #shapes }
OPRSMarkerBuilder class >> arrowShape [

	^ RSPolygon new points: { 
			  (5 @ 10).
			  (0 @ 5).
			  (-5 @ 10).
			  (0 @ 0) }
]

{ #category : #shapes }
OPRSMarkerBuilder class >> circle [

	^ self fromShape: self circleShape
]

{ #category : #shapes }
OPRSMarkerBuilder class >> circleShape [

	^ RSCircle new
		  size: 10;
		  yourself
]

{ #category : #shapes }
OPRSMarkerBuilder class >> diamond [

	^ self fromShape: self diamondShape
]

{ #category : #shapes }
OPRSMarkerBuilder class >> diamondShape [

	^ RSPolygon new points: { 
			  (0 @ 20).
			  (7 @ 10).
			  (0 @ 0).
			  (-7 @ 10) }
]

{ #category : #shapes }
OPRSMarkerBuilder class >> diamondShapeWithLetter: aCharacter [

	| label |
	label := RSLabel new
		         text: aCharacter asString;
		         color: Color white;
		         fontSize: 9;
		         translateBy: -0.5 @ 10;
		         yourself.
	^ RSBorderColoringComposite new
		  shapes: { 
				  self diamondShape.
				  label };
		  useBorderColorAsPaintFor: label;
		  yourself
]

{ #category : #shapes }
OPRSMarkerBuilder class >> diamondWithLetter: aCharacter [

	^ self fromShape: (self diamondShapeWithLetter: aCharacter)
]

{ #category : #shapes }
OPRSMarkerBuilder class >> doubleTriangle [

	^ self fromShape: self doubleTriangleShape
]

{ #category : #shapes }
OPRSMarkerBuilder class >> doubleTriangleShape [

	^ RSPolygon new points: { 
			  (0 @ 0).
			  (-5 @ 8).
			  (0 @ 8).
			  (-5 @ 16).
			  (5 @ 16).
			  (0 @ 8).
			  (5 @ 8) }
]

{ #category : #examples }
OPRSMarkerBuilder class >> example [

	| c b1 b2 m l |
	
	c := RSCanvas new.

	b1 := RSBox new.
	b1 color: Color blue.
	b1 @ RSDraggable.
	b2 := RSBox new.
	b2 color: Color green.
	b2 @ RSDraggable.

	b2 translateTo: 150 @ 100.

	m := self diamondWithLetter: $M.

	l := RSLine new.
	l withBorderAttachPoint.

	l markerEnd: m.

	l color: Color red muchDarker.
	l
		from: b1;
		to: b2.

	c
		add: b1;
		add: b2;
		add: l.

	c @ RSDraggableCanvasInteraction.
	c @ OPRSZoomableCanvasInteraction.

	c zoomToFit.

	c open
]

{ #category : #shapes }
OPRSMarkerBuilder class >> fromShape: aShape [

	| marker |
	marker := aShape asMarker.
	marker offset: aShape height / 2.
	^ marker
]

{ #category : #shapes }
OPRSMarkerBuilder class >> triangle [

	^ self fromShape: self triangleShape
]

{ #category : #shapes }
OPRSMarkerBuilder class >> triangleShape [

	^ RSPolygon new points: { 
			  (0 @ 0).
			  (-5 @ 8).
			  (5 @ 8) }
]
