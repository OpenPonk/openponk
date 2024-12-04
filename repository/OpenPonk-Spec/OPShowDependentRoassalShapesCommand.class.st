Class {
	#name : 'OPShowDependentRoassalShapesCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'execution' }
OPShowDependentRoassalShapesCommand >> basicExecute [
	models do: [ :each | executor showDependentFor: each ]
]
