Class {
	#name : #OPRSResize,
	#superclass : #RSResize,
	#instVars : [
		'oversize'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #accessing }
OPRSResize >> oversize [

	^ oversize ifNil: [ 0 @ 0 ]
]

{ #category : #accessing }
OPRSResize >> oversize: anExtent [

	oversize := anExtent
]

{ #category : #public }
OPRSResize >> sameSize [

	self ifNoFixedShapeThen: [ self useBiggestShape ].
	shapes do: [ :e | e extent: self fixedShape extent + self oversize ]
]

{ #category : #'as yet unclassified' }
OPRSResize >> stickSameSize [

	| block |
	block := [ self sameSize ].
	block value.
	self fixedShape
		when: RSExtentChangedEvent
		do: [ :event | block value ]
]
