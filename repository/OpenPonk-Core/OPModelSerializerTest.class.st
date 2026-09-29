"
Abstract base class for testing model serializers. 
Verifies that models successfully roundtrip (serialize and deserialize) without data loss or corruption.
"
Class {
	#name : 'OPModelSerializerTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'serializer',
		'stream'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPModelSerializerTest class >> isAbstract [
	^ self = OPModelSerializerTest
]

{ #category : 'accessing' }
OPModelSerializerTest >> newModel [
	^ OPTestEntityModel new
]

{ #category : 'accessing' }
OPModelSerializerTest >> serializerClass [
	^ self subclassResponsibility
]

{ #category : 'running' }
OPModelSerializerTest >> setUp [
	super setUp.
	serializer := self serializerClass new.
	model := self newModel.
	stream := WriteStream on: ''
]

{ #category : 'tests' }
OPModelSerializerTest >> testRoundtrip [
	| newModel |
	serializer serializeModel: model to: stream.
	newModel := serializer materializeModelFrom: stream.
	self deny: newModel identicalTo: model.
	self assert: newModel equals: model
]
