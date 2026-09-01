"
Represents basic metadata about a diagram view (such as name, order, and selection state) detached from its actual content.
Exists primarily to track per-application information regarding opened views and their arrangement.
"
Class {
	#name : 'OPDiagramInfo',
	#superclass : 'Object',
	#instVars : [
		'modelName',
		'modelType',
		'isOpen',
		'isSelected',
		'order',
		'diagramName'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'testing' }
OPDiagramInfo class >> isDeprecated [
	"no longer tested and used"

	^ true
]

{ #category : 'serializing' }
OPDiagramInfo >> asJson [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				mapInstVarsFor: self class;
				nextPut: self ]
]

{ #category : 'accessing' }
OPDiagramInfo >> diagramName [
	^ diagramName
]

{ #category : 'accessing' }
OPDiagramInfo >> diagramName: anObject [
	diagramName := anObject
]

{ #category : 'testing' }
OPDiagramInfo >> isForDiagram: aDiagram [
	^ aDiagram modelType = self modelType
		& (aDiagram modelName = self modelName)
		& (aDiagram name = self diagramName)
]

{ #category : 'accessing' }
OPDiagramInfo >> isOpen [
	^ isOpen
]

{ #category : 'accessing' }
OPDiagramInfo >> isOpen: anObject [
	isOpen := anObject
]

{ #category : 'accessing' }
OPDiagramInfo >> isSelected [
	^ isSelected
]

{ #category : 'accessing' }
OPDiagramInfo >> isSelected: anObject [
	isSelected := anObject
]

{ #category : 'accessing - deprecated' }
OPDiagramInfo >> model [
    self deprecated: 'We no longer have means to find the project'.
    ^ nil
]

{ #category : 'accessing' }
OPDiagramInfo >> modelName [
	^ modelName
]

{ #category : 'accessing' }
OPDiagramInfo >> modelName: anObject [
	modelName := anObject
]

{ #category : 'accessing' }
OPDiagramInfo >> modelType [
	^ modelType
]

{ #category : 'accessing' }
OPDiagramInfo >> modelType: anObject [
	modelType := anObject
]

{ #category : 'accessing' }
OPDiagramInfo >> order [
	^ order
]

{ #category : 'accessing' }
OPDiagramInfo >> order: anObject [
	order := anObject
]

{ #category : 'printing' }
OPDiagramInfo >> printOn: aStream [

	super printOn: aStream.
	aStream << '('.
	self diagramName printOn: aStream.
	aStream << '@'.
	self modelName printOn: aStream.
	aStream << '-' << ')'
]
