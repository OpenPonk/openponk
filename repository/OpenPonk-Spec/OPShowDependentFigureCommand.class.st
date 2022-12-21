Class {
	#name : #OPShowDependentFigureCommand,
	#superclass : #OPToggleFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #execution }
OPShowDependentFigureCommand >> basicExecute [
	models do: [ :each | executor showDependentFor: each ]
]
