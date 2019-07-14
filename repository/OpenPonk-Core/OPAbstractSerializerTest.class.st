Class {
	#name : #OPAbstractSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer',
		'root',
		'memento'
	],
	#category : 'OpenPonk-Core-Tests'
}

{ #category : #testing }
OPAbstractSerializerTest class >> isAbstract [
	^ self = OPAbstractSerializerTest
]

{ #category : #'instance creation' }
OPAbstractSerializerTest >> newMemento [
	^ OPPersistenceMemento model: OPTestEntityModel new diagram: {('1' -> '2')} asDictionary
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
	memento := self newMemento
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

{ #category : #running }
OPAbstractSerializerTest >> testSaveMemento [
	serializer saveMemento: memento to: root.
	self assert: (root / 'model' , serializer modelExtension) exists.
	self assert: (root / 'diagram' , serializer diagramExtension) exists
]
