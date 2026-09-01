Class {
	#name : 'OPProjectTreeCommand',
	#superclass : 'CmCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'as yet unclassified' }
OPProjectTreeCommand class >> isAbstract [
	^ self = OPProjectTreeCommand
]

{ #category : 'as yet unclassified' }
OPProjectTreeCommand >> projectController [
	^ self context projectController
]

{ #category : 'as yet unclassified' }
OPProjectTreeCommand >> selectedViewModel [
	^ self context selectedItem
]
