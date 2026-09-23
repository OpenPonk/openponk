"
Announcement dispatched whenever the state of undo/redo stacks changes (record, undo, redo, clear). Used by UI presenters to update toolbar actions.
"
Class {
	#name : 'OPUndoRedoChanged',
	#superclass : 'Announcement',
	#instVars : [
		'command'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'instance creation' }
OPUndoRedoChanged class >> command: aCommand [
	"Answer a new announcement instance carrying the executed, undone, or redone command."
	^ self new
		command: aCommand;
		yourself
]

{ #category : 'accessing' }
OPUndoRedoChanged >> command [
	"Answer the command associated with this undo/redo change, or nil if unspecified."
	^ command
]

{ #category : 'accessing' }
OPUndoRedoChanged >> command: aCommand [
	"Set the command associated with this undo/redo change."
	command := aCommand
]
