"
Context menu command that explicitly reveals and renders all child or dependent shapes of the selected Roassal shape on the canvas.
"
Class {
	#name : 'OPShowDependentRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'execution' }
OPShowDependentRoassalShapeCommand >> basicExecute [
	models do: [ :each | executor showDependentFor: each ]
]
