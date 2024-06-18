Class {
	#name : 'DCGraphVizLayout',
	#superclass : 'RTLayout',
	#instVars : [
		'directed',
		'undirected'
	],
	#category : 'DynaCASE-Layouting-GraphViz',
	#package : 'DynaCASE-Layouting',
	#tag : 'GraphViz'
}

{ #category : 'hook' }
DCGraphVizLayout >> addEdgesTo: gv for: els [
	directed
		withIndexDo:
			[ :each :i | 
			gv
				add: (els indexOf: each from) -> (els indexOf: each to)
				with:
					{(#dir -> #forward).
					(#id -> (#E , i asString))} ].
	undirected
		withIndexDo:
			[ :each :i | 
			gv
				add: (els indexOf: each from) -> (els indexOf: each to)
				with:
					{(#dir -> #none).
					(#id -> (#E , (directed size + i) asString))} ]
]

{ #category : 'hook' }
DCGraphVizLayout >> addNodesTo: gv for: els [
	els
		withIndexDo:
			[ :each :i | 
			gv
				add: i asString
				with:
					{(#id -> (#N , i asString)).
					(#width -> (self pixelToInch: each width)).
					(#height -> (self pixelToInch: each height))} ]
]

{ #category : 'hook' }
DCGraphVizLayout >> applyLayout: aCollection to: els [
	aCollection
		collect: [ :each | (els at: (self nodeIndexFor: each)) translateTo: (self nodePositionFor: each) ]
]

{ #category : 'hook' }
DCGraphVizLayout >> applyLayoutToEdges: aCollection [
	| allEdges |
	allEdges := directed , undirected.
	aCollection
		do:
			[ :each | 
			| c e |
			e := allEdges at: (self indexFor: each).
			c := Color random.
			e shape router points: (self edgeLayoutToRoute: each) allButFirst allButLast.
			"(self edgeLayoutToRoute: each)
				do:
					[ :p | 
					allEdges anyOne view
						add:
							((RTEllipse new
								color: c;
								element) translateTo: p) ]."
			e
				update;
				signalUpdate ].
	allEdges ifNotEmpty: [ allEdges anyOne view signalUpdate ]
]

{ #category : 'hook' }
DCGraphVizLayout >> createEmptyGraph [
	| gv |
	(gv := GraphViz new)
		beDirected;
		add: #graph with: {(#splines -> #ortho).#ranksep -> 1. #nodesep -> 1};
		add: #node
			with:
			{(#shape -> #box).
			(#fixedsize -> true)}.
	^ gv
]

{ #category : 'hook' }
DCGraphVizLayout >> doExecute: els [
	| gv group layout |
	gv := self createEmptyGraph.
	group := els asGroup.
	self addNodesTo: gv for: els.
	self addEdgesTo: gv for: group.
"	1halt.
	gv generator dotSourceWithLineFeedTerminators "
	"gv openInWindow."
	layout := XMLDOMParser parse: (gv asOutputType: 'svg').
	self applyLayout: (layout xPath: '//g[@class="node"]') to: group.
	self applyLayoutToEdges: (layout xPath: '//g[@class="edge"]')
]

{ #category : 'hook' }
DCGraphVizLayout >> edgeLayoutToRoute: anEdge [
	^ DCOCRouter
		collinearizeRoute:
			((ASPathConverter new stream: ((anEdge // #path) first attributeAt: #d) readStream)
				convertPathData flatCollect: #second)
]

{ #category : 'converting' }
DCGraphVizLayout >> inchToPixel: aNumber [
	^ aNumber * 72
]

{ #category : 'hook' }
DCGraphVizLayout >> indexFor: aNodeOrEdge [
	^ (aNodeOrEdge attributeAt: #id) allButFirst asNumber
]

{ #category : 'initialize-release' }
DCGraphVizLayout >> initialize [
	super initialize.
	directed := #().
	undirected := #()
]

{ #category : 'hook' }
DCGraphVizLayout >> nodeIndexFor: aNode [
	^ (aNode attributeAt: #id) allButFirst asNumber
]

{ #category : 'hook' }
DCGraphVizLayout >> nodePositionFor: aNode [
	| corners |
	corners := (((aNode / #polygon) first attributeAt: #points) splitOn: ' ')
		collect: [ :each | self positionFrom: each ].
	^ (corners min corner: corners max) center
]

{ #category : 'hook' }
DCGraphVizLayout >> on: el directed: directedEdges undirected: undirectedEdges [
	directed := directedEdges.
	undirected := undirectedEdges.
	^ self applyOn: el
]

{ #category : 'converting' }
DCGraphVizLayout >> pixelToInch: aNumber [
	^ (aNumber / 72.0) asFloat
]

{ #category : 'converting' }
DCGraphVizLayout >> pointToPixel: aNumber [
	^ aNumber * 96
]

{ #category : 'hook' }
DCGraphVizLayout >> positionFrom: aStringPair [
	| pos |
	pos := aStringPair splitOn: ','.
	^ pos first asNumber @ pos second asNumber
]
