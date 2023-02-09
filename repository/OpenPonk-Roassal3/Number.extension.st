Extension { #name : #Number }

{ #category : #'*OpenPonk-Roassal3' }
Number >> closeTo: num absolutePrecision: aPrecision [
	"are these two numbers close?"

	num isFloat ifTrue: [ ^ num closeTo: self asFloat absolutePrecision: aPrecision ].
	^ [ self = num ] onErrorDo: [ false ]
]