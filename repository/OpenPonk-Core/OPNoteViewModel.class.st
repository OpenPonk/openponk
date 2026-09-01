"
Diagram-only view model for note elements. 
Handles the logic for visual notes that exist independently of a structural domain model.
"
Class {
	#name : 'OPNoteViewModel',
	#superclass : 'OPDiagramOnlyViewModel',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'accessing' }
OPNoteViewModel class >> modelClass [

	^ OPNote
]
