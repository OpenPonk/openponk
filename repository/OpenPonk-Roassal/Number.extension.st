Extension { #name : 'Number' }

{ #category : '*OpenPonk-Roassal' }
Number >> closeTo: num absolutePrecision: aPrecision [
	"are these two numbers close?"

	num isFloat ifTrue: [
		^ num closeTo: self asFloat absolutePrecision: aPrecision ].
	^ [ self between: num - aPrecision and: num + aPrecision ]
		  onErrorDo: [ false ]
]
