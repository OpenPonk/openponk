Class {
	#name : #OPStonSerializer,
	#superclass : #OPMementoFileSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPStonSerializer >> formatName [
	^ 'ston'
]

{ #category : #saving }
OPStonSerializer >> materializeFrom: aStream [
	^ STON fromStream: aStream
]

{ #category : #'ston - serialize/materialize' }
OPStonSerializer >> serialize: anObject to: aStream [
	STON put: anObject onStreamPretty: aStream
]
