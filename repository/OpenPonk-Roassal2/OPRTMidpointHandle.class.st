"
I am a pseudo handle between two real handles. When dragged I am promoted to a real DCRTHandle.
"
Class {
	#name : #OPRTMidpointHandle,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'element',
		'edge',
		'nearStart',
		'nearEnd'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> beNearEnd [
	nearEnd := true
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> beNearStart [
	nearStart := true
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> constraintFor: anElement [
	nearStart & nearEnd
		ifTrue: [ ^ self constraintForStartEnd: anElement ].
	nearStart
		ifTrue: [ ^ self constraintForStart: anElement ].
	nearEnd
		ifTrue: [ ^ self constraintForEnd: anElement ].
	TRConstraint stick: anElement trachelShape between: from trachelShape and: to trachelShape
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> constraintForEnd: anElement [
	| moveBlock b callback |
	moveBlock := [ anElement translateTo: ((edge shape attachPoint endingPointOf: edge) + from position) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> constraintForStart: anElement [
	| moveBlock b callback |
	moveBlock := [ anElement translateTo: ((edge shape attachPoint startingPointOf: edge) + to position) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> constraintForStartEnd: anElement [
	| moveBlock b callback |
	moveBlock := [ 
	anElement
		translateTo:
			((edge shape attachPoint startingPointOf: edge)
				+ (edge shape attachPoint endingPointOf: edge)) / 2 ].
	moveBlock value.
	b := [ :shape :step | moveBlock value ].
	callback := TRTranslationCallback block: b.
	from addCallback: callback.
	to addCallback: callback.
	callback := TRExtentCallback block: b.
	from addCallback: callback.
	to addCallback: callback
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> element [
	^ element
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> from [
	^ from
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> initialize [
	super initialize.
	nearStart := nearEnd := false
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> on: anEdge between: fromElement and: toElement [
	edge := anEdge.
	from := fromElement.
	to := toElement
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> promote [
	edge shape router handler promoteFor: edge handle: self
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> remove [
	element remove
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> renderIn: aView [
	element := self shape elementOn: edge trachelShape.
	element @ RTDraggable.
	self constraintFor: element.
	element when: TRMouseDragStart do: [ :event | self promote ].
	aView add: element
]

{ #category : #'as yet unclassified' }
OPRTMidpointHandle >> shape [
	^ RTEllipse new
		size: 6;
		color: #color;
		borderColor: Color black;
		yourself
]
