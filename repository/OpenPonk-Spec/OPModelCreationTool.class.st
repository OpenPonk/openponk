"
I am a creation tool specific for model-only creation. The attachment of controller and/or creation of view is decided by the controller.
"
Class {
	#name : #OPModelCreationTool,
	#superclass : #OPCreationTool,
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #callbacks }
OPModelCreationTool >> selectedControllers: aCollectionOfControllers [

	| targetController |
	self halt.
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: objectController) ifFalse: [ 
		^ self ].
	targetController addAsTargetFor: objectController.
	self palette deselectTool.
	objectController := nil
]
