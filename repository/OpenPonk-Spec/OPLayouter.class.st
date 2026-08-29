"
I am base class for layouters to see what commonalities they have and should be eventually extracted up to OpenPonk.
"
Class {
	#name : 'OPLayouter',
	#superclass : 'Object',
	#instVars : [
		'diagramController'
	],
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'userinterface' }
OPLayouter class >> supportedLayoutCommands [
	^ {OPDominanceTreeLayoutCommand.
	OPGridLayoutCommand.
	OPSugiyamaLayoutCommand.
	OPTreeLayoutCommand}
]

{ #category : 'userinterface' }
OPLayouter class >> supports: aLayoutCommand [
	^ self supportedLayoutCommands includes: aLayoutCommand
]

{ #category : 'accessing' }
OPLayouter >> allEdges [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPLayouter >> allNodes [
	^ self subclassResponsibility
]

{ #category : 'userinterface' }
OPLayouter >> applyLayout: aTwoArgBlock [

	self basicApplyLayout: aTwoArgBlock
]

{ #category : 'userinterface' }
OPLayouter >> basicApplyLayout: aTwoArgBlock [

	| selectedBoxes allNodes nodes allEdges edges isPartialLayout oldEncompassingRectangle newEncompassingRectangle |
	selectedBoxes := diagramController canvasPresenter selectedElements.
	isPartialLayout := selectedBoxes size > 1.
	allNodes := self allNodes.
	nodes := RSGroup withAll: (isPartialLayout
			          ifTrue: [ allNodes intersection: selectedBoxes ]
			          ifFalse: [ allNodes ]).
	allEdges := self allEdges reject: [ :each | each to = each from ].
	edges := (allEdges select: [ :each |
		          (nodes includes: each from) & (nodes includes: each to) ])
		         asGroup.
	oldEncompassingRectangle := nodes encompassingRectangle.
	aTwoArgBlock value: nodes value: edges.
	newEncompassingRectangle := nodes encompassingRectangle.
	isPartialLayout
		ifTrue: [
			nodes translateTo: oldEncompassingRectangle center.
			diagramController canvas signalUpdate ]
		ifFalse: [ self updateCanvas ]
]

{ #category : 'layouts' }
OPLayouter >> circleLayout [
	self
		applyLayout: [ :boxes :links | 
			RSWeightedCircleLayout new
				scaleBy: 20;
				on: boxes ]
]

{ #category : 'layouts' }
OPLayouter >> defaultLayout [
	self subclassResponsibility
]

{ #category : 'accessing' }
OPLayouter >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : 'layouts' }
OPLayouter >> dominanceTreeLayout [

	self applyLayout: [ :boxes :links |
		(OPLayoutLoopDetector popupHaveLoopsBoxes: boxes links: links)
			ifTrue: [ ^ self gridLayout ].
		RSDominanceTreeLayout new
			verticallyReverse;
			verticalGap: 100;
			horizontalGap: 100;
			on: boxes edges: links ]
]

{ #category : 'layouts' }
OPLayouter >> gridLayout [

	self applyLayout: [ :boxes :links | 
		RSGridLayout new
			gapSize: 140;
			on: boxes ]
]

{ #category : 'accessing' }
OPLayouter >> roassalShapesFor: aCollection [

	^ ((aCollection collect: [ :model |
		    diagramController controllers
			    detect: [ :each | each model = model ]
			    ifFound: #roassalShape
			    ifNone: [ nil ] ]) reject: #isNil) asGroup
]

{ #category : 'layouts' }
OPLayouter >> sugiyamaLayout [

	self applyLayout: [ :boxes :links |
			| centerY |
			(OPLayoutLoopDetector popupHaveLoopsBoxes: boxes links: links)
				ifTrue: [ ^ self gridLayout ].
			RSSugiyamaLayout new
				verticalGap: 100;
				horizontalGap: 100;
				on: boxes edges: links.
			centerY := (RSGroup withAll: boxes) encompassingRectangle center y.
			boxes do: [ :each |
				each translateBy: 0 @ 2 * (centerY - each position y) ] ]
]

{ #category : 'userinterface' }
OPLayouter >> supports: aLayoutCommand [
	^ self class supports: aLayoutCommand
]

{ #category : 'layouts' }
OPLayouter >> treeLayout [

	self applyLayout: [ :boxes :links |
		| centerY |
		(OPLayoutLoopDetector popupHaveLoopsBoxes: boxes links: links)
			ifTrue: [ ^ self gridLayout ].
		RSTreeLayout new
			verticalGap: 100;
			horizontalGap: 100;
			on: boxes edges: links.
		centerY := (RSGroup withAll: boxes) encompassingRectangle center y.
		boxes do: [ :each |
			each translateBy: 0 @ 2 * (centerY - each position y) ] ]
]

{ #category : 'userinterface' }
OPLayouter >> updateCanvas [

	diagramController updateCanvas
]

{ #category : 'userinterface' }
OPLayouter >> updateView [

	self
		deprecated: 'Use #updateCanvas instead.'
		transformWith:
		'`@receiver updateView'
		-> '`@receiver updateCanvas'.
	^ self updateCanvas
]
