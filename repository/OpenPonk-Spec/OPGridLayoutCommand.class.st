"
Diagram toolbar command that applies a grid layout algorithm to align elements on the current diagram canvas.
"
Class {
	#name : 'OPGridLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPGridLayoutCommand >> defaultMenuItemName [
	^ 'Grid'
]

{ #category : 'execution' }
OPGridLayoutCommand >> execute [
	layouter gridLayout
]
