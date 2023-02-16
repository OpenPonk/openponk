Class {
	#name : #OPRSEmptyMarker,
	#superclass : #RSMarker,
	#category : #'OpenPonk-Roassal3-Markers'
}

{ #category : #converting }
OPRSEmptyMarker >> asEmptyMarker [

	^ self
]

{ #category : #accessing }
OPRSEmptyMarker >> shape [

	^ OPRSEmptyShapeProxy new
		  shape: shape;
		  yourself
]
