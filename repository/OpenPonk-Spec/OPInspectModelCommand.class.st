Class {
	#name : 'OPInspectModelCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'as yet unclassified' }
OPInspectModelCommand >> canBeExecuted [
	^ self selectedViewModel isNotNil
]

{ #category : 'as yet unclassified' }
OPInspectModelCommand >> execute [
	self selectedViewModel model inspect
]

{ #category : 'as yet unclassified' }
OPInspectModelCommand >> initialize [
	super initialize.
	self name: 'Inspect Model'
]
