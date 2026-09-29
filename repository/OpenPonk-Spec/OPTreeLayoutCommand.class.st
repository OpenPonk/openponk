"
Diagram toolbar command that applies a hierarchical tree layout algorithm to the elements on the current diagram canvas.
"
Class {
	#name : 'OPTreeLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPTreeLayoutCommand >> defaultMenuItemName [
	^ 'Tree'
]

{ #category : 'execution' }
OPTreeLayoutCommand >> execute [
	layouter treeLayout
]
