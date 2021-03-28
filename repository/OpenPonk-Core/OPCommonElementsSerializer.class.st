Class {
	#name : #OPCommonElementsSerializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPCommonElementsSerializer >> formatName [
	^ self subclassResponsibility
]

{ #category : #'serialize/materialize' }
OPCommonElementsSerializer >> materializeAllFrom: aStream [
	"materialize aStream into a collection of model elements"

	^ self subclassResponsibility
]

{ #category : #'serialize/materialize' }
OPCommonElementsSerializer >> materializeAllFromString: aString [
	"materialize aString into a collection of model elements"

	^ self materializeAllFrom: aString readStream
]

{ #category : #'serialize/materialize' }
OPCommonElementsSerializer >> serializeElements: aCollection [
	"Serialize a collection of elements to a string"

	^ String
		streamContents: [ :stream | self serializeElements: aCollection to: stream ]
]

{ #category : #'serialize/materialize' }
OPCommonElementsSerializer >> serializeElements: aModel to: aStream [
	"Serialize a collection of elements to a stream"

	^ self subclassResponsibility
]
