"
I am a generic graph layouter that abstracts the extraction of nodes and edges from a diagram to apply automated structural layouts.
"
Class {
	#name : 'OPNodesAndEdgesLayouter',
	#superclass : 'OPLayouter',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> allEdges [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPNodesAndEdgesLayouter >> allNodes [
	^ self subclassResponsibility
]

{ #category : 'userinterface' }
OPNodesAndEdgesLayouter >> applyLayout: aTwoArgBlock [

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
