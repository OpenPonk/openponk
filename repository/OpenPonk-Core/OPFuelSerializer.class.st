"
I use Fuel format as a simple serialization strategy.

!! Warning

If your model relies on Announements to propagate updates between elements, the links will be broken as Announcer will be ommited during serialization.
"
Class {
	#name : #OPFuelSerializer,
	#superclass : #OPAbstractSerializer,
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPFuelSerializer >> diagramExtension [
	^ 'fuel'
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> fuelMaterialize: aString [
	^ FLMaterializer
		materializeFromByteArray: (Base64MimeConverter mimeDecodeToBytes: aString readStream)
]

{ #category : #'fuel - serialize/materialize' }
OPFuelSerializer >> fuelSerialize: anObject [
	^ (Base64MimeConverter
		mimeEncode: (FLSerializer serializeToByteArray: anObject) readStream) contents
]

{ #category : #'serialize/materialize' }
OPFuelSerializer >> materializeDiagramFrom: aString [
	^ self fuelMaterialize: aString
]

{ #category : #convenience }
OPFuelSerializer >> materializeMementoFrom: aString [
	^ self fuelMaterialize: aString
]

{ #category : #'serialize/materialize' }
OPFuelSerializer >> materializeModelFrom: aString [
	^ self fuelMaterialize: aString
]

{ #category : #accessing }
OPFuelSerializer >> modelExtension [
	^ 'fuel'
]

{ #category : #'serialize/materialize' }
OPFuelSerializer >> serializeDiagram: aDiagramMemento [
	^ self fuelSerialize: aDiagramMemento
]

{ #category : #convenience }
OPFuelSerializer >> serializeMemento: aMemento [
	^ self fuelSerialize: aMemento
]

{ #category : #'serialize/materialize' }
OPFuelSerializer >> serializeModel: aModel [
	^ self fuelSerialize: aModel
]
