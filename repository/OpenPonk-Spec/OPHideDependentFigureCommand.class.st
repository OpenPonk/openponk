Class {
	#name : #OPHideDependentFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPHideDependentFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ aToolContext controller isHideable
]

{ #category : #execution }
OPHideDependentFigureCommand >> basicExecute [
	models do: [ :each | executor hideDependentFor: each ]
]
