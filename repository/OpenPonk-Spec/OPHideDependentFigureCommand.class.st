Class {
	#name : 'OPHideDependentFigureCommand',
	#superclass : 'OPToggleFigureCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'execution' }
OPHideDependentFigureCommand >> basicExecute [

	controllers
		select: #isHideable
		thenDo: [ :each | executor hideDependentFor: each model ]
]
