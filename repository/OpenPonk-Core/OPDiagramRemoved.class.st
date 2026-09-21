Class {
	#name : 'OPDiagramRemoved',
	#superclass : 'Announcement',
	#instVars : [
		'diagram'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPDiagramRemoved class >> diagram: aDiagram [
	^ self new
		diagram: aDiagram;
		yourself
]

{ #category : 'accessing' }
OPDiagramRemoved >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPDiagramRemoved >> diagram: aDiagram [
	diagram := aDiagram
]
