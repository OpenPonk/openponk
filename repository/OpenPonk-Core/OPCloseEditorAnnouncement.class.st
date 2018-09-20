"
Fire me on any DiagramController's MODEL and the Editor operating on the model will be closed. If it doesn't exist then nothing will happen.
"
Class {
	#name : #OPCloseEditorAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Core-Announcements'
}

{ #category : #accessing }
OPCloseEditorAnnouncement class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
OPCloseEditorAnnouncement >> model [
	^ model
]

{ #category : #accessing }
OPCloseEditorAnnouncement >> model: anObject [
	model := anObject
]
