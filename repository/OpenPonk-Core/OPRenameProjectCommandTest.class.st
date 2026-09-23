Class {
	#name : 'OPRenameProjectCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'undoManager'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRenameProjectCommandTest >> setUp [
	super setUp.
	project := OPProject new.
	project name: 'Original Project'.
	undoManager := OPUndoManager new
]

{ #category : 'running' }
OPRenameProjectCommandTest >> tearDown [
	project := nil.
	undoManager := nil.
	super tearDown
]

{ #category : 'tests' }
OPRenameProjectCommandTest >> testExecuteRenamesProjectAndAnnounces [
	| command announcedProject announcedOldName announcedNewName |
	announcedProject := nil.
	announcedOldName := nil.
	announcedNewName := nil.
	project announcer
		when: OPProjectRenamed
		do: [ :announcement |
			announcedProject := announcement project.
			announcedOldName := announcement oldName.
			announcedNewName := announcement newName ]
		for: self.

	command := OPRenameProjectCommand project: project newName: 'Renamed Project'.
	command execute.

	self assert: project name equals: 'Renamed Project'.
	self assert: announcedProject identicalTo: project.
	self assert: announcedOldName equals: 'Original Project'.
	self assert: announcedNewName equals: 'Renamed Project'
]

{ #category : 'tests' }
OPRenameProjectCommandTest >> testIntegrationWithUndoManager [
	| command |
	command := OPRenameProjectCommand project: project newName: 'Renamed Project'.
	undoManager execute: command.

	self assert: project name equals: 'Renamed Project'.
	undoManager undo.
	self assert: project name equals: 'Original Project'.
	undoManager redo.
	self assert: project name equals: 'Renamed Project'
]

{ #category : 'tests' }
OPRenameProjectCommandTest >> testRedoReappliesNewName [
	| command |
	command := OPRenameProjectCommand project: project newName: 'Renamed Project'.
	command execute.
	command undo.
	command redo.

	self assert: project name equals: 'Renamed Project'
]

{ #category : 'tests' }
OPRenameProjectCommandTest >> testUndoRestoresOriginalNameAndAnnounces [
	| command announcedOldName announcedNewName |
	command := OPRenameProjectCommand project: project newName: 'Renamed Project'.
	command execute.

	announcedOldName := nil.
	announcedNewName := nil.
	project announcer
		when: OPProjectRenamed
		do: [ :announcement |
			announcedOldName := announcement oldName.
			announcedNewName := announcement newName ]
		for: self.

	command undo.

	self assert: project name equals: 'Original Project'.
	self assert: announcedOldName equals: 'Renamed Project'.
	self assert: announcedNewName equals: 'Original Project'
]
