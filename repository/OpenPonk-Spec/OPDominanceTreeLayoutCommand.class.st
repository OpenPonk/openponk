"
Diagram toolbar command that applies a dominance tree layout algorithm to the elements on the current diagram canvas.
"
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

{ #category : 'execution' }
OPDominanceTreeLayoutCommand >> execute [
	layouter dominanceTreeLayout
]
