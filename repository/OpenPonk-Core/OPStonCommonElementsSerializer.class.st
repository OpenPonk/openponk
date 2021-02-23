Class {
	#name : #OPStonCommonElementsSerializer,
	#superclass : #OPCommonElementsSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPStonCommonElementsSerializer >> formatName [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonCommonElementsSerializer >> materializeAllFrom: aStream [
	^ self stonMaterialize: aStream
]

{ #category : #'serialize/materialize' }
OPStonCommonElementsSerializer >> serializeModel: aModel to: aStream [
	^ self stonSerialize: aModel to: aStream
]

{ #category : #'ston - serialize/materialize' }
OPStonCommonElementsSerializer >> stonMaterialize: aStream [
	^ STON fromStream: aStream
]

{ #category : #'ston - serialize/materialize' }
OPStonCommonElementsSerializer >> stonSerialize: anObject to: aStream [
	^ STON put: anObject onStreamPretty: aStream
]
