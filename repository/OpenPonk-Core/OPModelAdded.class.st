Class {
	#name : 'OPModelAdded',
	#superclass : 'Announcement',
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPModelAdded class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : 'accessing' }
OPModelAdded >> model [
	^ model
]

{ #category : 'accessing' }
OPModelAdded >> model: aModel [
	model := aModel
]
