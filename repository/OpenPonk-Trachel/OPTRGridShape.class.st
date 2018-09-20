Class {
	#name : #OPTRGridShape,
	#superclass : #TRShape,
	#category : 'OpenPonk-Trachel-Shapes'
}

{ #category : #'as yet unclassified' }
OPTRGridShape >> computePath [
	| size spacing |
	size := 500.
	spacing := 20.
	path := self athensCanvas
		createPath:
			[ :builder | 
			builder absolute.
			size negated to: size by: spacing do:
				[ :i | 
				builder
					moveTo: size negated @ i;
					lineTo: size @ i.
				builder
					moveTo: i @ size negated;
					lineTo: i @ size ] ]
]

{ #category : #drawing }
OPTRGridShape >> drawOn: athensCanvas [
	athensCanvas pathTransform
		restoreAfter:
			[ 
			athensCanvas setShape: self path.
			(athensCanvas setStrokePaint: Color veryVeryLightGray) width: 1.
			athensCanvas draw ]
]

{ #category : #'as yet unclassified' }
OPTRGridShape >> encompassingRectangle [
	^ 0 @ 0 corner: 0@0
]
