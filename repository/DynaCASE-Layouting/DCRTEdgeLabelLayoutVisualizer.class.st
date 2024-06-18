Class {
	#name : 'DCRTEdgeLabelLayoutVisualizer',
	#superclass : 'Object',
	#instVars : [
		'layouter',
		'view'
	],
	#classVars : [
		'Configuration'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayoutVisualizer class >> Configuration [
	^ Configuration ifNil: [ Configuration := self defaultConfiguration ]
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayoutVisualizer class >> defaultConfiguration [
	^ Dictionary new
		at: #edgeMarks put: true;
		at: #highlightLabels put: true;
		at: #labelPositions put: true;
		at: #overlapGraph put: false;
		at: #clusterGraphs put: false;
		at: #completeClusters put: false;
		at: #matchingGraph put: false;
		at: #index put: true;
		at: #penalty put: false;
		yourself
]

{ #category : 'as yet unclassified' }
DCRTEdgeLabelLayoutVisualizer class >> openConfiguration [
	<script>
	| ui options specLayout |
	ui := DynamicComposableModel new.
	ui title: 'Visualizer configuration'.
	options := #(#highlightLabels #edgeMarks #labelPositions #overlapGraph #clusterGraphs #completeClusters #matchingGraph).
	ui
		instantiateModels:
			(options
				flatCollect: [ :each | 
					{each.
					#CheckBoxModel} ]).
	ui
		instantiateModels: #(#positionLabels #LabelModel #index #RadioButtonModel #penalty #RadioButtonModel).
	ui widgets keys
		do:
			[ :each | 
			(ui perform: each) label: each.
			each = #positionLabels
				ifFalse:
					[ (ui perform: each)
						whenChangedDo: [ DCRTEdgeLabelLayoutVisualizer Configuration at: each put: (ui perform: each) state ] ] ].
	RadioButtonGroup new
		addRadioButton: ui index;
		addRadioButton: ui penalty;
		default:
			((DCRTEdgeLabelLayoutVisualizer Configuration at: #index)
				ifTrue: [ ui index ]
				ifFalse: [ ui penalty ]).
	DCRTEdgeLabelLayoutVisualizer Configuration
		keysAndValuesDo: [ :key :value | (ui perform: key) state: value ].
	specLayout := SpecColumnLayout new.
	ui widgets keys do: [ :each | specLayout add: each ].
	ui openWithSpecLayout: specLayout
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> addBoundingBoxFor: anElement [
	| bb |
	bb := RTBox new
		borderColor: Color red;
		color: Color transparent;
		elementOn: anElement.
	bb extent: anElement extent.
	TRConstraint stick: bb onTheCenterOf: anElement.
	view add: bb.
	bb trachelShape
		pushBehind:
			((anElement isKindOf: TRShape)
				ifTrue: [ anElement ]
				ifFalse: [ anElement trachelShape ])
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> highlightLabels [
	layouter batchOfUnassignedLabels do: [ :each | self addBoundingBoxFor: each ]
]

{ #category : 'accessing' }
DCRTEdgeLabelLayoutVisualizer >> layouter [
	^ layouter
]

{ #category : 'accessing' }
DCRTEdgeLabelLayoutVisualizer >> layouter: aLayout [
	layouter := aLayout
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showClusters: clusterGraphs labeled: aString [
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape rectangle withTextAbove: [ :m | m nodes joinUsing: '-' ].
	b
		nodes: clusterGraphs
		forEach:
			[ :graph | 
			b shape circle
				size: 20;
				color: Color white;
				withText: #index.
			b nodes: graph nodes.
			b edges shape arrowedLine withContinuousCircleAttachPoint.
			b edges useAssociations: (graph edges collect: [ :each | each from -> each to ]).
			b layout tree doNotAttachPoint; horizontalGap: 50; verticalGap: 50 ].
	b build.
	bg := RTBox new element.
	view add: bg.
	bg @ RTDraggable.
	lbl := RTLabel new
		color: Color black;
		elementOn: aString.
	view add: lbl.
	RTNest new on: bg nest: b topElements , {lbl}.
	bg trachelShape pushBack.
	bg translateBy: 0 @ 100
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showEdgeMarks: aDictionary [
	| el line normal normalSeg |
	aDictionary
		keysAndValuesDo:
			[ :edge :set | 
			line := RTLineSegment
				from: (edge shape startingPointOf: edge)
				to: (edge shape endingPointOf: edge).
			set
				do:
					[ :each | 
					normal := 4 * line vector normal.
					normalSeg := RTLineSegment from: each + normal to: each - normal.
					el := RTSVGPath new
						path:
							('M {1} {2} L {3} {4}'
								format:
									{normalSeg from x.
									normalSeg from y.
									normalSeg to x.
									normalSeg to y});
						borderColor: Color red;
						elementOn: each.
					view add: el ] ]
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showLabelPositions: aDictionary [
	| el |
	aDictionary
		keysAndValuesDo:
			[ :label :positions | 
			positions
				do:
					[ :each | 
					el := RTBox new
						color: Color transparent;
						borderColor: (Color red alpha: 0.5);
						borderStyle: #dash;
						width: each model width;
						height: each model height;
						elementOn: each index.
					el translateTo: each model center.
					view add: el.
					el @ RTLabelled new center ] ]
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showLabelPositions: aDictionary labeled: aTwoArgBlock [
	| el |
	aDictionary
		keysAndValuesDo:
			[ :label :positions | 
			positions
				do:
					[ :each | 
					el := RTBox new
						color: Color transparent;
						borderColor: (Color red alpha: 0.5);
						borderStyle: #dash;
						width: each model width;
						height: each model height;
						elementOn: (aTwoArgBlock value: each value: label).
					el translateTo: each model center.
					view add: el.
					el @ RTLabelled new center ] ]
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showMatchingGraph: aGraph labeled: aString [
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape rectangle
		withTextAbove:
			[ :m | 
			m isFeature
				ifTrue: [ m label copyFrom: 3 to: 4 ]
				ifFalse: [ m model nodes joinUsing: '-' ] ].
	b
		nodes: aGraph nodes
		forEach:
			[ :node | 
			b shape circle
				size: 20;
				color: Color white;
				withText: #index.
			node isFeature
				ifTrue: [ b nodes: #() ].
			node isCluster
				ifTrue:
					[ b nodes: node model nodes.
					b edges useAssociations: (node model edges collect: [ :each | each from -> each to ]) ].
			b layout tree ].
	b edges useAssociations: (aGraph edges collect: [ :each | each from -> each to ]).
	b layout dominanceTree horizontalGap: 30.
	b build.
	b edges shape line attachPoint: #withContinuousCircleAttachPoint.
	bg := RTBox new element.
	view add: bg.
	bg @ RTDraggable.
	lbl := RTLabel new
		color: Color black;
		elementOn: aString.
	view add: lbl.
	RTNest new on: bg nest: b topElements , {lbl}.
	bg trachelShape pushBack.
	bg translateBy: 0 @ 100
]

{ #category : 'visualization' }
DCRTEdgeLabelLayoutVisualizer >> showOverlapGraph: aGraph labeled: aString [
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape ellipse
		size: 20;
		color: Color white;
		borderColor: Color black;
		withText:
			[ :m | 
			m isFeature
				ifTrue: [ m label copyFrom: 3 to: 4 ]
				ifFalse:
					[ m isPosition
						ifTrue: [ m index ]
						ifFalse:
							[ m isCluster
								ifTrue: [ (m model collect: #label) asArray joinUsing: '-' ]
								ifFalse: [ 'unknown node' ] ] ] ].
	b nodes: aGraph nodes.
	b edges useAssociations: (aGraph edges collect: [ :each | each from -> each to ]).
	b layout tree horizontalGap: 30.
	b build.
	b edges shape attachPoint: #withContinuousRectangleAttachPoint.
	bg := RTBox new element.
	view add: bg.
	bg @ RTDraggable.
	lbl := RTLabel new
		color: Color black;
		elementOn: aString.
	view add: lbl.
	RTNest new on: bg nest: b topElements , {lbl}.
	bg trachelShape pushBack.
	bg translateBy: 0 @ 100
]

{ #category : 'accessing' }
DCRTEdgeLabelLayoutVisualizer >> view [
	^ view
]

{ #category : 'accessing' }
DCRTEdgeLabelLayoutVisualizer >> view: aView [
	view := aView
]
