"
An OPSpecEditableDropListMorphTest is a test class for testing the behavior of OPSpecEditableDropListMorph
"
Class {
	#name : #OPSpecEditableDropListMorphTest,
	#superclass : #TestCase,
	#category : #'OpenPonk-Spec-Tests'
}

{ #category : #tests }
OPSpecEditableDropListMorphTest >> testInstanceCreation [
	self assert: OPSpecEditableDropListMorph new isMorph
]
