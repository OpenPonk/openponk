"
Diagram-only view model for boundary elements. 
Handles domain logic for visual boundaries that lack an underlying structural model, interfacing directly with the diagram element.
"
Class {
	#name : 'OPBoundaryViewModel',
	#superclass : 'OPDiagramOnlyViewModel',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'accessing' }
OPBoundaryViewModel class >> modelClass [

	^ OPBoundary
]

{ #category : 'accessing' }
OPBoundaryViewModel >> creationPriority [
	"Boundary elements must be created before classifiers (10) and edges (20) to stay in the background."
	^ 5
]
