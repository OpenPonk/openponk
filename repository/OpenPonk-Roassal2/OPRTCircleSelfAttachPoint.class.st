"
!! Responsibility

Describe positions for attach points for lines with same start end end.

!! Collaborators

DCRTArcLine

!! Assumptions

Connected element is expected to be a circle.
"
Class {
	#name : #OPRTCircleSelfAttachPoint,
	#superclass : #OPRTToSelfAttachPoint,
	#instVars : [
		'offset'
	],
	#category : 'OpenPonk-Roassal2-Core'
}

{ #category : #private }
OPRTCircleSelfAttachPoint >> cornerFor: anEdge [
	| c r |
	c := anEdge from position.
	r := anEdge from width / 2.	"assuming circle"
	^ c + ((self legFor: r) @ (self legFor: r)) + (self n @ self n)
]

{ #category : #'public - hooks' }
OPRTCircleSelfAttachPoint >> endingPointOf: anEdge [
	^ (self cornerFor: anEdge) - (distance @ 0)
]

{ #category : #private }
OPRTCircleSelfAttachPoint >> legFor: aRadius [
	^ aRadius / 2 sqrt
]

{ #category : #private }
OPRTCircleSelfAttachPoint >> n [
	^ (self legFor: distance / 2)
]

{ #category : #'public - hooks' }
OPRTCircleSelfAttachPoint >> startingPointOf: anEdge [
	^ (self cornerFor: anEdge) - (0 @ distance)
]
