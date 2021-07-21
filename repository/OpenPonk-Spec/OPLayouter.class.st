"
I am base class for layouters to see what commonalities they have and should be eventually extracted up to OpenPonk.
"
Class {
	#name : #OPLayouter,
	#superclass : #Object,
	#instVars : [
		'diagramController'
	],
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #'as yet unclassified' }
OPLayouter class >> supportedLayoutCommands [
	^ {OPDominanceTreeLayoutCommand.
	OPGridLayoutCommand.
	OPSugiyamaLayoutCommand.
	OPTreeLayoutCommand}
]

{ #category : #'as yet unclassified' }
OPLayouter class >> supports: aLayoutCommand [
	^ self supportedLayoutCommands includes: aLayoutCommand
]

{ #category : #accessing }
OPLayouter >> allEdges [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPLayouter >> allNodes [
	^ self subclassResponsibility
]

{ #category : #userinterface }
OPLayouter >> applyLayout: aTwoArgBlock [
	| oldView newView |
	"oldView := diagramController viewState."
	self basicApplyLayout: aTwoArgBlock.
	"newView := diagramController viewState.
	diagramController undoManager
		redoArray:
			{diagramController.
			#viewState:.
			{newView}}
		undoArray:
			{diagramController.
			#viewState:.
			{oldView}}"
]

{ #category : #userinterface }
OPLayouter >> basicApplyLayout: aTwoArgBlock [

	| selectedBoxes allNodes nodes allEdges edges isPartialLayout oldEncompassingRectangle newEncompassingRectangle |
	selectedBoxes := diagramController editor canvasModel
		                 selectedElements.
	isPartialLayout := selectedBoxes size > 1.
	allNodes := self allNodes.
	nodes := RTGroup withAll: (isPartialLayout
			          ifTrue: [ allNodes intersection: selectedBoxes ]
			          ifFalse: [ allNodes ]).
	allEdges := self allEdges reject: [ :each | each to = each from ].
	edges := allEdges select: [ :each | 
		         (nodes includes: each from) & (nodes includes: each to) ].
	oldEncompassingRectangle := nodes encompassingRectangle.
	aTwoArgBlock value: nodes value: edges.
	newEncompassingRectangle := nodes encompassingRectangle.
	isPartialLayout
		ifTrue: [ 
			nodes translateTo: oldEncompassingRectangle center.
			diagramController view signalUpdate ]
		ifFalse: [ self updateView ]
]

{ #category : #layouts }
OPLayouter >> circleLayout [
	self
		applyLayout: [ :boxes :links | 
			RTWeightedCircleLayout new
				scaleBy: 20;
				on: boxes ]
]

{ #category : #layouts }
OPLayouter >> defaultLayout [
	self subclassResponsibility
]

{ #category : #accessing }
OPLayouter >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : #layouts }
OPLayouter >> dominanceTreeLayout [
	self
		applyLayout: [ :boxes :links | 
			RTDominanceTreeLayout new
				verticallyReverse;
				verticalGap: 100;
				horizontalGap: 100;
				doNotAttachPoint;
				on: boxes edges: links ]
]

{ #category : #accessing }
OPLayouter >> figuresFor: aCollection [
	^ (aCollection
		collect: [ :model | 
			diagramController controllers
				detect: [ :each | each model = model ]
				ifFound: #figure
				ifNone: [ nil ] ]) reject: #isNil
]

{ #category : #layouts }
OPLayouter >> gridLayout [
	self
		applyLayout: [ :boxes :links | 
			RTGridLayout new
				gapSize: 140;
				on: boxes ]
]

{ #category : #layouts }
OPLayouter >> sugiyamaLayout [

	self applyLayout: [ :boxes :links | 
		| centerY |
		RTSugiyamaLayout new
			doNotAttachPoint;
			verticalGap: 100;
			horizontalGap: 100;
			on: boxes edges: links.
		centerY := (RTGroup withAll: boxes) encompassingRectangle center y.
		boxes do: [ :each | 
			each translateBy: 0 @ 2 * (centerY - each position y) ] ]
]

{ #category : #'as yet unclassified' }
OPLayouter >> supports: aLayoutCommand [
	^ self class supports: aLayoutCommand
]

{ #category : #layouts }
OPLayouter >> treeLayout [

	self applyLayout: [ :boxes :links | 
		| centerY |
		RTTreeLayout new
			doNotAttachPoint;
			verticalGap: 100;
			horizontalGap: 100;
			on: boxes edges: links.
		centerY := (RTGroup withAll: boxes) encompassingRectangle center y.
		boxes do: [ :each | 
			each translateBy: 0 @ 2 * (centerY - each position y) ] ]
]

{ #category : #userinterface }
OPLayouter >> updateView [
	| view |
	view := diagramController view.
	view signalUpdate.
	view canvas camera focusOnCenter
]
