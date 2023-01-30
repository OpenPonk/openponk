Class {
	#name : #OPRSEmptyMarker,
	#superclass : #RSMarker,
	#category : #'OpenPonk-Roassal3-Markers'
}

{ #category : #accessing }
OPRSEmptyMarker >> shape [

	^ OPRSEmptyShapeProxy new
		  shape: shape;
		  yourself
]
