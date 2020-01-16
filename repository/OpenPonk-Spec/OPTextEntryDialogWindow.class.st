"
I am a single-line text entry dialog that performs a validation on the user-provided data, and will only allow accepting a valid text.
"
Class {
	#name : #OPTextEntryDialogWindow,
	#superclass : #TextEntryDialogWindow,
	#instVars : [
		'validation'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #'instance creation' }
OPTextEntryDialogWindow >> entryText: anObject [
	super entryText: anObject.
	self defaultButton update: #isValid
]

{ #category : #initialization }
OPTextEntryDialogWindow >> initialize [
	validation := [ :text | text isNotEmpty ].
	super initialize
]

{ #category : #testing }
OPTextEntryDialogWindow >> isValid [
	^ textEditorMorph text ifNil: [ false ] ifNotNil: [ :text | validation value: text ]
]

{ #category : #'instance creation' }
OPTextEntryDialogWindow >> newOKButton [
	^ self newOKButtonFor: self getEnabled: #isValid
]

{ #category : #'instance creation' }
OPTextEntryDialogWindow >> newTextEditorMorph [
	^ super newTextEditorMorph
		changedAction: [ :text | self defaultButton update: #isValid ];
		yourself
]

{ #category : #accessing }
OPTextEntryDialogWindow >> validation: aOneArgBlock [
	validation := aOneArgBlock
]
