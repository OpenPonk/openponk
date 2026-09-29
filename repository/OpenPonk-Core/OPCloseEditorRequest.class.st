"
Announcement signaling a request to close the editor operating on a specific model. 
Typically dispatched on a diagram controller's announcer.
"
Class {
	#name : 'OPCloseEditorRequest',
	#superclass : 'Announcement',
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
OPCloseEditorRequest class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : 'accessing' }
OPCloseEditorRequest >> model [
	^ model
]

{ #category : 'accessing' }
OPCloseEditorRequest >> model: anObject [
	model := anObject
]
