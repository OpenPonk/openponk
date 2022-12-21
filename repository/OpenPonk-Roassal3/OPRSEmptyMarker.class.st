Class {
	#name : #OPRSEmptyMarker,
	#superclass : #RSMarker,
	#category : #'OpenPonk-Roassal3'
}

{ #category : #accessing }
OPRSEmptyMarker >> shape [

	^ OPRSEmptyShapeProxy new
		  shape: shape;
		  yourself
]
