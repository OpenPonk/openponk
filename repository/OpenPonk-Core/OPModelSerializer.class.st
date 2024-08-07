"
I am a serialization interface for undo/redo and persistence.
"
Class {
	#name : 'OPModelSerializer',
	#superclass : 'OPSerializer',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'as yet unclassified' }
OPModelSerializer class >> exportSubject [

	^ #model
]

{ #category : 'serialize/materialize' }
OPModelSerializer >> materializeModelFrom: aStream [
	"materialize aStream into a model instance"

	^ self subclassResponsibility
]

{ #category : 'serialize/materialize' }
OPModelSerializer >> materializeModelFromString: aString [
	"materialize aString into a model instance"

	^ self materializeModelFrom: aString readStream
]

{ #category : 'serialize/materialize' }
OPModelSerializer >> serializeModel: aModel [
	"Serialize a model to a string"

	^ String
		streamContents: [ :stream | self serializeModel: aModel to: stream ]
]

{ #category : 'serialize/materialize' }
OPModelSerializer >> serializeModel: aModel to: aStream [
	"Serialize a model returned by your controller to a stream"

	^ self subclassResponsibility
]
