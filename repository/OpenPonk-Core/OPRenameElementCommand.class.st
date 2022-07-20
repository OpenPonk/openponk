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

{ #category : #completion }
OPRenameElementCommand >> entryCompletionOptionsFor: aText [

	^ #(  )
]

{ #category : #execute }
OPRenameElementCommand >> execute [

	| dialog result |
	dialog := OPRequestNameDialog new.
	dialog
		entryCompletionFilter: [ :text | 
			self entryCompletionOptionsFor: text ];
		openBlockedDialog.
	result := dialog text.
	result ifNil: [ ^ self ].
	model name: result.
	model announcer announce: OPElementRenamed new
]
