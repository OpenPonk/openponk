"
Serializer responsible for converting domain models to and from STON format. 
Serialization strips active Announcers; event bindings must be reestablished post-materialization.
"
Class {
	#name : 'OPStonModelSerializer',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPStonModelSerializer class >> exportVersion [

	^ 2
]

{ #category : 'formatting' }
OPStonModelSerializer class >> formatName [

	^ #ston
]

{ #category : 'accessing' }
OPStonModelSerializer class >> minImportVersion [

	^ 1
]

{ #category : 'serialize/materialize' }
OPStonModelSerializer >> materializeModelFrom: aStream [
	^ self stonMaterialize: aStream
]

{ #category : 'serialize/materialize' }
OPStonModelSerializer >> serializeModel: aModel to: aStream [
	^ self stonSerialize: aModel to: aStream
]

{ #category : 'ston - serialize/materialize' }
OPStonModelSerializer >> stonMaterialize: aStream [
	^ STON fromStream: aStream
]

{ #category : 'ston - serialize/materialize' }
OPStonModelSerializer >> stonSerialize: anObject to: aStream [
	^ STON put: anObject onStreamPretty: aStream
]
