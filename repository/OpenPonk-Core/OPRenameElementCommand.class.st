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

	| result |
	result := UIManager default request: 'Enter a name' initialAnswer: (controller model name).
	result ifNil: [ ^ self ].
	result ifEmpty: [ ^ self ].
	controller model name: result.
	controller model announcer announce: OPElementRenamed new.
]
