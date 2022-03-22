Class {
	#name : #OPTREmptyDoubleArrowHeadShape,
	#superclass : #OPTRAbstractDoubleArrowHeadShape,
	#category : #'OpenPonk-Trachel-Shapes'
}

{ #category : #hooks }
OPTREmptyDoubleArrowHeadShape >> computePath [
	| vector r u unit middle left right back backLeft backRight |
	vector := self to - self from.
	r := vector r.
	r = 0
		ifTrue: [ ^ false ].
	u := vector normal / 2.
	unit := vector / r.
	middle := self to - (unit * size).
	back := middle - (unit * size).
	left := middle - (u * size).
	right := middle + (u * size).
	backLeft := back - (u * size).
	backRight := back + (u * size).
	path := self athensCanvas
		createPath:
			[ :builder | 
			builder
				absolute;
				moveTo: self to;
				lineTo: left;
				lineTo: right;
				lineTo: self to;
				moveTo: middle;
				lineTo: backLeft;
				lineTo: backRight;
				lineTo: middle ]
]
