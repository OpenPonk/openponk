"
I represent a basic info about the view that is detached from its actual content. I exist mainly to separate per-application info about what is opened/how the views are ordered.
"
Class {
	#name : #OPDiagramViewInfo,
	#superclass : #Object,
	#instVars : [
		'modelName',
		'modelType',
		'modelVersion',
		'viewName',
		'isOpen',
		'isSelected',
		'order'
	],
	#category : #'OpenPonk-Core-Views'
}

{ #category : #serializing }
OPDiagramViewInfo >> asJson [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				mapInstVarsFor: self class;
				nextPut: self ]
]

{ #category : #testing }
OPDiagramViewInfo >> isForView: aView [
	^ aView modelType = self modelType & (aView modelName = self modelName)
		& (aView modelVersion = self modelVersion) & (aView name = self viewName)
]

{ #category : #accessing }
OPDiagramViewInfo >> isOpen [
	^ isOpen
]

{ #category : #accessing }
OPDiagramViewInfo >> isOpen: anObject [
	isOpen := anObject
]

{ #category : #accessing }
OPDiagramViewInfo >> isSelected [
	^ isSelected
]

{ #category : #accessing }
OPDiagramViewInfo >> isSelected: anObject [
	isSelected := anObject
]

{ #category : #accessing }
OPDiagramViewInfo >> model [
	self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	^ self project models
		detect: [ :each | 
			each typeName = self modelType
				and: [ each name = self modelName and: [ each version = self modelVersion ] ] ]
]

{ #category : #accessing }
OPDiagramViewInfo >> modelName [
	^ modelName
]

{ #category : #accessing }
OPDiagramViewInfo >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
OPDiagramViewInfo >> modelType [
	^ modelType
]

{ #category : #accessing }
OPDiagramViewInfo >> modelType: anObject [
	modelType := anObject
]

{ #category : #accessing }
OPDiagramViewInfo >> modelVersion [
	^ modelVersion
]

{ #category : #accessing }
OPDiagramViewInfo >> modelVersion: anObject [
	modelVersion := anObject
]

{ #category : #accessing }
OPDiagramViewInfo >> order [
	^ order
]

{ #category : #accessing }
OPDiagramViewInfo >> order: anObject [
	order := anObject
]

{ #category : #printing }
OPDiagramViewInfo >> printOn: aStream [
	super printOn: aStream.
	aStream << '(' << self viewName printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'
]

{ #category : #accessing }
OPDiagramViewInfo >> viewName [
	^ viewName
]

{ #category : #accessing }
OPDiagramViewInfo >> viewName: anObject [
	viewName := anObject
]
