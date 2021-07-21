"
I use Fuel format as a simple serialization strategy.

!! Warning

If your model relies on Announements to propagate updates between elements, the links will be broken as Announcer will be ommited during serialization.
"
Class {
	#name : #OPFuelSerializer,
	#superclass : #OPMementoFileSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPFuelSerializer >> formatName [
	^ 'fuel'
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> materializeFrom: aStream [
	^ FLMaterializer
		materializeFromByteArray: aStream upToEnd base64Decoded
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> serialize: anObject to: aStream [
	aStream
		<< (FLSerializer serializeToByteArray: anObject) base64Encoded
]
