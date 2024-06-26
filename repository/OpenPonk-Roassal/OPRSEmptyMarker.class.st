Class {
	#name : 'OPRSEmptyMarker',
	#superclass : 'RSMarker',
	#category : 'OpenPonk-Roassal-Markers',
	#package : 'OpenPonk-Roassal',
	#tag : 'Markers'
}

{ #category : 'converting' }
OPRSEmptyMarker >> asEmptyMarker [

	^ self
]

{ #category : 'accessing' }
OPRSEmptyMarker >> shape [

	^ OPRSEmptyShapeProxy new
		  shape: shape;
		  yourself
]
