Class {
	#name : 'OPProjectTreeCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPProjectTreeCommandTest >> testInspectModelCommandHasInspectIcon [
	| inspectCommand specCommand |
	inspectCommand := OPInspectModelCommand new.
	specCommand := inspectCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousInspect
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testInspectViewModelCommandHasInspectIcon [
	| inspectCommand specCommand |
	inspectCommand := OPInspectViewModelCommand new.
	specCommand := inspectCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousInspect
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testRemoveModelCommandHasTrashIcon [
	| removeCommand specCommand |
	removeCommand := OPRemoveModelCommand new.
	specCommand := removeCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousTrash
]

{ #category : 'tests' }
OPProjectTreeCommandTest >> testRenameProjectTreeCommandHasEditIcon [
	| renameCommand specCommand |
	renameCommand := OPRenameProjectTreeCommand new.
	specCommand := renameCommand asSpecCommand.
	self assert: specCommand iconName equals: #glamorousEdit
]
