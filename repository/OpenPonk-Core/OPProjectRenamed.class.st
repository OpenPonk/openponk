Class {
	#name : 'OPProjectRenamed',
	#superclass : 'Announcement',
	#instVars : [
		'project',
		'oldName',
		'newName'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPProjectRenamed class >> project: aProject oldName: anOldString newName: aNewString [
	^ self new
		project: aProject;
		oldName: anOldString;
		newName: aNewString;
		yourself
]

{ #category : 'accessing' }
OPProjectRenamed >> newName [
	^ newName
]

{ #category : 'accessing' }
OPProjectRenamed >> newName: aString [
	newName := aString
]

{ #category : 'accessing' }
OPProjectRenamed >> oldName [
	^ oldName
]

{ #category : 'accessing' }
OPProjectRenamed >> oldName: aString [
	oldName := aString
]

{ #category : 'accessing' }
OPProjectRenamed >> project [
	^ project
]

{ #category : 'accessing' }
OPProjectRenamed >> project: aProject [
	project := aProject
]
