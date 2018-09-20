Class {
	#name : #DCOCQueueEntry,
	#superclass : #Object,
	#instVars : [
		'node',
		'direction',
		'length',
		'bends',
		'parent',
		'cost'
	],
	#category : 'DynaCASE-Layouting-OCR'
}

{ #category : #accessing }
DCOCQueueEntry >> bends [
	^ bends
]

{ #category : #accessing }
DCOCQueueEntry >> bends: anObject [
	bends := anObject
]

{ #category : #accessing }
DCOCQueueEntry >> cost [
	^ cost
]

{ #category : #accessing }
DCOCQueueEntry >> cost: anObject [
	cost := anObject
]

{ #category : #accessing }
DCOCQueueEntry >> direction [
	^ direction
]

{ #category : #accessing }
DCOCQueueEntry >> direction: anObject [
	direction := anObject
]

{ #category : #computing }
DCOCQueueEntry >> estimateTo: aDestination [
	| isSame isOpposite isOrthogonal isExpected isExact isDestExpected |
	isSame := self direction = aDestination direction.
	isOpposite := self direction = (aDestination reverseOf: aDestination direction).
	isOrthogonal := isSame not & isOpposite not.
	isExpected := (aDestination dirnsFrom: self node) includes: self direction.
	isExact := (aDestination dirnsFrom: self node) = (Set with: self direction).
	isDestExpected := (aDestination dirnsFrom: self node)
		= (Set with: aDestination direction).
	isSame & isExact
		ifTrue: [ ^ 0 ].
	isOrthogonal & isExpected
		ifTrue: [ ^ 1 ].
	isSame & isExact not & isExpected | (isOpposite & isDestExpected not)
		ifTrue: [ ^ 2 ].
	isOrthogonal & isExpected not
		ifTrue: [ ^ 3 ].
	isOpposite & isDestExpected | (isSame & isExpected not)
		ifTrue: [ ^ 4 ]
]

{ #category : #accessing }
DCOCQueueEntry >> length [
	parent ifNil: [ ^ 0 ].
	^ self parent length + (self node distanceTo: self parent node)
]

{ #category : #accessing }
DCOCQueueEntry >> node [
	^ node
]

{ #category : #accessing }
DCOCQueueEntry >> node: anObject [
	node := anObject
]

{ #category : #accessing }
DCOCQueueEntry >> parent [
	^ parent
]

{ #category : #accessing }
DCOCQueueEntry >> parent: anObject [
	parent := anObject
]

{ #category : #computing }
DCOCQueueEntry >> priorityFrom: aSource to: aDestination [
	false
		ifTrue:
			[ ^ self length + (self node distanceTo: aSource) + (self node distanceTo: aDestination)
				+ (self estimateTo: aDestination) ]
		ifFalse: [ ^ self node distanceTo: aDestination ]
]

{ #category : #accessing }
DCOCQueueEntry >> route [
	| route step |
	route := OrderedCollection new.
	step := self.
	[ step ]
		whileNotNil: [ route add: step node model.
			step := step parent ].
	^ route reversed
]
