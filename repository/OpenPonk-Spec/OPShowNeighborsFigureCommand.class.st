Class {
	#name : #OPShowNeighborsFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPShowNeighborsFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ aToolContext controller isHideable
]

{ #category : #execution }
OPShowNeighborsFigureCommand >> basicExecute [
	models do: [ :each | executor showNeighborsOf: each ]
]
