Class {
	#name : 'OPDominanceTreeLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPDominanceTreeLayoutCommand >> defaultMenuItemName [
	^ 'Dominance Tree'
]

{ #category : 'accessing' }
OPDominanceTreeLayoutCommand >> execute [
	layouter dominanceTreeLayout
]
