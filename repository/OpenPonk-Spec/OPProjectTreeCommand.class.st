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

{ #category : 'converting' }
OPProjectTreeCommand >> asSpecCommand [
	"Answer a Spec2 command representation configured with the command name and optional icon."
	| specCommand |
	specCommand := super asSpecCommand.
	self iconName ifNotNil: [ :anIconName |
		specCommand iconName: anIconName ].
	^ specCommand
]

{ #category : 'accessing' }
OPProjectTreeCommand >> iconName [
	"Answer the symbol representing the Spec2 menu icon for this command, or nil if no icon is specified."
	^ nil
]

{ #category : 'accessing' }
OPProjectTreeCommand >> projectController [
	^ self context projectController
]

{ #category : 'accessing' }
OPProjectTreeCommand >> selectedViewModel [
	^ self context selectedItem
]
