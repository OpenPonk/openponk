"
Mock diagram edge. 
Used exclusively for rendering and connection logic tests.
"
Class {
	#name : 'OPTestEdge',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'rendering' }
OPTestEdge >> renderBasicShape [

	^ OPRSPolyline new
		  withBorderAttachPoint;
		  controlPointsController: OPRSDraggableCPController new;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
