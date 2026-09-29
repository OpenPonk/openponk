"
Context menu command that explicitly hides all child or dependent shapes of the selected Roassal shape from the canvas.
"
Class {
	#name : 'OPHideDependentRoassalShapeCommand',
	#superclass : 'OPToggleRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'execution' }
OPHideDependentRoassalShapeCommand >> basicExecute [

	controllers
		select: #isHideable
		thenDo: [ :each | executor hideDependentFor: each model ]
]
