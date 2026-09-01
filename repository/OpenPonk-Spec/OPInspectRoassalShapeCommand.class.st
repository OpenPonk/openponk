"
Developer-oriented context menu command that opens a Pharo inspector directly on the selected Roassal shape instance itself.
"
Class {
	#name : 'OPInspectRoassalShapeCommand',
	#superclass : 'OPInspectDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPInspectRoassalShapeCommand >> itemType [

	^ 'roassal shape'
]

{ #category : 'accessing' }
OPInspectRoassalShapeCommand >> items [

	^ roassalShapes
]
