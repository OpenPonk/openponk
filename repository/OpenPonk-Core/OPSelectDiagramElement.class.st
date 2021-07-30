Class {
	#name : #OPSelectDiagramElement,
	#superclass : #Announcement,
	#instVars : [
		'model'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #'instance creation' }
OPSelectDiagramElement class >> model: aModel [
	^ self new
		model: aModel;
		yourself
]

{ #category : #accessing }
OPSelectDiagramElement >> model [
	^ model
]

{ #category : #accessing }
OPSelectDiagramElement >> model: aModel [
	model := aModel
]
