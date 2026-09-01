"
Abstract base class for applying automated graph layout algorithms (such as tree, grid, or circle layouts) to elements within an OpenPonk diagram via the OPDiagramController.
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

{ #category : 'accessing' }
OPLayouter class >> supportedLayoutCommands [
	^ {OPDominanceTreeLayoutCommand.
	OPGridLayoutCommand.
	OPSugiyamaLayoutCommand.
	OPTreeLayoutCommand}
]

{ #category : 'as yet unclassified' }
OPLayouter class >> supports: aLayoutCommand [
	^ self supportedLayoutCommands includes: aLayoutCommand
]

{ #category : 'userinterface' }
OPLayouter >> applyLayout: aTwoArgBlock [

	self subclassResponsibility
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
		RSSugiyamaLayout new
			verticalGap: 100;
			horizontalGap: 100;
			on: boxes edges: links.
		centerY := (RSGroup withAll: boxes) encompassingRectangle center y.
		boxes do: [ :each | 
			each translateBy: 0 @ 2 * (centerY - each position y) ] ]
]

{ #category : 'as yet unclassified' }
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
