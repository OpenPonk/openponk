"
I am rectangle attach point made specifically for DCRTConnection that makes use of Connection's waypoints and thus can correctly rotate end markers/decorations.

!! Collaborators

DCRTConnection
"
Class {
	#name : #OPRTNewRectangleAttachPoint,
	#superclass : #RTRectangleAttachPoint,
	#category : 'OpenPonk-Roassal2-Core'
}

{ #category : #'public - hooks' }
OPRTNewRectangleAttachPoint >> endingPointOf: anEdge [
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge from encompassingRectangle ]
		ifNotEmpty: [ points last corner: points last ].
	^ self attachPointFor: anEdge from: anEdge to encompassingRectangle to: rect
]

{ #category : #'as yet unclassified' }
OPRTNewRectangleAttachPoint >> initialize [
	inverted := false.
	offset := 5
]

{ #category : #'public - hooks' }
OPRTNewRectangleAttachPoint >> startingPointOf: anEdge [
	| points rect |
	points := anEdge shape points.
	rect := points
		ifEmpty: [ anEdge to encompassingRectangle ]
		ifNotEmpty: [ points first corner: points first ].
	^ self attachPointFor: anEdge from: anEdge from encompassingRectangle to: rect
]
