Class {
	#name : 'OPRSPolyline',
	#superclass : 'RSPolyline',
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'as yet unclassified' }
OPRSPolyline >> includedRadius [

	^ super includedRadius + 2
]
