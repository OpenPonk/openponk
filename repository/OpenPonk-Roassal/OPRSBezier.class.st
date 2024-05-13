Class {
	#name : 'OPRSBezier',
	#superclass : 'RSBezier',
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'accessing' }
OPRSBezier >> includedRadius [

	^ super includedRadius + 3
]

{ #category : 'private' }
OPRSBezier >> lines [

	| c b a via1 via2 start end cp |
	cp := controlPoints.
	cp size < 3 ifTrue: [ ^ nil ].
	start := cp first.
	via1 := cp second.
	via2 := cp third.
	end := cp size = 3
		       ifTrue: [ via2 ]
		       ifFalse: [ cp fourth ].
	c := 3 * (via1 - start).
	b := 3 * (via2 - via1) - c.
	a := end - start - c - b.

	^ (0 to: 1 by: 0.05) collect: [ :t | 
		  a * (t raisedTo: 3) + (b * (t * t)) + (c * t) + start ]
]
