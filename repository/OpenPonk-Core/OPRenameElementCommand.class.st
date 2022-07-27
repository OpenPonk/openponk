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

	| dialog result |
	dialog := SpRequestDialog new.
	dialog openBlockedDialog.
	result := dialog text.
	result ifNil: [ ^ self ].
	element name: result.
	element announcer announce: OPElementRenamed new
]
