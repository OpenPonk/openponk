"
Unit tests for STON-based model serialization, verifying stream and string roundtrips as well as legacy UUID deserialization.
"
Class {
	#name : 'OPStonModelSerializerTest',
	#superclass : 'OPModelSerializerTest',
	#category : 'OpenPonk-Core-Tests-Persistence',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPStonModelSerializerTest >> serializerClass [

	^ OPStonModelSerializer
]

{ #category : 'tests' }
OPStonModelSerializerTest >> testFromStonLegacyByteArrayUuid [

	| parsedUuid expectedUuid |
	parsedUuid := STON fromString: 'UUID[''0102030405060708090a0b0c0d0e0f10'']'.
	expectedUuid := UUID new
		                uuidData: #[ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ];
		                yourself.
	self assert: parsedUuid equals: expectedUuid
]

{ #category : 'tests' }
OPStonModelSerializerTest >> testRoundtrip [

	| newModel |
	serializer serializeModel: model to: stream.
	newModel := serializer materializeModelFrom: stream contents readStream.
	self deny: newModel identicalTo: model.
	self assert: newModel equals: model
]

{ #category : 'tests' }
OPStonModelSerializerTest >> testSerializeAndMaterializeFromString [

	| serialized materialized |
	self assert: serializer formatName equals: #ston.
	serialized := serializer serializeModel: model.
	materialized := serializer materializeModelFromString: serialized.
	self deny: materialized identicalTo: model.
	self assert: materialized equals: model
]
