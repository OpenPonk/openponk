"
Specialized ViewModel serving as a ""dummy"" handler for diagram-only elements (such as OPNote or visual decorators) that lack a corresponding structural domain model.
"
Class {
	#name : 'OPDiagramOnlyViewModel',
	#superclass : 'OPViewModel',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'testing' }
OPDiagramOnlyViewModel class >> isAbstract [

	^ self = OPDiagramOnlyViewModel
]

{ #category : 'private' }
OPDiagramOnlyViewModel >> basicRemoveModel [
	"Specific domain model removal logic - removal from owner, disconnecting from peers, etc."

	"do nothing"
]

{ #category : 'construction' }
OPDiagramOnlyViewModel >> createModelIn: aParentModel [
	"creating the diagram element is not the role of a viewmodel"

	
]

{ #category : 'accessing' }
OPDiagramOnlyViewModel >> findParentViewModel [

	| topOwner |
	topOwner := self model topMostOwningElement.

	self
		assert: topOwner ~~ self model
		description:
		'Diagram-only element must have an owning element (typically the diagram)'.

	^ self registry viewModelFor: topOwner modelElement
]

{ #category : 'accessing' }
OPDiagramOnlyViewModel >> icon [

	^ Smalltalk ui icons iconNamed: #empty
]
