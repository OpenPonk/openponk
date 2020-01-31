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
OPFuelModelSerializer >> fuelMaterialize: aString [
	^ FLMaterializer materializeFromByteArray: aString base64Decoded
]

{ #category : #'fuel - serialize/materialize' }
OPFuelModelSerializer >> fuelSerialize: anObject [
	^ (FLSerializer serializeToByteArray: anObject) base64Encoded
]

{ #category : #'serialize/materialize' }
OPFuelModelSerializer >> materializeModelFrom: aString [
	^ self fuelMaterialize: aString
]

{ #category : #'serialize/materialize' }
OPFuelModelSerializer >> serializeModel: aModel [
	^ self fuelSerialize: aModel
]
