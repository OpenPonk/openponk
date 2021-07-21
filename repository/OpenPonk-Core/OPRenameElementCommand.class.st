"
I am a UI command for renaming a model element.

!! Responsibility

Show rename dialog.
Rename an element.

!! Collaborators

DCCanvasModel
DCNavigator
"
Class {
	#name : #OPRenameElementCommand,
	#superclass : #OPUICommand,
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #execute }
OPRenameElementCommand >> execute [
	| result |
	result := UIManager default request: 'Name' initialAnswer: model name.
	result ifNil: [ ^ self ].
	model name: result.
	model announcer announce: OPElementRenamed new
]
