Extension { #name : #Point }

{ #category : #'*OpenPonk-Roassal' }
Point >> closeTo: aPoint absolutePrecision: aPrecision [

	^ (x closeTo: aPoint x absolutePrecision: aPrecision) and: [ 
		  y closeTo: aPoint y absolutePrecision: aPrecision ]
]
