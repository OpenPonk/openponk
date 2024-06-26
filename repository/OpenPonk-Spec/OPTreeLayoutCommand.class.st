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

{ #category : 'accessing' }
OPTreeLayoutCommand >> execute [
	layouter treeLayout
]
