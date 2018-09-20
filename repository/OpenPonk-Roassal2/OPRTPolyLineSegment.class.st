"
I am an ordered collection of LineSegments. I provide some extra functions such as searching for specific segment given some position etc.
"
Class {
	#name : #OPRTPolyLineSegment,
	#superclass : #RTObject,
	#instVars : [
		'segments'
	],
	#category : 'OpenPonk-Roassal2-Core'
}

{ #category : #'instance creation' }
OPRTPolyLineSegment class >> with: aSegment [
	^ self new
		segments: {aSegment};
		yourself
]

{ #category : #'instance creation' }
OPRTPolyLineSegment class >> with: first with: second [
	^ self new
		segments: (Array with: first with: second);
		yourself
]

{ #category : #'instance creation' }
OPRTPolyLineSegment class >> withAll: aCollection [
	^ self new
		segments: aCollection;
		yourself
]

{ #category : #accessing }
OPRTPolyLineSegment >> absoluteBalanceFor: aNumber [
	| balance |
	balance := aNumber.
	balance > 1
		ifTrue: [ ^ self length min: balance ].
	balance < 0
		ifTrue: [ ^ 0 max: self length - balance negated ].
	^ self length * balance
]

{ #category : #accessing }
OPRTPolyLineSegment >> first [
	^ self segments first
]

{ #category : #initialization }
OPRTPolyLineSegment >> initialize [
	segments := #()
]

{ #category : #accessing }
OPRTPolyLineSegment >> last [
	^ self segments last
]

{ #category : #accessing }
OPRTPolyLineSegment >> length [
	^ self segments inject: 0 into: [ :sum :next | sum + next length ]
]

{ #category : #accessing }
OPRTPolyLineSegment >> second [
	^ self segments second
]

{ #category : #accessing }
OPRTPolyLineSegment >> segmentWithPointFor: aNumber [
	| sum newSum balance |
	sum := 0.
	balance := self absoluteBalanceFor: aNumber.
	self segments
		do:
			[ :each | 
			newSum := sum + each length.
			(balance between: sum and: newSum)
				ifTrue: [ 
					^ {each.
					(each pointForBalance: balance - sum)} ].
			sum := newSum ].
	self error: 'failed to find a segment'
]

{ #category : #accessing }
OPRTPolyLineSegment >> segments [
	^ segments
]

{ #category : #accessing }
OPRTPolyLineSegment >> segments: aCollection [
	segments := aCollection
]
