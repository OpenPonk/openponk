"
A mock layouter implementation utilized in SUnit tests to verify automatic element layout invocations.
"
Class {
	#name : 'OPTestLayouter',
	#superclass : 'OPHierarchicalNodesAndEdgesLayouter',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
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

{ #category : 'layouts' }
OPTestLayouter >> defaultLayout [
	self applyLayout: [ :boxes :links |
		boxes do: [ :each | each translateBy: 50 @ 50 ] ]
]
