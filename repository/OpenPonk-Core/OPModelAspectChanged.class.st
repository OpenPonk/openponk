"
I provide more detailed information on what aspect has changed and how.
"
Class {
	#name : #OPModelAspectChanged,
	#superclass : #OPModelChanged,
	#instVars : [
		'aspect',
		'oldValue',
		'newValue'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #'instance creation' }
OPModelAspectChanged class >> on: aModel aspect: anAspect oldValue: anOldValue newValue: aNewValue [
	^ self new
		model: aModel;
		aspect: anAspect;
		oldValue: anOldValue;
		newValue: aNewValue;
		yourself
]

{ #category : #accessing }
OPModelAspectChanged >> aspect [
	^ aspect
]

{ #category : #accessing }
OPModelAspectChanged >> aspect: anObject [
	aspect := anObject
]

{ #category : #accessing }
OPModelAspectChanged >> newValue [
	^ newValue
]

{ #category : #accessing }
OPModelAspectChanged >> newValue: anObject [
	newValue := anObject
]

{ #category : #accessing }
OPModelAspectChanged >> oldValue [
	^ oldValue
]

{ #category : #accessing }
OPModelAspectChanged >> oldValue: anObject [
	oldValue := anObject
]
