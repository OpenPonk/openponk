Class {
	#name : 'OPInspectViewModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'as yet unclassified' }
OPInspectViewModelCommand >> canBeExecuted [
	^ self selectedViewModel isNotNil
]

{ #category : 'as yet unclassified' }
OPInspectViewModelCommand >> execute [
	self selectedViewModel inspect
]

{ #category : 'as yet unclassified' }
OPInspectViewModelCommand >> initialize [
	super initialize.
	self name: 'Inspect ViewModel'
]

{ #category : 'as yet unclassified' }
OPInspectViewModelCommand >> itemType [

	^ 'view model'
]

{ #category : 'as yet unclassified' }
OPInspectViewModelCommand >> items [

	^ viewModels
]
