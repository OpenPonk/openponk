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
