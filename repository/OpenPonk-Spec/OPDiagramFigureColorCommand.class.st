Class {
	#name : #OPDiagramFigureColorCommand,
	#superclass : #OPDiagramFigureCommand,
	#instVars : [
		'niceColorName'
	],
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigureColorCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
		  aToolContext controllers anySatisfy: [ :any |
			  any diagramElement supportsColorChangeOfType: self colorAttribute ] ]
]

{ #category : #accessing }
OPDiagramFigureColorCommand class >> colorAttribute [

	^ self subclassResponsibility
]

{ #category : #testing }
OPDiagramFigureColorCommand class >> isAbstract [

	^ self = OPDiagramFigureColorCommand or: [
		  self superclass = OPDiagramFigureColorCommand ]
]

{ #category : #accessing }
OPDiagramFigureColorCommand >> color [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPDiagramFigureColorCommand >> colorAttribute [
	^ self class colorAttribute
]

{ #category : #accessing }
OPDiagramFigureColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: self color;
				asFormOfSize: 30@20
]

{ #category : #accessing }
OPDiagramFigureColorCommand >> defaultMenuItemName [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPDiagramFigureColorCommand >> execute [

	controllers collect: #diagramElement thenDo: [ :each |
		(each supportsColorChangeOfType: self colorAttribute) ifTrue: [
			each stylePropertyNamed: self colorAttribute put: self color ] ]
]
