Class {
	#name : #OPRSPolyline,
	#superclass : #RSPolyline,
	#category : #'OpenPonk-Roassal-Polyline'
}

{ #category : #'as yet unclassified' }
OPRSPolyline >> includedRadius [

	^ super includedRadius + 2
]
