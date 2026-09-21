"
Mock diagram edge. 
Used exclusively for rendering and connection logic tests.
"
Class {
	#name : 'OPTestEdge',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
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
