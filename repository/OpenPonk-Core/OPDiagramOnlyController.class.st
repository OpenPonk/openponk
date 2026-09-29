"
Controller for diagram-only elements (such as notes or boundaries). 
Operates without a distinct domain model, utilizing the diagram element itself as the primary model.
"
Class {
	#name : 'OPDiagramOnlyController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'accessing' }
OPDiagramOnlyController class >> modelClass [

	^ self subclassResponsibility
]

{ #category : 'constants' }
OPDiagramOnlyController class >> paletteItemName [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPDiagramOnlyController class >> viewModelClass [

	^ OPDiagramOnlyViewModel
]

{ #category : 'construction' }
OPDiagramOnlyController >> createDiagramElement [

	^ self diagramElement:
		  (self diagramElementClass in: self intendedOwningDiagramElement)
]

{ #category : 'construction' }
OPDiagramOnlyController >> createModelIn: aParentModel [
	| newModel |
	newModel := self diagramElementClass in: self intendedOwningDiagramElement.
	
	self model: newModel.
	^ self model
]

{ #category : 'accessing' }
OPDiagramOnlyController >> diagramElement: aDiagramElement [

	super diagramElement: aDiagramElement.
	self viewModel ifNotNil: [
		self viewModel model = aDiagramElement ifTrue: [ ^ aDiagramElement ] ].
	self model: aDiagramElement.
	^ aDiagramElement
]

{ #category : 'accessing' }
OPDiagramOnlyController >> ensureDiagramElement [

	^ self diagramElement ifNotExists: [ self createDiagramElement ]
]

{ #category : 'diagram elements' }
OPDiagramOnlyController >> intendedModelOfOwningDiagramElement [

	^ self diagramController model
]

{ #category : 'testing' }
OPDiagramOnlyController >> isCommon [
	^ true
]

{ #category : 'testing' }
OPDiagramOnlyController >> isDiagramOnly [

	^ true
]

{ #category : 'testing' }
OPDiagramOnlyController >> isHideable [

	^ false
]

{ #category : 'accessing' }
OPDiagramOnlyController >> model [

	^ self diagramElement
]

{ #category : 'accessing' }
OPDiagramOnlyController >> model: aModel [

	super model: aModel.
	diagramElement = aModel ifFalse: [ self diagramElement: aModel ]
]

{ #category : 'constants' }
OPDiagramOnlyController >> paletteItemName [
	^ self class paletteItemName
]

{ #category : 'removing' }
OPDiagramOnlyController >> removeModel [

	"do nothing - common model elements are not part of any model"

	
]

{ #category : 'validation' }
OPDiagramOnlyController >> validate [
	"nothing to validate"

	
]
