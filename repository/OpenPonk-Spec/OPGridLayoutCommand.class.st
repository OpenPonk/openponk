Class {
	#name : #OPGridLayoutCommand,
	#superclass : #OPLayoutDiagramCommand,
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #accessing }
OPGridLayoutCommand >> defaultMenuItemName [
	^ 'Grid'
]

{ #category : #accessing }
OPGridLayoutCommand >> execute [
	layouter gridLayout
]
