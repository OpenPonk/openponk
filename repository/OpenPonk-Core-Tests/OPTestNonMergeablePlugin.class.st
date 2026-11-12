"
Test plugin stub representing a notation plugin that does not support merging multiple models.
"
Class {
	#name : 'OPTestNonMergeablePlugin',
	#superclass : 'OPTestPlugin',
	#category : 'OpenPonk-Core-Tests-Plugin',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPTestNonMergeablePlugin >> modelClass [
	^ OPTestAbstractModel
]

{ #category : 'accessing' }
OPTestNonMergeablePlugin >> name [
	^ 'NonMergeable Test Plugin'
]

{ #category : 'testing' }
OPTestNonMergeablePlugin >> supportsMergingModels [
	^ false
]
