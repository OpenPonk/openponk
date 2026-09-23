Class {
	#name : 'OPRenameProjectCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'project',
		'newName',
		'oldName'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPRenameProjectCommand class >> project: aProject newName: aString [
	^ self new
		project: aProject;
		newName: aString;
		yourself
]

{ #category : 'announcing' }
OPRenameProjectCommand >> announceRenameFrom: fromName to: toName [
	project announcer announce: (OPProjectRenamed project: project oldName: fromName newName: toName)
]

{ #category : 'executing' }
OPRenameProjectCommand >> execute [
	oldName ifNil: [ oldName := project name ].
	project name: newName.
	self announceRenameFrom: oldName to: newName
]

{ #category : 'accessing' }
OPRenameProjectCommand >> newName [
	^ newName
]

{ #category : 'accessing' }
OPRenameProjectCommand >> newName: aString [
	newName := aString
]

{ #category : 'accessing' }
OPRenameProjectCommand >> oldName [
	^ oldName
]

{ #category : 'accessing' }
OPRenameProjectCommand >> oldName: aString [
	oldName := aString
]

{ #category : 'accessing' }
OPRenameProjectCommand >> project [
	^ project
]

{ #category : 'accessing' }
OPRenameProjectCommand >> project: aProject [
	project := aProject
]

{ #category : 'executing' }
OPRenameProjectCommand >> redo [
	self execute
]

{ #category : 'executing' }
OPRenameProjectCommand >> undo [
	project name: oldName.
	self announceRenameFrom: newName to: oldName
]
