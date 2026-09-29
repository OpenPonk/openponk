"
Base class for announcements and events triggered by state changes within domain models.
"
Class {
	#name : 'OPModelEvent',
	#superclass : 'OPEvent',
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPModelEvent class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : 'accessing' }
OPModelEvent >> model [
	^ model
]

{ #category : 'accessing' }
OPModelEvent >> model: aModel [
	model := aModel
]
