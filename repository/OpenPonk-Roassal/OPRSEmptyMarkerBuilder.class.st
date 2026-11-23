"
Specialized marker builder that constructs empty (transparent or null) markers for lines that require no visible end decorations.
"
Class {
	#name : 'OPRSEmptyMarkerBuilder',
	#superclass : 'OPRSMarkerBuilder',
	#category : 'OpenPonk-Roassal-Markers',
	#package : 'OpenPonk-Roassal',
	#tag : 'Markers'
}

{ #category : 'shapes' }
OPRSEmptyMarkerBuilder class >> fromShape: aShape [

	^ (super fromShape: aShape) asEmptyMarker
]
