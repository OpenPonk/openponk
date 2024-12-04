Class {
	#name : 'OPHideDependentRoassalShapesCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'execution' }
OPHideDependentRoassalShapesCommand >> basicExecute [

	controllers
		select: #isHideable
		thenDo: [ :each | executor hideDependentFor: each model ]
]
