Class {
	#name : 'OPDiagramRenamed',
	#superclass : 'Announcement',
	#instVars : [
		'diagram',
		'oldName',
		'newName'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPDiagramRenamed class >> diagram: aDiagram oldName: anOldName newName: aNewName [
	^ self new
		diagram: aDiagram;
		oldName: anOldName;
		newName: aNewName;
		yourself
]

{ #category : 'accessing' }
OPDiagramRenamed >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPDiagramRenamed >> diagram: aDiagram [
	diagram := aDiagram
]

{ #category : 'accessing' }
OPDiagramRenamed >> newName [
	^ newName
]

{ #category : 'accessing' }
OPDiagramRenamed >> newName: aString [
	newName := aString
]

{ #category : 'accessing' }
OPDiagramRenamed >> oldName [
	^ oldName
]

{ #category : 'accessing' }
OPDiagramRenamed >> oldName: aString [
	oldName := aString
]
