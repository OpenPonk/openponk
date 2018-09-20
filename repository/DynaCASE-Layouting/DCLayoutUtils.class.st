Class {
	#name : #DCLayoutUtils,
	#superclass : #Object,
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #'as yet unclassified' }
DCLayoutUtils >> addBoundingBoxFor: aCollection [
	aCollection do: [ :each | self addBoundingBoxTo: each ]
]

{ #category : #'as yet unclassified' }
DCLayoutUtils >> addBoundingBoxTo: anElement [
	| bb |
	bb := RTBox new
		borderColor: Color red;
		color: Color transparent;
		elementOn: anElement.
	bb extent: anElement extent.
	TRConstraint stick: bb onTheCenterOf: anElement.
	anElement view add: bb.
	bb trachelShape pushBehind: anElement trachelShape.
]

{ #category : #'as yet unclassified' }
DCLayoutUtils >> computeSolutionSpaceFor: aBox line: aLine [
	| vertA vertB space direction |
	space := OrderedCollection new.
	vertA := RTLineSegment from: aLine from to: aLine from + (0 @ aBox height).
	vertB := RTLineSegment from: aLine to to: aLine to + (0 @ aBox height).
	direction := aLine from x < aLine to x
		ifTrue: [ 1 ]
		ifFalse: [ -1 ].
	(vertA vector angleWith: aLine vector) >= Float halfPi
		ifTrue:
			[ space add: vertA from.
			space add: aLine from + (direction * (aBox width negated @ 0)).
			space add: aLine from + (direction * (aBox width negated @ aBox height)).
			space add: aLine to + (direction * (aBox width @ aBox height)).
			space add: aLine to + (direction * (aBox width @ 0)) ]
		ifFalse: [  ].	"space add: vertB from.
			space add: vertB to.
			space add: vertB from + (direction negated * (aBox width @ aBox height)).
			space add: aLine from + (direction negated * (0 @ aBox height))"
	space add: aLine to.
	^ space
]

{ #category : #'as yet unclassified' }
DCLayoutUtils >> showSolutionSpaceForLabel: aLabel edge: anEdge [
	| line space polygon |
	(anEdge hasAttribute: #solutionSpace)
		ifTrue:
			[ (anEdge attributeAt: #solutionSpace) remove.
			anEdge view signalUpdate.
			anEdge removeAttributeAt: #solutionSpace.
			^ self ].
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	space := self computeSolutionSpaceFor: aLabel encompassingRectangle line: line.
	polygon := RTPolygon new
		color: Color green;
		vertices: space;
		element.
	anEdge view add: polygon.
	polygon trachelShape pushBack.
	anEdge view signalUpdate.
	anEdge attributeAt: #solutionSpace put: polygon
]
