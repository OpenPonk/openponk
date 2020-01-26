Class {
	#name : #OPHideNeighborsFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPHideNeighborsFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ aToolContext controller isHideable
]

{ #category : #execution }
OPHideNeighborsFigureCommand >> basicExecute [
	models do: [ :each | executor hideNeighborsOf: each ]
]
