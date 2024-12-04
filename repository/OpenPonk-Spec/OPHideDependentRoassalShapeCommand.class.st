Class {
	#name : 'OPHideDependentRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'execution' }
OPHideDependentRoassalShapeCommand >> basicExecute [

	controllers
		select: #isHideable
		thenDo: [ :each | executor hideDependentFor: each model ]
]
