Class {
	#name : 'OPDiagramAdded',
	#superclass : 'Announcement',
	#instVars : [
		'diagram'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPDiagramAdded class >> diagram: aDiagram [
	^ self new
		diagram: aDiagram;
		yourself
]

{ #category : 'accessing' }
OPDiagramAdded >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPDiagramAdded >> diagram: aDiagram [
	diagram := aDiagram
]
