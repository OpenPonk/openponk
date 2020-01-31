"
I use Fuel format as a simple serialization strategy.

!! Warning

If your model relies on Announements to propagate updates between elements, the links will be broken as Announcer will be ommited during serialization.
"
Class {
	#name : #OPFuelSerializer,
	#superclass : #OPSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPFuelSerializer >> formatName [
	^ 'fuel'
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> fuelMaterialize: aString [
	^ FLMaterializer materializeFromByteArray: aString base64Decoded
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> fuelSerialize: anObject [
	^ (FLSerializer serializeToByteArray: anObject) base64Encoded
]

{ #category : #convenience }
OPFuelSerializer >> materializeMementoFrom: aString [
	^ self fuelMaterialize: aString
]

{ #category : #convenience }
OPFuelSerializer >> serializeMemento: aMemento [
	^ self fuelSerialize: aMemento
]
