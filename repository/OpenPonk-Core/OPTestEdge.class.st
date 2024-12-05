Class {
	#name : 'OPTestEdge',
	#superclass : 'OPEdge',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'rendering' }
OPTestEdge >> renderBasicShape [

	^ RSPolyline new
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
