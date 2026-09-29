"
Diagram toolbar command that applies a Sugiyama (layered/hierarchical) layout algorithm to the elements on the current diagram canvas.
"
Class {
	#name : 'OPSugiyamaLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPSugiyamaLayoutCommand >> defaultMenuItemName [
	^ 'Hierarchical'
]

{ #category : 'execution' }
OPSugiyamaLayoutCommand >> execute [
	layouter sugiyamaLayout
]
