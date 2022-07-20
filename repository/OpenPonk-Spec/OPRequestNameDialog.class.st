Class {
	#name : #OPRequestNameDialog,
	#superclass : #SpRequestDialog,
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #examples }
OPRequestNameDialog class >> example [

	<example>
	| dialog |
	dialog := OPRequestNameDialog new.
	dialog
		onAccept: [ self inform: dialog text ];
		entryCompletionFilter: [ :text | 
			(250 to: 450) atRandom milliSeconds wait. "simulate delay of source of options"
			SpDialogPresenter allSubclasses
				select: [ :class | 
					class name includesSubstring: text caseSensitive: false ]
				thenCollect: [ :class | 
					OPEntryCompletionOption
						withText: class name
						subtext: class superclass name ] ];
		openDialog
]

{ #category : #accessing }
OPRequestNameDialog >> entryCompletionFilter: anEntryCompletion [

	textInput entryCompletionFilter: anEntryCompletion
]

{ #category : #initialization }
OPRequestNameDialog >> initializePresenters [

	image := self newImage image: (self application iconNamed: #question).
	label := self newLabel.
	textInput := self instantiate:
		             OPAsyncTextInputFieldPresenter
]
