"
I am an attach point for StyledConnection that orients the end orthogonally to the nearest path point if possible --- the segment should be orthogonal to the side of the end element.

If this is not possible, it behaves like NewRectangleAttachPoint.
"
Class {
	#name : #OPRTOrthogonalAttachPoint,
	#superclass : #OPRTNewRectangleAttachPoint,
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #'as yet unclassified' }
OPRTOrthogonalAttachPoint >> attachPointFor: anEdge from: fromRect to: toRect [
	| fromPoint toPoint |
	anEdge shape points
		ifEmpty: [ ^ super attachPointFor: anEdge from: fromRect to: toRect ].
	toPoint := toRect center.
	((toPoint x between: fromRect left and: fromRect right)
		xor: [ toPoint y between: fromRect top and: fromRect bottom ])
		ifFalse: [ ^ super attachPointFor: anEdge from: fromRect to: toRect ].
	(toPoint x between: fromRect left and: fromRect right)
		ifTrue:
			[ fromPoint := (Array with: toPoint x @ fromRect top with: toPoint x @ fromRect bottom)
				detectMin: [ :each | each dist: toPoint ] ].
	(toPoint y between: fromRect top and: fromRect bottom)
		ifTrue:
			[ fromPoint := (Array with: fromRect left @ toPoint y with: fromRect right @ toPoint y)
				detectMin: [ :each | each dist: toPoint ] ].
	^ fromPoint ifNil: [ self error ]
]

{ #category : #'as yet unclassified' }
OPRTOrthogonalAttachPoint >> initialize [
	inverted := false.
	offset := 5
]
