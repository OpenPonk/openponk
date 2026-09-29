"
Extension of the standard Roassal Polyline shape. 
Provides custom calculations for bounding geometry and attachment inclusion radii across segmented straight paths.
"
Class {
	#name : 'OPRSPolyline',
	#superclass : 'RSPolyline',
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'accessing' }
OPRSPolyline >> includedRadius [

	^ super includedRadius + 1.5 + (2.5 / self canvas camera scale)
]
