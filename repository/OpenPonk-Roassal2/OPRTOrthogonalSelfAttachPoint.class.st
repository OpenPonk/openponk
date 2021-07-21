"
A DCRTToSelfAttachPoint is attachpoint for connecting an element with itself.
If multiple connections are made, each one has its attach point moved by offset
"
Class {
	#name : #OPRTOrthogonalSelfAttachPoint,
	#superclass : #OPRTToSelfAttachPoint,
	#instVars : [
		'offset'
	],
	#category : 'OpenPonk-Roassal2-Core'
}

{ #category : #'public - hooks' }
OPRTOrthogonalSelfAttachPoint >> endingPointOf: anEdge [
	^ (super endingPointOf: anEdge) - ((self offsetDistanceFor: anEdge) @ 0)
]

{ #category : #'public - hooks' }
OPRTOrthogonalSelfAttachPoint >> initialize [
	super initialize.
	offset := 10.
]

{ #category : #accessing }
OPRTOrthogonalSelfAttachPoint >> offset [
	^ offset
]

{ #category : #accessing }
OPRTOrthogonalSelfAttachPoint >> offset: anInteger [
	"In case fromElement and toElement have more than one edge between the same two extremities, offset is the distance between lines"
	offset := anInteger
]

{ #category : #public }
OPRTOrthogonalSelfAttachPoint >> offsetDistanceFor: anEdge [
	"Return the offset in case of multiple edges"

	| indexOfEdge multipleEdges |
	multipleEdges := OrderedCollection new.
	(anEdge to connectedEdges select: [ :e | e from == e to ]) do: [ :e | multipleEdges addIfNotPresent: e ].
	indexOfEdge := multipleEdges indexOf: anEdge.
	^ (indexOfEdge - 1) * offset
]

{ #category : #'public - hooks' }
OPRTOrthogonalSelfAttachPoint >> startingPointOf: anEdge [
	^ (super startingPointOf: anEdge) - (0 @ (self offsetDistanceFor: anEdge))
]
