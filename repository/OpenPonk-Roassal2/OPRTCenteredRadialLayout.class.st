"
I am a simple layout that arranges elements around the focused one in a radial layout based on BFS traversal of neighbors.
"
Class {
	#name : #OPRTCenteredRadialLayout,
	#superclass : #Object,
	#instVars : [
		'radius',
		'focus',
		'nodes',
		'edges',
		'duration'
	],
	#category : 'OpenPonk-Roassal2-Layouts'
}

{ #category : #initialization }
OPRTCenteredRadialLayout >> apply [
	| center segmentSize closed opened translator |
	center := focus position.
	opened := OrderedCollection new.
	opened add: focus.
	translator := duration asSeconds = 0
		ifTrue: [ RTDirectLayoutTranslator new ]
		ifFalse: [ RTSmoothLayoutTranslator new nbCycles: self duration asSeconds ].
	focus attributeAt: #layer put: 0.
	focus attributeAt: #parent put: nil.
	closed := OrderedCollection new.
	[ opened isNotEmpty ]
		whileTrue: [ | top |
			top := opened removeFirst.
			(closed includes: top)
				ifFalse: [ | neighbors |
					neighbors := (self neighborsOf: top) reject: [ :each | each hasAttribute: #parent ].
					neighbors
						do: [ :each | 
							each attributeAt: #parent put: top.
							each attributeAt: #layer put: (top attributeAt: #layer) + 1 ].
					top attributeAt: #children put: neighbors.
					opened addAll: neighbors ].
			closed add: top ].
	(closed collect: [ :each | each attributeAt: #layer ]) asSet sorted
		do: [ :i | 
			| layer |
			layer := closed select: [ :each | (each attributeAt: #layer) = i ].
			segmentSize := Float twoPi / layer size.
			layer
				withIndexDo: [ :each :j | 
					| angle |
					angle := segmentSize * j.
					translator translate: each to: center + (radius * i * (angle cos @ angle sin)) ] ].
	nodes
		do: [ :each | 
			each removeAttributeAt: #parent ifAbsent: [  ].
			each removeAttributeAt: #children ifAbsent: [  ].
			each removeAttributeAt: #layer ifAbsent: [  ] ].
	focus translateTo: center.
	focus view signalUpdate
]

{ #category : #initialization }
OPRTCenteredRadialLayout >> duration [
	^ duration ifNil: [ 1 second ]
]

{ #category : #initialization }
OPRTCenteredRadialLayout >> duration: aDuration [
	duration := aDuration
]

{ #category : #initialization }
OPRTCenteredRadialLayout >> neighborsOf: anElement [
	^ (anElement connectedEdges
		collect: [ :each | 
			each to = anElement
				ifTrue: [ each from ]
				ifFalse: [ each to ] ]) removeDuplicates
]

{ #category : #accessing }
OPRTCenteredRadialLayout >> radius [
	^ radius
]

{ #category : #accessing }
OPRTCenteredRadialLayout >> radius: anObject [
	radius := anObject
]

{ #category : #initialization }
OPRTCenteredRadialLayout >> setFocus: aFocusedNode nodes: aNodesCollection edges: anEdgesCollection [
	focus := aFocusedNode.
	nodes := aNodesCollection.
	edges := anEdgesCollection
]
