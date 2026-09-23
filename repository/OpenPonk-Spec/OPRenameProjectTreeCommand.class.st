Class {
	#name : 'OPRenameProjectTreeCommand',
	#superclass : 'OPProjectTreeCommand',
	#category : 'OpenPonk-Spec-Commands-ProjectTree',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-ProjectTree'
}

{ #category : 'testing' }
OPRenameProjectTreeCommand >> canBeExecuted [
	^ self selectedViewModel isKindOf: OPProjectViewModel
]

{ #category : 'executing' }
OPRenameProjectTreeCommand >> execute [
	self workbench renameProject
]

{ #category : 'accessing' }
OPRenameProjectTreeCommand >> iconName [
	"Answer the icon name for the rename action in the project tree context menu."
	^ #glamorousEdit
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
