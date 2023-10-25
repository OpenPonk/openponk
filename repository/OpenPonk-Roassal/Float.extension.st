Extension { #name : #Float }

{ #category : #'*OpenPonk-Roassal' }
Float >> closeTo: num absolutePrecision: aPrecision [

	"Tell whether the receiver and arguments are close from each other given a absolute precision"

	num isNumber ifFalse: [ ^ [ self = num ] onErrorDo: [ false ] ].
	self = 0.0 ifTrue: [ ^ num abs < aPrecision ].
	num = 0 ifTrue: [ ^ self abs < aPrecision ].
	^ self = num asFloat or: [ (self - num) abs < aPrecision ]
]
