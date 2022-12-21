Class {
	#name : #OPMementoFileSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer',
		'memento',
		'model',
		'file'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #testing }
OPMementoFileSerializerTest class >> isAbstract [
	^ self = OPMementoFileSerializerTest
]

{ #category : #'instance creation' }
OPMementoFileSerializerTest >> newMementoWithModel: aModel [

	^ OPPersistenceMemento
		  model: aModel
		  diagrams: { (OPLegacyDiagram emptyOfModel: aModel) }
]

{ #category : #'instance creation' }
OPMementoFileSerializerTest >> newModel [
	^ OPTestEntityModel new
]

{ #category : #accessing }
OPMementoFileSerializerTest >> serializerClass [
	^ self subclassResponsibility
]

{ #category : #running }
OPMementoFileSerializerTest >> setUp [
	super setUp.
	serializer := self serializerClass new.
	model := self newModel.
	file := FileSystem memory / 'diagram'.
	memento := self newMementoWithModel: model
]

{ #category : #running }
OPMementoFileSerializerTest >> testLoadMemento [
	| newMemento |
	serializer saveMemento: memento to: file.
	newMemento := serializer loadMementoFrom: file.
	self deny: newMemento == memento.
	self assert: newMemento uuid equals: memento uuid.
	self assert: newMemento diagrams first equals: memento diagrams first
]

{ #category : #tests }
OPMementoFileSerializerTest >> testRoundtrip [
	| newMemento |
	serializer saveMemento: memento to: file.
	newMemento := serializer loadMementoFrom: file.
	self assert: memento equals: newMemento
]

{ #category : #running }
OPMementoFileSerializerTest >> testSaveMemento [
	serializer saveMemento: memento to: file.
	self assert: file exists.
	self deny: file size isZero
]
