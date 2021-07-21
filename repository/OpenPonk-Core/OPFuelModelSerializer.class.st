Class {
	#name : #OPFuelModelSerializer,
	#superclass : #OPModelSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPFuelModelSerializer >> formatName [
	^ 'fuel'
]

{ #category : #'fuel - serialize/materialize' }
OPFuelModelSerializer >> materialize: aString [
	^ FLMaterializer materializeFromByteArray: aString base64Decoded
]

{ #category : #'serialize/materialize' }
OPFuelModelSerializer >> materializeModelFrom: aStream [
	^ self materialize: aStream
]

{ #category : #'fuel - serialize/materialize' }
OPFuelModelSerializer >> serialize: anObject [
	^ (FLSerializer serializeToByteArray: anObject) base64Encoded
]

{ #category : #'serialize/materialize' }
OPFuelModelSerializer >> serializeModel: aModel [
	^ self serialize: aModel
]

{ #category : #accessing }
OPFuelModelSerializer >> serializeModel: aModel to: aStream [
	^ aStream << (self serializeModel: aModel)
]
