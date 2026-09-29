"
Roassal marker that represents an explicitly empty or transparent end decoration for a line, ensuring bounding boxes and line attachments calculate correctly even without visible arrows.
"
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
