Class {
	#name : #OPTRCanvasGridShape,
	#superclass : #TRCanvasGridShape,
	#category : #'OpenPonk-Trachel-Shapes'
}

{ #category : #private }
OPTRCanvasGridShape >> computePath [
	| width height |
	width := self canvas extent x / canvas camera scale roundUpTo: spacing.
	height := self canvas extent y / canvas camera scale roundUpTo: spacing.
	canvas camera scale < 0.7 ifTrue: [ ^nil ].
	path := self athensCanvas
		createPath:
			[ :builder | 
			builder absolute.
			height negated to: height by: spacing do: [ :i | 
				builder
					moveTo: width negated @ i;
					lineTo: width @ i ].
			width negated to: width by: spacing do: [ :i | 
				builder
					moveTo: i @ height negated;
					lineTo: i @ height ] ]
]

{ #category : #drawing }
OPTRCanvasGridShape >> drawOn: athensCanvas [
	self path ifNil: [ ^ self ].
	^ super drawOn: athensCanvas
]
