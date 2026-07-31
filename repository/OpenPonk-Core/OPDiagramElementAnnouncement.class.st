Class {
	#name : 'OPDiagramElementAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'diagramElement'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'instance creation' }
OPDiagramElementAnnouncement class >> forDiagramElement: aDiagramElement [

	^ self new
		  diagramElement: aDiagramElement;
		  yourself
]

{ #category : 'accessing' }
OPDiagramElementAnnouncement >> diagramElement [

	^ diagramElement
]

{ #category : 'accessing' }
OPDiagramElementAnnouncement >> diagramElement: aDiagramElement [

	diagramElement := aDiagramElement
]
