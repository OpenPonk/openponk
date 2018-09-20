Class {
	#name : #OPCircleArc,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'circle'
	],
	#category : 'OpenPonk-Trachel-Primitives'
}

{ #category : #'instance creation' }
OPCircleArc class >> from: fromPoint to: toPoint radius: aNumber [
	^ self new setFrom: fromPoint to: toPoint radius: aNumber
]

{ #category : #accessing }
OPCircleArc >> angles [
	| a b alpha |
	a := self circle center - from.
	b := self circle center - to.
	alpha := ((a dotProduct: b) / (a r * b r)) arcCos.
	^ {alpha.
	(Float twoPi - alpha)}
]

{ #category : #accessing }
OPCircleArc >> biggerAngle [
	^ self angles max
]

{ #category : #accessing }
OPCircleArc >> circle [
	^ circle
]

{ #category : #accessing }
OPCircleArc >> from [
	^ from
]

{ #category : #initialization }
OPCircleArc >> setFrom: aFromPoint to: aToPoint radius: aNumber [
	from := aFromPoint.
	to := aToPoint.
	circle := (OPCircle circlesFor: aFromPoint and: aToPoint radius: aNumber) last
]

{ #category : #accessing }
OPCircleArc >> smallerAngle [
	^ self angles min
]

{ #category : #accessing }
OPCircleArc >> to [
	^ to
]
