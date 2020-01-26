Class {
	#name : #OPAbstractSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer',
		'root',
		'memento',
		'model'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #testing }
OPAbstractSerializerTest class >> isAbstract [
	^ self = OPAbstractSerializerTest
]

{ #category : #'instance creation' }
OPAbstractSerializerTest >> newMementoWithModel: aModel [
	^ OPPersistenceMemento
		model: aModel
		diagrams: {(OPDiagram defaultDiagramFor: aModel)}
]

{ #category : #'instance creation' }
OPAbstractSerializerTest >> newModel [
	^ OPTestEntityModel new
]

{ #category : #accessing }
OPAbstractSerializerTest >> serializerClass [
	^ self subclassResponsibility
]

{ #category : #running }
OPAbstractSerializerTest >> setUp [
	super setUp.
	serializer := self serializerClass new.
	root := FileSystem memory.
	model := self newModel.
	memento := self newMementoWithModel: model
]

{ #category : #running }
OPAbstractSerializerTest >> testLoadMemento [
	| newMemento |
	serializer saveMemento: memento to: root.
	newMemento := serializer loadMementoFrom: root.
	self deny: newMemento == memento.
	self assert: newMemento uuid equals: memento uuid.
	self assert: newMemento diagram equals: memento diagram
]

{ #category : #tests }
OPAbstractSerializerTest >> testRoundtrip [
	| originalModel loadedModel serialization |
	originalModel := self newModel.
	serialization := serializer serializeModel: originalModel.
	loadedModel := serializer materializeModelFrom: serialization.
	self assert: originalModel equals: loadedModel
]

{ #category : #running }
OPAbstractSerializerTest >> testSaveMemento [
	serializer saveMemento: memento to: root.
	self assert: (root / 'model' , serializer modelExtension) exists.
	self assert: (root / 'diagram' , serializer diagramExtension) exists
]
