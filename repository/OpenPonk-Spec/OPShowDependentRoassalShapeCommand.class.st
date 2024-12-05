Class {
	#name : 'OPShowDependentRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'execution' }
OPShowDependentRoassalShapeCommand >> basicExecute [
	models do: [ :each | executor showDependentFor: each ]
]
