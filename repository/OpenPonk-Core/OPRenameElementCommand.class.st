"
UI command that handles the renaming of a model element. 
Typically prompts the user with a dialog to provide a new name and applies the modification through the element's handler.
"
Class {
	#name : 'OPRenameElementCommand',
	#superclass : 'OPUICommand',
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'execute' }
OPRenameElementCommand >> execute [

	| result |
	result := self doAndReturnFocus: [
		          UIManager default
			          request: 'Enter a name'
			          initialAnswer: controller model name ].
	result ifNil: [ ^ self ].
	result ifEmpty: [ ^ self ].
	controller model name: result.
	controller viewModel announcer announce: OPElementRenamed new
]
