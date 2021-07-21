"
Fire me on any DiagramController's MODEL and a new Editor will be opened on the given model. If such editor already exists, then it will become focused.
"
Class {
	#name : #OPOpenEditorRequest,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #accessing }
OPOpenEditorRequest class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
OPOpenEditorRequest >> model [
	^ model
]

{ #category : #accessing }
OPOpenEditorRequest >> model: anObject [
	model := anObject
]
