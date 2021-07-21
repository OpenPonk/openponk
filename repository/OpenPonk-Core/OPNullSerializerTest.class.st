Class {
	#name : #OPNullSerializerTest,
	#superclass : #OPMementoFileSerializerTest,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #accessing }
OPNullSerializerTest >> serializerClass [
	^ OPNullSerializer
]

{ #category : #running }
OPNullSerializerTest >> testLoadMemento [
	self assert: (serializer loadMementoFrom: file) equals: nil
]

{ #category : #tests }
OPNullSerializerTest >> testRoundtrip [
	"do nothing"
]

{ #category : #running }
OPNullSerializerTest >> testSaveMemento [
	serializer saveMemento: memento to: file.
	self deny: file exists
]
