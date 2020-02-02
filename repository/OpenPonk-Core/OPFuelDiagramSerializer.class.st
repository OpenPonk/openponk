Class {
	#name : #OPFuelDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPFuelDiagramSerializer >> formatName [
	^ 'fuel'
]

{ #category : #'fuel - serialize/materialize' }
OPFuelDiagramSerializer >> fuelMaterialize: aString [
	^ FLMaterializer materializeFromByteArray: aString base64Decoded
]

{ #category : #'fuel - serialize/materialize' }
OPFuelDiagramSerializer >> fuelSerialize: anObject [
	^ (FLSerializer serializeToByteArray: anObject) base64Encoded
]

{ #category : #'serialize/materialize' }
OPFuelDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	^ self fuelMaterialize: aStream
]

{ #category : #'serialize/materialize' }
OPFuelDiagramSerializer >> serializeDiagram: aDiagramMemento [
	^ self fuelSerialize: aDiagramMemento
]
