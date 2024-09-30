Class {
	#name : 'DCRTEdgeLabelLayout',
	#superclass : 'RTEdgeDrivenLayout',
	#instVars : [
		'labels',
		'assignedLabels',
		'unassignedLabels',
		'withVisualization',
		'withProgressBar',
		'visualizer',
		'spacing',
		'edgeForLabel',
		'elements',
		'labelForEdge',
		'labelsStrategy',
		'labelToEdgeMapping',
		'preferences'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'examples' }
DCRTEdgeLabelLayout class >> example [
|v es edges lines utils edgeLabels|
utils := DCLayoutUtils new.
v := RTView new.
v @ RTDraggableView.
v @ RTZoomableView.

es := RTBox new size: 30; elementsOn: #(A B C D E F).
v addAll: es.
es do: [ :each | |lbl|
	lbl := RTLabel new color: Color black; elementOn: each model.
	TRConstraint stick: lbl onTheCenterOf: each.
	v add: lbl.
].
"es @ RTDraggable."

lines := {
	{ #A -> #B . '' }.
	{ #B -> #C . '(+)' }.
	{ #B -> #C . '(-)' }.
	{ #B -> #D . 'd' }.
	{ #B -> #E . '(·)' }.
	{ #C -> #D . 'd' }.
	{ #C -> #E . '(·)' }.
	{ #D -> #E . '·' }.
	{ #E -> #F . 'd' }.
}.

edgeLabels := OrderedCollection new.

edges := (lines collect: [ :each | |e lbl|
	e := RTArrowedLine new
		color: Color black;
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: (es elementFromModel: each first key)
		to: (es elementFromModel: each first value).
	e model: each second.
	v add: e.
	lbl := RTLabel new color: Color blue; text: [ :model | model model ]; elementOn: e.
	TRConstraint 
							stick: lbl 
							between: e from trachelShape 
							and: e to trachelShape
							offset: 0.5. 
	v add: lbl.
	edgeLabels add: lbl.
	e.
]) asGroup.

RTDominanceTreeLayout new
	doNotAttachPoint;
	horizontalGap: 100;
	verticalGap: 50;
	on: es.

(es elementFromModel: #C) translateBy: 150 @ -80.

DCRTEdgeLabelLayout new
	labels: edgeLabels;
	withVisualization;
"	labels: {edgeLabels last};"
	on: es edges: edges.
	
v canvas camera focusOnCenterScaled: (521.0@700.0).

^ v
]

{ #category : 'examples' }
DCRTEdgeLabelLayout class >> example2 [
|v es edges lines utils edgeLabels|
utils := DCLayoutUtils new.
v := RTView new.
v @ RTDraggableView.
v @ RTZoomableView.

es := RTBox new size: 30; elementsOn: #(A B).
v addAll: es.
es do: [ :each | |lbl|
	lbl := RTLabel new color: Color black; elementOn: each model.
	TRConstraint stick: lbl onTheCenterOf: each.
	v add: lbl.
].
"es @ RTDraggable."

lines := {
	{ #A -> #B . 'XX' }.
}.

edgeLabels := OrderedCollection new.

edges := (lines collect: [ :each | |e lbl|
	e := RTArrowedLine new
		color: Color black;
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: (es elementFromModel: each first key)
		to: (es elementFromModel: each first value).
	e model: each second.
	v add: e.
	lbl := RTLabel new color: Color blue; text: [ :model | model model ]; elementOn: e.
	TRConstraint 
							stick: lbl 
							between: e from trachelShape 
							and: e to trachelShape
							offset: 0.5. 
	v add: lbl.
	edgeLabels add: lbl.
	e.
]) asGroup.

(es elementFromModel: #B) translateBy: 150 @ 0.

DCRTEdgeLabelLayout new
	spacing: 90;
	labels: edgeLabels;
	withVisualization;
"	labels: {edgeLabels last};"
	on: es edges: edges.
	
v canvas camera focusOnCenterScaled: (450.0@700.0).

^ v
]

{ #category : 'examples' }
DCRTEdgeLabelLayout class >> exampleClusters [
|v es edges lines utils edgeLabels|
utils := DCLayoutUtils new.
v := RTView new.
v @ RTDraggableView.
v @ RTZoomableView.

es := RTBox new size: 30; elementsOn: #(B C D).
v addAll: es.
es do: [ :each | |lbl|
	lbl := RTLabel new color: Color black; elementOn: each model.
	TRConstraint stick: lbl onTheCenterOf: each.
	v add: lbl.
].
"es @ RTDraggable."

lines := {
	{ #B -> #C . 'alpha' }.
	{ #B -> #D . 'beta' }.
	{ #C -> #D . 'gamma' }.
}.

edgeLabels := OrderedCollection new.

edges := (lines collect: [ :each | |e lbl|
	e := RTArrowedLine new
		color: Color black;
		attachPoint: RTRectangleAttachPoint new;
		edgeFrom: (es elementFromModel: each first key)
		to: (es elementFromModel: each first value).
	e model: each second.
	v add: e.
	lbl := RTLabel new color: Color blue; text: [ :model | model model ]; elementOn: e.
	TRConstraint 
							stick: lbl 
							between: e from trachelShape 
							and: e to trachelShape
							offset: 0.5. 
	v add: lbl.
	edgeLabels add: lbl.
	e.
]) asGroup.

RTDominanceTreeLayout new
	doNotAttachPoint;
	horizontalGap: 100;
	verticalGap: 50;
	on: es.

(es elementFromModel: #C) translateBy: 150 @ -80.

DCRTEdgeLabelLayout new
	spacing: 70;
	labels: edgeLabels;
	withVisualization;
"	labels: {edgeLabels last};"
	on: es edges: edges.
	
v canvas camera focusOnCenterScaled: (521.0@700.0).

^ v
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> allEdgeMarks [
	^ (self edges collect: [ :each | each -> (self edgeMarksFor: each) ]) as: OrderedDictionary
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> applyAssignment: aDictionary [
	aDictionary
		keysAndValuesDo:
			[ :feature :position | (self labelForEdge: feature model) translateTo: position center ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> batchOfUnassignedLabels [
	^ self edges collect: [ :e | self labelForEdge: e ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> clusterGraphsFor: anOverlapGraph [
	| clusters graph |
	clusters := self clustersFor: anOverlapGraph.
	^ clusters
		collect:
			[ :cluster | 
			graph := MalGraphStructure new.
			graph addNodes: cluster.
			cluster
				do:
					[ :node | 
					((anOverlapGraph neighborNodesOf: node) select: [:each | cluster includes: each ])
						do:
							[ :neighbor | 
							graph edges
								detect: [ :edge | edge from = neighbor & (edge to = node) ]
								ifNone: [ graph addEdge: (DCRTLEdge with: 'P to P' from: node to: neighbor) ] ] ].
			graph ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> clustersFor: anOverlapGraph [
	| classGraph clusters |
	(classGraph := MalGraphStructure new).
	anOverlapGraph nodes
		select: #isPosition
		thenDo:
			[ :node | 
			classGraph
				addNode:
					(DCRTLPositionNode new
						model: node model;
						index: node index;
						yourself) ].
	anOverlapGraph edges
		select: [ :edge | edge from isPosition & edge to isPosition ]
		thenDo:
			[ :edge | 
			classGraph
				addEdge:
					(DCRTLEdge
						with: edge model
						from: (classGraph findNode: edge from model)
						to: (classGraph findNode: edge to model)) ].
	clusters := OrderedDictionary new.
	classGraph nodes do: [ :node | clusters at: node put: {node} asOrderedCollection ].
	classGraph nodes
		do:
			[ :node | 
			(classGraph neighborNodesOf: node)
				do:
					[ :neighbor | 
					(clusters at: node) addAll: ((clusters at: neighbor) copyWithoutAll: (clusters at: node)).
					clusters at: neighbor put: (clusters at: node) ] ].
	^ ((clusters values asOrderedCollection do: #removeDuplicates) collect: #asArray)
		removeDuplicates asArray
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> completeClusterFor: aGraph [
	| degrees removed |
	(self isComplete: aGraph)
		ifTrue: [ ^ {aGraph} ].
	degrees := aGraph nodes collect: [ :node | node -> (aGraph neighborNodesOf: node) size ].
	removed := (degrees detectMax: #value) key.
	aGraph edges removeAllSuchThat: [ :edge | edge from = removed | (edge to = removed) ].
	aGraph nodes remove: removed.
	^ self completeClustersFor: (self clusterGraphsFor: aGraph)
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> completeClustersFor: clusterGraphs [
	^ clusterGraphs flatCollect: [ :each | self completeClusterFor: each ]
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> costForFeature: aFeatureNode cluster: aClusterNode edges: matchingGraph [
	^ matchingGraph edges
		detect: [ :e | e from = aFeatureNode & (e to = aClusterNode) ]
		ifFound:
			[ :e | 
			(e to model nodes
				select: [ :positionNode | positionNode model feature = (self labelForEdge: aFeatureNode model) ]
				thenCollect:
					[ :positionNode | 
					(self penaltyForRanking: positionNode model of: aFeatureNode model)
						+ (self penaltyForProximity: positionNode model of: aFeatureNode model)
						+ (self penaltyForOrientation: positionNode model of: aFeatureNode model) ]) min ]
		ifNone: [ Float infinity ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> defaultSpacing [
	^ 30
]

{ #category : 'hook' }
DCRTEdgeLabelLayout >> doExecute: elementsCollection [
	| action |
	action := [ withVisualization
		ifTrue: [ self doExecuteVisualized: elementsCollection ]
		ifFalse: [ self doExecuteNormal: elementsCollection ] ].
	withProgressBar
		ifTrue: [ action asJob run ]
		ifFalse: [ action value ]
]

{ #category : 'hook' }
DCRTEdgeLabelLayout >> doExecuteNormal: elementsCollection [
	| edgeMarks positions overlapGraph clusterGraphs completeClusters matchingGraph assignment |
	elements := elementsCollection.
	edgeMarks := self allEdgeMarks.
	positions := self initialPositions.
	positions := self removeFeatureOverlaps: positions.
	positions := self indexPositions: positions.
	overlapGraph := self overlapGraphFor: positions.
	clusterGraphs := self clusterGraphsFor: overlapGraph.
	completeClusters := self completeClustersFor: clusterGraphs.
	matchingGraph := self matchingGraphFor: overlapGraph classes: completeClusters.
	assignment := self findAssignmentFor: matchingGraph.
	self applyAssignment: assignment.
	assignedLabels addAll: self batchOfUnassignedLabels.
	unassignedLabels removeAll: self batchOfUnassignedLabels.
	unassignedLabels ifNotEmpty: [ self doExecute: elementsCollection ]
]

{ #category : 'hook' }
DCRTEdgeLabelLayout >> doExecuteVisualized: elementsCollection [
	| edgeMarks positions overlapGraph clusterGraphs completeClusters matchingGraph assignment conf |
	conf := visualizer class Configuration.
	elements := elementsCollection.
	visualizer view: self edges anyOne view.
	(conf at: #highlightLabels)
		ifTrue: [ visualizer highlightLabels ].
	edgeMarks := self allEdgeMarks.
	(conf at: #edgeMarks)
		ifTrue: [ visualizer showEdgeMarks: edgeMarks ].
	positions := self initialPositions.
	positions := self removeFeatureOverlaps: positions.
	positions := self indexPositions: positions.
	(conf at: #labelPositions)
		ifTrue:
			[ visualizer
				showLabelPositions: positions
				labeled:
					((conf at: #index)
						ifTrue: [ [ :posNode :label | posNode index ] ]
						ifFalse:
							[ [ :posNode :label | 
							(self penaltyForRanking: posNode model of: (self edgeForLabel: label)) asString , '|'
								,
									(self penaltyForEdgeProximity: posNode model of: (self edgeForLabel: label)) rounded
										asString , '/'
								,
									(self penaltyForElementProximity: posNode model of: (self edgeForLabel: label)) rounded
										asString ] ]) ].
	overlapGraph := self overlapGraphFor: positions.
	(conf at: #overlapGraph)
		ifTrue: [ visualizer showOverlapGraph: overlapGraph labeled: 'Overlap Graph' ].
	clusterGraphs := self clusterGraphsFor: overlapGraph.
	(conf at: #clusterGraphs)
		ifTrue: [ visualizer showClusters: clusterGraphs labeled: 'Clusters' ].
	completeClusters := self completeClustersFor: clusterGraphs.
	(conf at: #completeClusters)
		ifTrue: [ visualizer showClusters: completeClusters labeled: 'Complete Clusters' ].
	matchingGraph := self matchingGraphFor: overlapGraph classes: completeClusters.
	(conf at: #matchingGraph)
		ifTrue: [ visualizer showMatchingGraph: matchingGraph labeled: 'Matching Graph' ].
	assignment := self findAssignmentFor: matchingGraph.
	self applyAssignment: assignment.
	assignedLabels addAll: self batchOfUnassignedLabels.
	unassignedLabels removeAll: self batchOfUnassignedLabels.
	unassignedLabels ifNotEmpty: [ self doExecuteVisualized: elementsCollection ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> edgeForLabel: aLabel [
	^ edgeForLabel cull: aLabel cull: self
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> edgeForLabelStrategy: aTwoArgBlock [
	edgeForLabel := aTwoArgBlock
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> edgeMarksFor: anEdge [
	| line angle direction |
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	angle := line vector angle.
	direction := angle cos @ angle sin.
	^ ((OrderedCollection with: line from + (15 * direction))
		,
			((1 to: line length / self spacing)
				collect: [ :i | line from + (i * self spacing * direction) ])
		, {(line to - (15 * direction))} collect: [ :each | each rounded ]) removeDuplicates
		asArray
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> elements [
	^ elements , assignedLabels
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> elements: aCollection [
	elements := aCollection
]

{ #category : 'hook' }
DCRTEdgeLabelLayout >> findAssignmentFor: aMatchingGraph [
	| matrix features clusters solver solution assignment |
	features := aMatchingGraph nodes select: #isFeature.
	clusters := aMatchingGraph nodes select: #isCluster.
	matrix := Matrix
		rows: features size
		columns: clusters size
		tabulate:
			[ :i :j | self costForFeature: (features at: i) cluster: (clusters at: j) edges: aMatchingGraph ].
	solver := DCRTLHungarianSolver new.
	solution := solver paddedSolve: matrix.
	assignment := (solution collect: #key)
		collect:
			[ :indices | 
			| feature cluster |
			feature := features at: indices first.
			cluster := clusters at: indices second.
			feature
				->
					(((cluster model nodes collect: #model)
						select: [ :pos | pos feature = (self labelForEdge: feature model) ])
						detectMin:
							[ :position | 
							(self penaltyForRanking: position of: feature model)
								+ (self penaltyForProximity: position of: feature model) ]) ].
	^ assignment asDictionary
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> indexPositions: aDictionary [
	"assign each position a globally (within the view) unique ID so it can be tracked later"

	| indexed i |
	indexed := OrderedDictionary new.
	i := 0.
	aDictionary
		keysAndValuesDo:
			[ :label :positions | 
			indexed
				at: label
				put:
					(positions asArray
						collect:
							[ :each | 
							i := i + 1.
							DCRTLPositionNode new
								model: each;
								index: i;
								yourself ]) ].
	^ indexed
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> initialPositions [
	^ (self batchOfUnassignedLabels
		collect: [ :each | each -> (self initialPositionsFor: each) ]) as: OrderedDictionary
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> initialPositionsFor: aLabel [
	| marks size w h extent |
	extent := aLabel extent.
	marks := self edgeMarksFor: (self edgeForLabel: aLabel).
	size := marks size.
	w := aLabel encompassingRectangle width / 2.
	h := aLabel encompassingRectangle height / 2.
	"all positions are moved by a 1@1 point to simplify overlap computing"
	^ (marks
		withIndexCollect:
			[ :each :i | 
			{(DCRTLPosition new
				orientation: #topRight;
				feature: aLabel;
				ranking: i of: size;
				mark: each;
				position: each + (w @ h negated) + (1 @ 1 negated)).
			(DCRTLPosition new
				ranking: i of: size;
				feature: aLabel;
				orientation: #bottomRight;
				mark: each;
				position: each + (w @ h) + (1 @ 1)).
			(DCRTLPosition new
				orientation: #bottomLeft;
				feature: aLabel;
				ranking: i of: size;
				mark: each;
				position: each + (w negated @ h) + (1 negated @ 1)).
			(DCRTLPosition new
				orientation: #topLeft;
				ranking: i of: size;
				feature: aLabel;
				mark: each;
				position: each - (w @ h) - (1 @ 1))} ]) flatten
		collect: [ :each | each bounds: ((each position corner: each position) expandBy: extent / 2) ]
]

{ #category : 'initialize-release' }
DCRTEdgeLabelLayout >> initialize [
	super initialize.
	labels := nil.
	visualizer := DCRTEdgeLabelLayoutVisualizer new layouter: self.
	spacing := self defaultSpacing.
	edgeForLabel := [ :label :me | label model ].
	labelForEdge := [ :edge :me | unassignedLabels detect: [ :label | label model = edge ] ].
	withProgressBar := false.
	withVisualization := false.
	labelsStrategy := [ :edge |  ].
	preferences := Dictionary new
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> isComplete: aGraph [
	"|E| = |N|*(|N|-1)/2"

	^ aGraph edges size = (aGraph nodes size * (aGraph nodes size - 1) / 2)
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> labelForEdge: anEdge [
	^ labelForEdge cull: anEdge cull: self
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> labelForEdgeStrategy: aTwoArgBlock [
	^ labelForEdge := aTwoArgBlock
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> labelToEdgeMapping: aDictionary [
	labelToEdgeMapping := aDictionary.
	self edgeForLabelStrategy: [ :label :me | labelToEdgeMapping at: label ].
	self
		labelForEdgeStrategy:
			[ :edge :me | 
			((labelToEdgeMapping associations select: [ :pair | pair value = edge ]) collect: #key)
				detect: [ :lbl | unassignedLabels includes: lbl ] ]
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> labels [
	^ labels ifNil: [ labels := self edges collect: labelsStrategy thenReject: #isNil ]
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> labels: aCollection [
	labels := aCollection.
	unassignedLabels := aCollection asOrderedCollection.
	assignedLabels := OrderedCollection new
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> labelsStrategy: aBlock [
	labelsStrategy := aBlock
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> matchingGraphFor: anOverlapGraph classes: clusterGraphs [
	| matchingGraph clusterNode |
	matchingGraph := MalGraphStructure new.
	anOverlapGraph nodes select: #isFeature thenDo: [ :node | matchingGraph addNode: node ].
	clusterGraphs
		do:
			[ :each | 
			clusterNode := DCRTLClusterNode with: each.
			matchingGraph addNode: clusterNode.
			each nodes
				do:
					[ :node | 
					((anOverlapGraph neighborNodesOf: node) select: #isFeature)
						do:
							[ :feature | 
							matchingGraph edges
								detect: [ :edge | edge from = feature & (edge to = clusterNode) ]
								ifNone:
									[ matchingGraph addEdge: (DCRTLEdge with: 'F to C' from: feature to: clusterNode) ] ] ] ].
	^ matchingGraph
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> overlapGraphFor: aDictionary [
	| graph oldGraph positions added |
	(graph := MalGraphStructure new) edgeClass: MalGraphEdge.
	oldGraph := DCRTLBipartiteGraph new.
	positions := OrderedCollection new.
	aDictionary
		keysAndValuesDo:
			[ :label :positionNodes | 
			| e featureNode |
			e := self edgeForLabel: label.
			featureNode := DCRTLFeatureNode with: e.
			graph addNode: featureNode.
			graph addNodes: positionNodes.
			positions addAll: positionNodes.
			positionNodes
				do:
					[ :node | graph addEdge: (DCRTLEdge with: 'F to L' from: featureNode to: node) ] ].
	added := Set new.
	positions
		do:
			[ :a | 
			positions
				select: [ :b | a ~= b & (a model bounds intersects: b model bounds) & (added includes: b -> a) not ]
				thenDo:
					[ :b | 
					graph addEdge: (DCRTLEdge with: 'L to L' from: a to: b).
					added add: a -> b ] ].
	^ graph
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> penaltyForEdgeProximity: aPosition of: anEdge [
	| line closestAnotherDistance edgeDistance from to |
	from := [ :e | e shape startingPointOf: e ].
	to := [ :e | e shape endingPointOf: e ].
	line := RTLineSegment from: (from value: anEdge) to: (to value: anEdge).
	closestAnotherDistance := ((edges copyWithout: anEdge)
		collect:
			[ :each | 
			(aPosition bounds nearestDistanceToLineFrom: (from value: each) to: (to value: each))
				rounded ]) ifEmpty: [ -1000 ] ifNotEmpty: [ :c | c min ].
	edgeDistance := (aPosition bounds nearestDistanceToLineFrom: line from to: line to)
		rounded.
	^ 11 - closestAnotherDistance rounded max: 0
	"^ closestAnotherDistance > 10
		ifTrue: [ 0 ]
		ifFalse: [ 1.5 ]"
	"^ closestAnotherDistance > 0
		ifTrue: [ edgeDistance / closestAnotherDistance ]
		ifFalse: [ 1 ]"
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> penaltyForElementProximity: aPosition of: anEdge [
	| closestDistance |
	closestDistance := (elements
		collect: [ :each | aPosition bounds nearestDistanceTo: each encompassingRectangle ]) min.
	^ 11 - closestDistance rounded max: 0
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> penaltyForOrientation: aPosition of: anEdge [
	self preferences
		at: aPosition feature
		ifPresent:
			[ :val | 
			val second = #top
				ifTrue:
					[ aPosition orientation = #topLeft | (aPosition orientation = #topRight)
						ifTrue: [ ^ 0 ]
						ifFalse: [ ^ 4 ] ].
			val second = #bottom
				ifTrue:
					[ aPosition orientation = #bottomLeft | (aPosition orientation = #bottomRight)
						ifTrue: [ ^ 0 ]
						ifFalse: [ ^ 4 ] ] ]
		ifAbsent: [ ^ 0 ]
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> penaltyForProximity: aPosition of: anEdge [
	| p1 p2 |
	p1 := self penaltyForEdgeProximity: aPosition of: anEdge.
	p2 := self penaltyForElementProximity: aPosition of: anEdge.
	^ p1 max: p2
]

{ #category : 'cost' }
DCRTEdgeLabelLayout >> penaltyForRanking: aPosition of: anEdge [
	self preferences
		at: aPosition feature
		ifPresent:
			[ :pref | 
			pref first = #min
				ifTrue: [ ^ aPosition ranking ].
			pref first = #max
				ifTrue: [ ^ aPosition maxRanking - aPosition ranking ] ]
		ifAbsent: [ ^ aPosition ranking ]
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> preferences [
	^ preferences
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> preferences: aDictionary [
	preferences := aDictionary
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> removeFeatureOverlaps: aDictionary [
	"Remove all positions overlapping another edge or element, but not label."

	| newMap |
	newMap := OrderedDictionary new.
	aDictionary
		keysAndValuesDo:
			[ :label :positions | newMap at: label put: (self removeFeatureOverlapsFor: label positions: positions) ].
	^ newMap
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> removeFeatureOverlapsFor: aLabel positions: aCollection [
	"Remove all positions overlapping another edge or element, but not label."

	| extent rectangles otherLines e segment |
	extent := aLabel extent.
	rectangles := aCollection.
	"Remove positions overlapping any elements"
	rectangles := rectangles
		reject:
			[ :rect | 
			self elements
				detect: [ :el | el encompassingRectangle intersects: rect bounds ]
				ifFound: [ true ]
				ifNone: [ false ] ].
	"Remove positions overlapping other edges"
	otherLines := self edges
		reject: [ :edge | edge = (self edgeForLabel: aLabel) ]
		thenCollect:
			[ :edge | RTLineSegment from: (edge shape startingPointOf: edge) to: (edge shape endingPointOf: edge) ].
	rectangles := rectangles
		reject:
			[ :rect | 
			otherLines
				detect: [ :line | (line intersectRectangle: rect bounds) isNotEmpty ]
				ifFound: [ true ]
				ifNone: [ false ] ].
	"Remove positions overlapping it's own line"
	e := self edgeForLabel: aLabel.
	segment := RTLineSegment from: (e shape startingPointOf: e) to: (e shape endingPointOf: e).
	rectangles := rectangles
		reject: [ :rect | ((segment intersectRectangle: rect bounds) collect: #rounded) isNotEmpty ].
	^ rectangles
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> spacing [
	^ spacing
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> spacing: aNumber [
	spacing := aNumber
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayout >> withProgressBar [
	withProgressBar := true
]

{ #category : 'accessing' }
DCRTEdgeLabelLayout >> withVisualization [
	withVisualization := true
]
