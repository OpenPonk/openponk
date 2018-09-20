"
I am line that originates and ends in the same element.
I am visualized as a circle arc; radius can be specified with ==#radius:==
"
Class {
	#name : #OPRTArcLine,
	#superclass : #RTAbstractLine,
	#instVars : [
		'head',
		'tail',
		'radius'
	],
	#category : 'OpenPonk-Roassal2-Shapes'
}

{ #category : #public }
OPRTArcLine class >> constraintLabel: aLabel at: anArcLine [
	aLabel translateTo: (anArcLine shape startingPointOf: anArcLine) + (10 @ 10) + ((aLabel width / 2) @ 0).
	anArcLine from addCallback: (TRTranslationCallback with: aLabel)
]

{ #category : #rendering }
OPRTArcLine >> arcShapeFor: anEdge [
	| shape |
	shape := OPTRArcShape new.
	shape width: width.
	shape radius: radius.
	shape from: (attachPoint startingPointOf: anEdge) to: (attachPoint endingPointOf: anEdge).
	shape color: (self colorFor: anEdge).
	^ shape
]

{ #category : #accessing }
OPRTArcLine >> attachPoint: anAttachPoint [
	tail attachPoint: anAttachPoint.
	head attachPoint: anAttachPoint.
	attachPoint := anAttachPoint
]

{ #category : #accessing }
OPRTArcLine >> color: aColor [
	tail color: aColor.
	head color: aColor.
	color := aColor
]

{ #category : #accessing }
OPRTArcLine >> head: aLineDecorationShape [
	(head := aLineDecorationShape asHead)
		attachPoint: attachPoint;
		color: color
]

{ #category : #initialization }
OPRTArcLine >> initialize [
	super initialize.
	self head: RTNoDecorationShape asHead.
	self tail: RTNoDecorationShape asTail.
	self attachPoint: OPRTCircleSelfAttachPoint new
]

{ #category : #accessing }
OPRTArcLine >> radius: aNumber [
	radius := aNumber
]

{ #category : #accessing }
OPRTArcLine >> tail: aLineDecorationShape [
	(tail := aLineDecorationShape asTail)
		attachPoint: attachPoint;
		color: color
]

{ #category : #rendering }
OPRTArcLine >> trachelShapeFor: anEdge [
	| arcShape from |
	arcShape := self arcShapeFor: anEdge.
	"5@0 should be actually something like head width ... to offset the fact that we want earlier tangent"
	from := 6 @ 0 + (arcShape arc circle tangentAt: (attachPoint endingPointOf: anEdge)).

	^ TRCompositeShape new
		addShape: arcShape;
		addShape: (head trachelShapeFor: anEdge from: from);
		addShape: (tail trachelShapeFor: anEdge);
		yourself
]

{ #category : #rendering }
OPRTArcLine >> updateArcFor: anEdge trachelShape: trachelShape [
	trachelShape from: (attachPoint startingPointOf: anEdge) to: (attachPoint endingPointOf: anEdge).
	trachelShape width: width.
	trachelShape radius: radius.
	trachelShape color: (self colorFor: anEdge).
	trachelShape resetPath
]

{ #category : #rendering }
OPRTArcLine >> updateFor: anEdge trachelShape: trachelShape [
	| from |
	self updateArcFor: anEdge trachelShape: trachelShape shapes first.
	from := 6 @ 0 + (trachelShape shapes first arc circle tangentAt: (attachPoint endingPointOf: anEdge)).
	head updateFor: anEdge trachelShape: (trachelShape shapes atLast: 2) from: from.
	tail updateFor: anEdge trachelShape: trachelShape shapes last
]
