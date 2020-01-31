Class {
	#name : #OPNullSerializerTest,
	#superclass : #OPAbstractSerializerTest,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #accessing }
OPNullSerializerTest >> modelSerializerClass [
	^ OPNullSerializer
]

{ #category : #running }
OPNullSerializerTest >> testLoadMemento [
	self assert: (serializer loadMementoFrom: root) equals: nil
]

{ #category : #tests }
OPNullSerializerTest >> testRoundtrip [
	"do nothing"
]

{ #category : #running }
OPNullSerializerTest >> testSaveMemento [
	serializer saveMemento: memento to: root.
	self deny: (root / 'model' , serializer modelExtension) exists.
	self deny: (root / 'diagram' , serializer formatName) exists
]
