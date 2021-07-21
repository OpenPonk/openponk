"
I am a creation tool specific for model-only creation. The attachment of controller and/or creation of view is decided by the controller.
"
Class {
	#name : #OPModelCreationTool,
	#superclass : #OPCreationTool,
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #callbacks }
OPModelCreationTool >> targetSelected: aController [
	(aController canBeTargetFor: objectController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: objectController.
	self palette deselectTool.
	objectController := nil
]
