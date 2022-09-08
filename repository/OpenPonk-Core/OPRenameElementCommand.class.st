"
I am a UI command for renaming a model element.

!! Requirements

The model element has to implement #name: and #announcer

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

	| dialog result window |
	dialog := SpRequestDialog new.
	dialog label: 'Enter name'.
	window := dialog openBlockedDialog.
	result := dialog text.
	result ifNil: [ ^ self ].
	result ifEmpty: [ ^ self ].
	window cancelled ifTrue: [ ^ self ].
	controller model name: result.
	controller model announcer announce: OPElementRenamed new
]
