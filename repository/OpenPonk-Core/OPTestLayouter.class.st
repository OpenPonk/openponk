Class {
	#name : 'OPTestLayouter',
	#superclass : 'OPNodesAndEdgesLayouter',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPTestLayouter >> allEdges [
	^ #()
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
