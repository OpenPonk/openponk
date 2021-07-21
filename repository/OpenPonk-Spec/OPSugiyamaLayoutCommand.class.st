Class {
	#name : #OPSugiyamaLayoutCommand,
	#superclass : #OPLayoutDiagramCommand,
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #accessing }
OPSugiyamaLayoutCommand >> defaultMenuItemName [
	^ 'Hierarchical'
]

{ #category : #accessing }
OPSugiyamaLayoutCommand >> execute [
	layouter sugiyamaLayout
]
