"
I am a base class for model (or model element) events.
"
Class {
	#name : #OPModelAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #'instance creation' }
OPModelAnnouncement class >> on: aModel [
	^ self new model: aModel
]

{ #category : #accessing }
OPModelAnnouncement >> model [
	^ model
]

{ #category : #accessing }
OPModelAnnouncement >> model: aModel [
	model := aModel
]
