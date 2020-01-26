"
I represent a basic info about the view that is detached from its actual content. I exist mainly to separate per-application info about what is opened/how the views are ordered.
"
Class {
	#name : #OPDiagramInfo,
	#superclass : #Object,
	#instVars : [
		'modelName',
		'modelType',
		'modelVersion',
		'isOpen',
		'isSelected',
		'order',
		'diagramName'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #serializing }
OPDiagramInfo >> asJson [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				mapInstVarsFor: self class;
				nextPut: self ]
]

{ #category : #accessing }
OPDiagramInfo >> diagramName [
	^ diagramName
]

{ #category : #accessing }
OPDiagramInfo >> diagramName: anObject [
	diagramName := anObject
]

{ #category : #testing }
OPDiagramInfo >> isForDiagram: aDiagram [
	^ aDiagram modelType = self modelType
		& (aDiagram modelName = self modelName)
		& (aDiagram modelVersion = self modelVersion)
		& (aDiagram name = self diagramName)
]

{ #category : #accessing }
OPDiagramInfo >> isOpen [
	^ isOpen
]

{ #category : #accessing }
OPDiagramInfo >> isOpen: anObject [
	isOpen := anObject
]

{ #category : #accessing }
OPDiagramInfo >> isSelected [
	^ isSelected
]

{ #category : #accessing }
OPDiagramInfo >> isSelected: anObject [
	isSelected := anObject
]

{ #category : #accessing }
OPDiagramInfo >> model [
	self deprecated: 'We no longer have means to find the project'.
	^ modelName
	"self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	^ self project models
		detect: [ :each | 
			each typeName = self modelType
				and:
					[ each name = self modelName and: [ each version = self modelVersion ] ] ]"
]

{ #category : #accessing }
OPDiagramInfo >> modelName [
	^ modelName
]

{ #category : #accessing }
OPDiagramInfo >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
OPDiagramInfo >> modelType [
	^ modelType
]

{ #category : #accessing }
OPDiagramInfo >> modelType: anObject [
	modelType := anObject
]

{ #category : #accessing }
OPDiagramInfo >> modelVersion [
	^ modelVersion
]

{ #category : #accessing }
OPDiagramInfo >> modelVersion: anObject [
	modelVersion := anObject
]

{ #category : #accessing }
OPDiagramInfo >> order [
	^ order
]

{ #category : #accessing }
OPDiagramInfo >> order: anObject [
	order := anObject
]

{ #category : #printing }
OPDiagramInfo >> printOn: aStream [
	super printOn: aStream.
	aStream << '(' << self diagramName printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'
]
