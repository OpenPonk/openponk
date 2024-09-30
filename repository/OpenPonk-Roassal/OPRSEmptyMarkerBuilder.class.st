Class {
	#name : 'OPRSEmptyMarkerBuilder',
	#superclass : 'OPRSMarkerBuilder',
	#category : 'OpenPonk-Roassal-Markers',
	#package : 'OpenPonk-Roassal',
	#tag : 'Markers'
}

{ #category : 'examples' }
OPRSEmptyMarkerBuilder class >> example [

	^ super example
]

{ #category : 'instance creation' }
OPRSEmptyMarkerBuilder class >> fromShape: aShape [

	^ (super fromShape: aShape) asEmptyMarker
]
