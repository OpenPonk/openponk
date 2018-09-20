"
I provide (user-)interactive router for DCRTConnection.

After clicking on the edge draggable handle points will be added.

!! Example
[[[
edge := DCRTStyledConnection new
	edgeFrom: a to: b.
edge @ DCRTInteractiveRouter.
]]]
"
Class {
	#name : #OPRTInteractiveRouter,
	#superclass : #Object,
	#instVars : [
		'points',
		'handler'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #adding }
OPRTInteractiveRouter >> addPoint: aPoint [
	points add: (DoubleLink value: aPoint)
]

{ #category : #accessing }
OPRTInteractiveRouter >> handler [
	^ handler
]

{ #category : #accessing }
OPRTInteractiveRouter >> handler: aHandler [
	handler := aHandler
]

{ #category : #initialization }
OPRTInteractiveRouter >> initialize [
	super initialize.
	points := DoubleLinkedList new
]

{ #category : #enumeration }
OPRTInteractiveRouter >> linksDo: aBlock [
	points linksDo: aBlock
]

{ #category : #accessing }
OPRTInteractiveRouter >> pointLinks [
	^ points
]

{ #category : #accessing }
OPRTInteractiveRouter >> points [
	points isEmpty ifTrue: [ ^ {} ].
	^ points asArray collect: #value
]

{ #category : #accessing }
OPRTInteractiveRouter >> points: aCollection [
	points removeAll.
	aCollection do: [ :each | self addPoint: each ]
]

{ #category : #geometry }
OPRTInteractiveRouter >> rebuildHandler [
	self handler ifNotNil: [ self handler rebuild ]
]

{ #category : #removing }
OPRTInteractiveRouter >> removeAll [
	points removeAll.
	self rebuildHandler
]

{ #category : #removing }
OPRTInteractiveRouter >> removePointLink: aLink for: anEdge [
	points removeLink: aLink.
	self rebuildHandler
]

{ #category : #geometry }
OPRTInteractiveRouter >> translateAllBy: aDistance [
	points linksDo: [ :each | each value: each value + aDistance ].
	self rebuildHandler
]
