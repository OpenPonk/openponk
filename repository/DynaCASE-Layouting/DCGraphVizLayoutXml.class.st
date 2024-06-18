Class {
	#name : 'DCGraphVizLayoutXml',
	#superclass : 'RTLayout',
	#instVars : [
		'directed',
		'undirected'
	],
	#category : 'DynaCASE-Layouting-GraphViz',
	#package : 'DynaCASE-Layouting',
	#tag : 'GraphViz'
}

{ #category : 'example' }
DCGraphVizLayoutXml class >> example [
	|v es a b c|
v := RTView new.
es := RTBox new width: #x; height: #y; color: Color transparent; borderColor: Color black; elementsOn: { 150 @ 20 . 40 @ 15 . 20 @ 30 }.
v addAll: es.
es @ (RTLabelled new center).

a := DCRTStyledConnection new withContinuousRectangleAttachPoint; decorate: [ :decorator | decorator arrowHead ]; color: Color black; edgeFrom: es first to: es second.
b := DCRTStyledConnection new withContinuousRectangleAttachPoint; color: Color black; edgeFrom: es second to: es third.
c := DCRTStyledConnection new withContinuousRectangleAttachPoint; color: Color black; edgeFrom: es first to: es third.

v add: a; add: b; add: c.
v edges do: [ :each | each @ DCRTConnectionHandles ].

es second translateTo: 100 @ -50.
es third translateTo: 50 @ 100.

DCGraphVizLayout new on: es directed: {a} undirected: {b . c}.

v @ RTEmptyViewContextInteraction @ RTZoomableView @ RTDraggableView.
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> addEdgesTo: gv for: els [
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
DCGraphVizLayoutXml >> addNodesTo: gv for: els [
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
DCGraphVizLayoutXml >> applyLayout: aCollection to: els [
	aCollection
		collect: [ :each | (els at: (self nodeIndexFor: each)) translateTo: (self nodePositionFor: each) ]
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> applyLayoutToEdges: aCollection [
	| allEdges |
	allEdges := directed , undirected.
	aCollection
		do:
			[ :each | 
			| c e |
			e := allEdges at: (self indexFor: each).
			c := Color random.
			e shape router points: (self edgeLayoutToRoute: each).
			(self edgeLayoutToRoute: each)
				do:
					[ :p | 
					allEdges anyOne view
						add:
							((RTEllipse new
								color: c;
								element) translateTo: p) ].
			e
				update;
				signalUpdate ].
	allEdges ifNotEmpty: [ allEdges anyOne view signalUpdate ]
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> createEmptyGraph [
	| gv |
	(gv := GraphViz new)
		beDirected;
		add: #graph with: {(#splines -> #ortho)};
		add: #node
			with:
			{(#shape -> #box).
			(#fixedsize -> true)}.
	^ gv
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> createGraphFor: els [

]

{ #category : 'hook' }
DCGraphVizLayoutXml >> doExecute: els [
	| gv group layout |
	gv := self createEmptyGraph.
	group := els asGroup.
	self addNodesTo: gv for: els.
	self addEdgesTo: gv for: group.
	"1halt."
	"gv openInWindow."
	layout := gv asXml.
	self applyLayout: layout // #node to: group.
	self applyLayoutToEdges: layout // #edge
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> edgeLayoutToRoute: anEdge [
	^ "DCOCRouter
		collinearizeRoute:"
			(((anEdge xPath: 'attr[@name="pos"]') first contentString splitOn: ' ')
				collect: [ :each | self positionFrom: each ])
]

{ #category : 'converting' }
DCGraphVizLayoutXml >> inchToPixel: aNumber [
	^ aNumber * 96
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> indexFor: aNodeOrEdge [
	^ (aNodeOrEdge xPath: 'attr[@name="id"]') first contentString allButFirst asNumber
]

{ #category : 'initialize-release' }
DCGraphVizLayoutXml >> initialize [
	super initialize.
	directed := #().
	undirected := #()
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> nodeIndexFor: aNode [
	^ (aNode xPath: 'attr[@name="id"]') first contentString allButFirst asNumber
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> nodePositionFor: aNode [
	^ self positionFrom: (aNode xPath: 'attr[@name="pos"]') first contentString
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> on: el directed: directedEdges undirected: undirectedEdges [
	directed := directedEdges.
	undirected := undirectedEdges.
	^ self applyOn: el
]

{ #category : 'converting' }
DCGraphVizLayoutXml >> pixelToInch: aNumber [
	^ (aNumber / 96) asFloat
]

{ #category : 'converting' }
DCGraphVizLayoutXml >> pointToPixel: aNumber [
	^ aNumber * 96
]

{ #category : 'hook' }
DCGraphVizLayoutXml >> positionFrom: aStringPair [
	| pos |
	pos := ((aStringPair beginsWith: 'e,')
		ifTrue: [ aStringPair allButFirst: 2 ]
		ifFalse: [ aStringPair ]) splitOn: ','.
	^ pos first asNumber @ pos second asNumber
]
