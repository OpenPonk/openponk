Class {
	#name : #OPRTMultilineBorderAttachPoint,
	#superclass : #RTBorderAttachPoint,
	#category : #'OpenPonk-Roassal2-Core'
}

{ #category : #'public - hooks' }
OPRTMultilineBorderAttachPoint >> basicEndingPointOf: anEdge [
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge from ]
		ifNotEmpty: [ (RTBox new
				size: 1;
				element)
				translateTo: points last;
				yourself ].
	^ self basicPointFrom: anEdge to to: rect of: anEdge
]

{ #category : #'public - hooks' }
OPRTMultilineBorderAttachPoint >> basicStartingPointOf: anEdge [
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge to ]
		ifNotEmpty: [ (RTBox new
				size: 1;
				element)
				translateTo: points first;
				yourself ].
	^ self basicPointFrom: anEdge from to: rect of: anEdge
]
