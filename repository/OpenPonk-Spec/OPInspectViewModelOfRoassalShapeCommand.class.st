"
A developer diagnostic command that opens an inspector on the OpenPonk ViewModel associated with the selected Roassal shape.
"
Class {
	#name : 'OPInspectViewModelOfRoassalShapeCommand',
	#superclass : 'OPInspectDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPInspectViewModelOfRoassalShapeCommand >> itemType [
	^ 'view model'
]

{ #category : 'accessing' }
OPInspectViewModelOfRoassalShapeCommand >> items [
	^ viewModels
]
