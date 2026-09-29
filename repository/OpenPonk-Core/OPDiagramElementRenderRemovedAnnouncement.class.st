"
Announcement fired when a diagram element's visual representation (Roassal shape) is removed from the canvas.
"
Class {
	#name : 'OPDiagramElementRenderRemovedAnnouncement',
	#superclass : 'OPDiagramElementAnnouncement',
	#instVars : [
		'roassalShape'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'instance creation' }
OPDiagramElementRenderRemovedAnnouncement class >> forDiagramElement: aDiagramElement roassalShape: aRoassalShape [

	^ (self forDiagramElement: aDiagramElement)
		  roassalShape: aRoassalShape;
		  yourself
]

{ #category : 'accessing' }
OPDiagramElementRenderRemovedAnnouncement >> roassalShape [

	^ roassalShape
]

{ #category : 'accessing' }
OPDiagramElementRenderRemovedAnnouncement >> roassalShape: aRoassalShape [

	roassalShape := aRoassalShape
]
