Class {
	#name : #OPModelSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'serializer',
		'stream'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #testing }
OPModelSerializerTest class >> isAbstract [
	^ self = OPModelSerializerTest
]

{ #category : #accessing }
OPModelSerializerTest >> newModel [
	^ OPTestEntityModel new
]

{ #category : #accessing }
OPModelSerializerTest >> serializerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPModelSerializerTest >> setUp [
	super setUp.
	serializer := self serializerClass new.
	model := self newModel.
	stream := WriteStream on: ''
]

{ #category : #tests }
OPModelSerializerTest >> testRoundtrip [
	| newModel |
	serializer serializeModel: model to: stream.
	newModel := serializer materializeModelFrom: stream.
	self deny: newModel identicalTo: model.
	self assert: newModel equals: model
]
