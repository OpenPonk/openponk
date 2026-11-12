"
A mock layouter implementation utilized in SUnit tests to verify automatic element layout invocations.
"
Class {
	#name : 'OPTestLayouter',
	#superclass : 'OPHierarchicalNodesAndEdgesLayouter',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestLayouter >> allEdges [
	^ diagramController canvasPresenter
		ifNotNil: [ :cp | cp canvas lines ]
		ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
OPTestLayouter >> allNodes [
	^ diagramController controllers
		select: [ :ctrl | ctrl roassalShape isNotNil ]
		thenCollect: #roassalShape
]

{ #category : 'layouting' }
OPTestLayouter >> defaultLayout [
	self applyLayout: [ :nodes :edges |
		nodes do: [ :each | each translateBy: 50 @ 50 ] ]
]
