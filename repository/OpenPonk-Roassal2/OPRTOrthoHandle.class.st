"
I am a base class for orthogonal connection handles.
"
Class {
	#name : #OPRTOrthoHandle,
	#superclass : #DoubleLink,
	#instVars : [
		'element',
		'edge',
		'positionLink'
	],
	#category : 'OpenPonk-Roassal2-Connection'
}

{ #category : #positioning }
OPRTOrthoHandle >> basicMoveBy: aVector [
	positionLink value: positionLink value + aVector.
	element
		ifNotNil:
			[ element trachelShape doWithoutCallbacks: [ element translateBy: aVector ] ]
]

{ #category : #positioning }
OPRTOrthoHandle >> basicMoveTo: aPosition [
	positionLink value: aPosition.
	element
		ifNotNil:
			[ element trachelShape
				doWithoutCallbacks: [ element translateTo: aPosition ] ]
]

{ #category : #positioning }
OPRTOrthoHandle >> constraintVector: aVector for: aNeighbor [
	^ self position y - aVector y = aNeighbor position y
		ifTrue: [ 0 @ aVector y ]
		ifFalse: [ aVector x @ 0 ]
]

{ #category : #accessing }
OPRTOrthoHandle >> edge: anEdge [
	edge := anEdge
]

{ #category : #testing }
OPRTOrthoHandle >> isEnd [
	^ false
]

{ #category : #positioning }
OPRTOrthoHandle >> moveBy: aVector from: aNeighbor [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPRTOrthoHandle >> position [
	^ positionLink value
]

{ #category : #accessing }
OPRTOrthoHandle >> positionLink: aDoubleLink [
	positionLink := aDoubleLink
]

{ #category : #removing }
OPRTOrthoHandle >> removeHandle [
	element
		ifNotNil:
			[ element connectedEdges removeAll.
			element trachelShape callbacks removeAll.
			element remove.
			element := nil ]
]

{ #category : #rendering }
OPRTOrthoHandle >> renderIn: aView [
	element := self shape element.
	aView add: element.
	element addConnectedEdge: edge.
	element translateTo: self position
]

{ #category : #'instance creation' }
OPRTOrthoHandle >> shape [
	^ RTEllipse new
		size: 9;
		color: Color black;
		borderColor: Color black;
		yourself
]
