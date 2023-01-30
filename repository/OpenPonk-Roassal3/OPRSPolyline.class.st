Class {
	#name : #OPRSPolyline,
	#superclass : #RSPolyline,
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #'as yet unclassified' }
OPRSPolyline >> includedRadius [

	^ super includedRadius + 2
]
