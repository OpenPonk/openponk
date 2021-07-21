Class {
	#name : #OPRTOrthogonalRouter,
	#superclass : #Object,
	#instVars : [
		'points',
		'handler'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #adding }
OPRTOrthogonalRouter >> addPoint: aPoint [
	points add: (DoubleLink value: aPoint)
]

{ #category : #accessing }
OPRTOrthogonalRouter >> handler [
	^ handler
]

{ #category : #accessing }
OPRTOrthogonalRouter >> handler: aHandler [
	handler := aHandler
]

{ #category : #initialization }
OPRTOrthogonalRouter >> initialize [
	super initialize.
	points := DoubleLinkedList new
]

{ #category : #'as yet unclassified' }
OPRTOrthogonalRouter >> orthogonalize [
	"ensure the path is orthogonal"

	self flag: '@todo'.
]

{ #category : #accessing }
OPRTOrthogonalRouter >> points [
	^ points asArray collect: #value
]

{ #category : #accessing }
OPRTOrthogonalRouter >> points: aCollection [
	points removeAll.
	aCollection do: [ :each | self addPoint: each ]
]

{ #category : #accessing }
OPRTOrthogonalRouter >> pointsList [
	^ points
]
