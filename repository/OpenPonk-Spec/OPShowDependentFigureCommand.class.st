Class {
	#name : #OPShowDependentFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPShowDependentFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ aToolContext controller isHideable
]

{ #category : #execution }
OPShowDependentFigureCommand >> basicExecute [
	models do: [ :each | executor showDependentFor: each ]
]
