"
I am an orthogonal Connector Router as described in [1].

!! Purpose

I route edges of a graph in an orthogonal style for vertices with fixed positions while attempting to minimize the total length of the routes, number of bends and crosspoints with others edges. All while never crossing another vertex.

!! References

] [1]M. Wybrow, K. Marriott, and P. J. Stuckey, “Orthogonal connector routing,” in Graph Drawing, 2010, pp. 219–231.
"
Class {
	#name : #DCOCRouter,
	#superclass : #Object,
	#category : 'DynaCASE-Layouting-OCR'
}

{ #category : #'as yet unclassified' }
DCOCRouter class >> collinearizeRoute: aRoute [
	| newRoute direction step |
	newRoute := OrderedCollection with: aRoute first with: aRoute second.
	direction := newRoute first x = newRoute second x
		ifTrue: [ #x ]
		ifFalse: [ #y ].
	2 to: aRoute size do:
		[ :i | 
		step := aRoute at: i.
		(direction value: newRoute last) = (direction value: step)
			ifTrue: [ newRoute at: newRoute size put: step ]
			ifFalse: [ newRoute add: step.
				direction := direction = #x
					ifTrue: [ #y ]
					ifFalse: [ #x ] ] ].
	^ newRoute asArray
]

{ #category : #examples }
DCOCRouter class >> exampleRouting [
|v es router visGraph g el seg conn conn2 r1 r2 routes ordering|
v := RTView new.
v @ (RTGridView new gridSize: 5).

es := RTBox new size: #yourself; elementsOn: #(20 40 60" 40").

v addAll: es.

es @ RTDraggable.

es second translateTo: 100 @ 50.
es third translateTo: 120 @ -20.
"es fourth translateTo: 90 @ -80."

router := DCOCRouter new.
visGraph := router visibilityGraphFor: es.

g := RTGroup new.

visGraph nodes do: [ :each |
	el := RTEllipse new color: Color red; size: 2; elementOn: each.
	each element ifNotNil: [
		el shape color: Color blue.
		el update.
	].
	g add: el.
	v add: el.
	"el @ (RTLabelled new fontSize: 4; text: #model)."
	el translateTo: each model.
].

visGraph edges do: [ :each |
	seg := RTLine new
		color: Color lightRed;
		edgeFrom: (g elementFromModel: each from) to: (g elementFromModel: each to).
	v add: seg.
	seg trachelShape pushBack.
].

conn := DCRTStyledConnection new
	color: Color black;
	edgeFrom: es first to: es second.
v add: conn.

conn2 := DCRTStyledConnection new
	color: Color purple;
	edgeFrom: es first to: es third.
v add: conn2.

r1 := router
	routeFrom: (visGraph nodes detect: [:n | n model = (20@0)])
	to: (visGraph nodes detect: [:n | n model = (70@50)])
	visibility: visGraph.

r2 := router
	routeFrom: (visGraph nodes detect: [:n | n model = (0@20)])
	to: (visGraph nodes detect: [:n | n model = (80@ -20)])
	visibility: visGraph.

routes := OrderedCollection with: r1 route with: r2 route.

ordering := router orderingFor: routes.
"routes := router collinearizeRoutes: routes.
routes := router separateRoutes: routes."

router applyRoute: routes first to: conn.	
router applyRoute: routes second to: conn2.

"r2 at: 3 put: 73@20.
r2 at: 4 put: 73@0.
r2 at: 5 put: 73@ -20."

v @ RTDraggableView @ RTZoomableView.

^ v
]

{ #category : #examples }
DCOCRouter class >> exampleVisibility [
	|v es router visGraph g e seg|
v := RTView new.
v @ (RTGridView new gridSize: 10).

es := RTBox new size: #yourself; elementsOn: #(20 40 60 40).

v addAll: es.

es @ RTDraggable.

es second translateTo: 100 @ 50.
es third translateTo: 200 @ 30.
es fourth translateTo: 90 @ -80.

router := DCOCRouter new.
visGraph := router visibilityGraphFor: es.

g := RTGroup new.

visGraph nodes do: [ :each |
	e := RTEllipse new color: Color red; size: 2; elementOn: each.
	g add: e.
	v add: e.
	e translateTo: each model.
].

visGraph edges do: [ :each |
	seg := RTLine new
		color: Color lightRed;
		edgeFrom: (g elementFromModel: each from) to: (g elementFromModel: each to).
	v add: seg.
	seg trachelShape pushBack.
].

v @ RTDraggableView @ RTZoomableView.

^ v
]

{ #category : #'as yet unclassified' }
DCOCRouter >> applyRoute: aPath to: anEdge [
	anEdge shape router points: aPath.
	anEdge update.
	anEdge signalUpdate.
	anEdge view signalUpdate
]

{ #category : #'as yet unclassified' }
DCOCRouter >> collinearizeRoutes: routes [
	^ routes collect: [ :each | self class collinearizeRoute: each ]
]

{ #category : #'as yet unclassified' }
DCOCRouter >> determineRoutes: elements [

]

{ #category : #'as yet unclassified' }
DCOCRouter >> determineRoutesFor: edges [

]

{ #category : #'as yet unclassified' }
DCOCRouter >> generateSegments: aGraph boxes: boxes [
	self generateSegments: aGraph boxes: boxes fixedAxis: #x.
	self generateSegments: aGraph boxes: boxes fixedAxis: #y
]

{ #category : #'as yet unclassified' }
DCOCRouter >> generateSegments: aGraph boxes: boxes fixedAxis: anAxis [
	| fixed lines seg otherAxis |
	otherAxis := anAxis = #x
		ifTrue: [ #y ]
		ifFalse: [ #x ].
	fixed := (aGraph nodes collect: [ :each | anAxis value: each model ] as: Set) sorted.
	lines := fixed
		collect: [ :fix | aGraph nodes select: [ :each | (anAxis value: each model) = fix ] ].
	lines := lines
		collect: [ :each | each sorted: [ :a :b | (otherAxis value: a model) < (otherAxis value: b model) ] ].
	lines
		do:
			[ :line | 
			line
				overlappingPairsDo:
					[ :a :b | 
					seg := RTLineSegment from: a model to: b model.
					boxes
						detect: [ :box | (seg intersectRectangle: box) isNotEmpty ]
						ifNone: [ aGraph addEdge: (DCGTEdge from: a to: b) ] ] ]
]

{ #category : #'as yet unclassified' }
DCOCRouter >> interestingPointFor: anElement [
	"Retrieve an interesting point for an element. This are corners of the element and some fixed number of connectors (for now centres)."

	| r |
	r := anElement encompassingRectangle expandBy: 10.
	^ (r corners , (self sideCentersFor: r)) asSet
]

{ #category : #'as yet unclassified' }
DCOCRouter >> interestingPointsFor: elements [
	^ elements collect: [ :each | each -> (self interestingPointFor: each) ]
]

{ #category : #'as yet unclassified' }
DCOCRouter >> orderingFor: routes [
	| overlapGraph |
	overlapGraph := self overlapGraphFor: routes.
]

{ #category : #'as yet unclassified' }
DCOCRouter >> overlapGraphFor: routes [
	| overlapGraph nodesLookup candidates |
	overlapGraph := DCGTGraph new.
	candidates := Dictionary new.
	nodesLookup := Dictionary new.
	routes
		withIndexDo:
			[ :route :i | 
			route
				overlappingPairsDo: [ :a :b | (candidates at: (a corner: b) ifAbsentPut: [ OrderedCollection new ]) add: i ] ].
	candidates associations
		select: [ :pair | pair value size > 1 ]
		thenDo:
			[ :pair | 
			nodesLookup at: pair key origin ifAbsentPut: [ DCOCNode on: pair key origin ].
			nodesLookup at: pair key corner ifAbsentPut: [ DCOCNode on: pair key corner ].
			overlapGraph
				addEdge:
					((DCOCOverlapEdge
						from: (nodesLookup at: pair key origin)
						to: (nodesLookup at: pair key corner)) routes: pair value) ].
	overlapGraph nodes: nodesLookup values.
	^ overlapGraph
]

{ #category : #'as yet unclassified' }
DCOCRouter >> routeFor: anEdge visibility: visGraph [
	| starts ends paths |
	starts := (self sideCentersFor: (anEdge from encompassingRectangle expandBy: 10))
		collect: [ :each | visGraph nodes detect: [ :node | node model = each ] ].
	ends := (self sideCentersFor: (anEdge to encompassingRectangle expandBy: 10))
		collect: [ :each | visGraph nodes detect: [ :node | node model = each ] ].
	paths := OrderedCollection new.
	starts
		do: [ :s | ends do: [ :e | paths add: (self routeFrom: s to: e visibility: visGraph) ] ].
	^ (paths detectMin: #length) route
]

{ #category : #'as yet unclassified' }
DCOCRouter >> routeFrom: src to: dst visibility: aVisGraph [
	| queue srcEntry next reached top closed |
	queue := Heap new.
	queue
		sortBlock: [ :a :b | (a priorityFrom: src to: dst) < (b priorityFrom: src to: dst) ].
	(srcEntry := DCOCQueueEntry new)
		node: src;
		direction: (Set with: src direction).
	queue add: srcEntry.
	reached := false.
	closed := Dictionary new.
	[ reached not & queue isNotEmpty ]
		whileTrue:
			[ top := queue first.
			"self logCr: top node model -> top direction -> (top priorityFrom: src to: dst)."
			queue removeFirst.
			closed at: (Array with: top node model with: top direction) put: true.
			top node = dst
				ifTrue: [ reached := true ]
				ifFalse:
					[ (aVisGraph neighborsOf: top node)
						do:
							[ :each | 
							(next := DCOCQueueEntry new)
								parent: top;
								node: each;
								direction: (each dirnsFrom: top node).
							closed
								at: (Array with: next node model with: next direction)
								ifAbsent: [ queue add: next ] ] ] ].
	^ top
]

{ #category : #'as yet unclassified' }
DCOCRouter >> routesFor: edges visibility: visGraph [
	| routes |
	routes := edges collect: [ :each | each -> (self routeFor: each visibility: visGraph) ].
	routes do: [ :pair | self applyRoute: pair value to: pair key ]
]

{ #category : #running }
DCOCRouter >> run [
	self visibilityGraph.
	self determineRoutes.
	"self search.
	self visualRepresentation"
]

{ #category : #'as yet unclassified' }
DCOCRouter >> segmentizeRoutes: routes [
	| segments |
	segments := Dictionary new.
	routes
		withIndexDo:
			[ :route :i | 
			route
				overlappingPairsDo: [ :a :b | (segments at: a -> b ifAbsentPut: [ OrderedCollection new ]) add: i ] ].
	^ segments
]

{ #category : #'as yet unclassified' }
DCOCRouter >> separateRoutes: routes [
	| segments |
	segments := self segmentizeRoutes: routes.
	1halt.
	^ routes
]

{ #category : #'as yet unclassified' }
DCOCRouter >> sideCentersFor: aRectangle [
	^ Array
		with: aRectangle topCenter
		with: aRectangle rightCenter
		with: aRectangle bottomCenter
		with: aRectangle leftCenter
]

{ #category : #'as yet unclassified' }
DCOCRouter >> visibilityGraphFor: elements [
	| boundaries i xi yi boxes nodes graph |
	boxes := elements collect: [ :each | each encompassingRectangle expandBy: 9 ].
	boundaries := self interestingPointsFor: elements.
	i := (boundaries flatCollect: #value) asSet.
	xi := i collect: #x.
	yi := i collect: #y.
	nodes := (xi flatCollect: [ :x | yi collect: [ :y | x @ y ] ])
		select:
			[ :each | boxes detect: [ :box | box containsPoint: each ] ifFound: [ false ] ifNone: [ true ] ].
	graph := DCGTGraph new.
	graph nodes: (nodes collect: [ :each | DCOCNode on: each ]).
	graph nodes
		do:
			[ :each | 
			boundaries
				do: [ :b | b value detect: [ :bPoint | each model = bPoint ] ifFound: [ each element: b key ] ] ].
	self generateSegments: graph boxes: boxes.
	^ graph
]
