"
Fire me on any DiagramController's MODEL and the Editor operating on the model will be closed. If it doesn't exist then nothing will happen.
"
Class {
	#name : #OPCloseEditorRequest,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #accessing }
OPCloseEditorRequest class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
OPCloseEditorRequest >> model [
	^ model
]

{ #category : #accessing }
OPCloseEditorRequest >> model: anObject [
	model := anObject
]
