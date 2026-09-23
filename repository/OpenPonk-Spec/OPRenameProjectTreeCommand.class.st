Class {
	#name : 'OPRenameProjectTreeCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'converting' }
OPRenameProjectTreeCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: #glamorousEdit;
		yourself
]

{ #category : 'testing' }
OPRenameProjectTreeCommand >> canBeExecuted [
	^ self selectedViewModel isKindOf: OPProjectViewModel
]

{ #category : 'executing' }
OPRenameProjectTreeCommand >> execute [
	self workbench renameProject
]

{ #category : 'initialization' }
OPRenameProjectTreeCommand >> initialize [
	super initialize.
	self name: 'Rename'
]

{ #category : 'accessing' }
OPRenameProjectTreeCommand >> workbench [
	^ self context workbench
]
