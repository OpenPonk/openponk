"
A DCRTToSelfAttachPoint is attachpoint for connecting an element with itself
"
Class {
	#name : #OPRTToSelfAttachPoint,
	#superclass : #RTAttachPoint,
	#instVars : [
		'distance'
	],
	#category : 'OpenPonk-Roassal2-Core'
}

{ #category : #accessing }
OPRTToSelfAttachPoint >> distanceFromCorner [
	^ distance
]

{ #category : #accessing }
OPRTToSelfAttachPoint >> distanceFromCorner: aDistance [
	distance := aDistance
]

{ #category : #'public - hooks' }
OPRTToSelfAttachPoint >> endingPointOf: aRTEdge [
	^ aRTEdge from encompassingRectangle bottomRight - (distance @ 0)
]

{ #category : #initialization }
OPRTToSelfAttachPoint >> initialize [
	super initialize.
	distance := 10
]

{ #category : #'public - hooks' }
OPRTToSelfAttachPoint >> startingPointOf: aRTEdge [
	^ aRTEdge from encompassingRectangle bottomRight - (0 @ distance)
]
