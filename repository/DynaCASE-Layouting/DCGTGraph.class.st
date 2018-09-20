Class {
	#name : #DCGTGraph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges'
	],
	#category : 'DynaCASE-Layouting-DGT'
}

{ #category : #'as yet unclassified' }
DCGTGraph class >> graphModel [
	'
DCGTGraph { }
DCGTEdge { }
DCGTNode { }

DCGTNode[1] from <>-> edges DCGTEdge[*];
DCGTNode[1] to <>-> edges DCGTEdge[*];

DCGTGraph --> nodes DCGTNode[*];
DCGTGraph --> edges DCGTEdge[*];


' asClassDiagram open
]

{ #category : #'adding/removing' }
DCGTGraph >> addEdge: aDCGTEdge [
	(edges includes: aDCGTEdge) ifTrue: [ ^ self ].
	edges add: aDCGTEdge
]

{ #category : #'adding/removing' }
DCGTGraph >> addNode: aDCGTNode [
	(nodes includes: aDCGTNode) ifTrue: [ ^ self ].
	nodes add: aDCGTNode
]

{ #category : #geometry }
DCGTGraph >> degreeFor: aVertex [
	^ (self edgesFor: aVertex) size
]

{ #category : #accessing }
DCGTGraph >> edges [
	<DCAssociation: ''>
	^ edges
]

{ #category : #accessing }
DCGTGraph >> edges: aCollection [
	edges := aCollection
]

{ #category : #geometry }
DCGTGraph >> edgesFor: aVertex [
	^ self edges select: [ :each | each from = aVertex | (each to = aVertex) ]
]

{ #category : #geometry }
DCGTGraph >> edgesForAll: aVertexSet [
	^ self edges
		select: [ :each | (aVertexSet includes: each from) and: [ aVertexSet includes: each to ] ]
]

{ #category : #initialization }
DCGTGraph >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	edges := OrderedCollection new
]

{ #category : #geometry }
DCGTGraph >> neighborsOf: aVertex [
	^ (self edgesFor: aVertex)
		collect: [ :each | 
			each to = aVertex
				ifTrue: [ each from ]
				ifFalse: [ each to ] ]
]

{ #category : #accessing }
DCGTGraph >> nodes [
	<DCAssociation: ''>
	^ nodes
]

{ #category : #accessing }
DCGTGraph >> nodes: aCollection [
	nodes := aCollection
]

{ #category : #'adding/removing' }
DCGTGraph >> removeEdge: aDCGTEdge [
	(edges includes: aDCGTEdge) ifFalse: [ ^ self ].
	edges remove: aDCGTEdge
]

{ #category : #'adding/removing' }
DCGTGraph >> removeNode: aDCGTNode [
	(nodes includes: aDCGTNode) ifFalse: [ ^ self ].
	nodes remove: aDCGTNode
]

{ #category : #visualization }
DCGTGraph >> renderIn: aView [
	| b |
	b := RTMondrian new.
	b view: aView.
	b shape ellipse
		borderColor: Color gray;
		color: Color transparent;
		size: 17;
		withText: [ :node | node model ].
	b nodes: self nodes.
	b shape bezierLineFollowing: [ :node | self edgesFor: node ].
	b edges useAssociations: (self edges collect: [ :each | each from -> each to ]).
	b layout dominanceTree
		horizontalGap: 20;
		verticalGap: 100.
	b build.
	^ b view
]

{ #category : #geometry }
DCGTGraph >> vertexInducedBy: aVertexSet [
	^ self class new
		nodes: aVertexSet;
		edges: (self edgesForAll: aVertexSet);
		yourself
]

{ #category : #accessing }
DCGTGraph >> vertices [
	<DCAssociation: ''>
	^ self nodes
]

{ #category : #visualization }
DCGTGraph >> visualization [
	^ self renderIn: RTView new
]

{ #category : #visualization }
DCGTGraph >> visualize [
	self visualization open
]
