Class {
	#name : #OPShowHideSelectionChanged,
	#superclass : #Announcement,
	#instVars : [
		'elements'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #accessing }
OPShowHideSelectionChanged class >> elements: aCollection [
	^ self new
		elements: aCollection;
		yourself
]

{ #category : #accessing }
OPShowHideSelectionChanged >> elements: aCollection [ 
	elements := aCollection
]
