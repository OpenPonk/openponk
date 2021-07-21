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
OPFuelDiagramSerializer >> materialize: aString [
	^ FLMaterializer materializeFromByteArray: aString base64Decoded
]

{ #category : #'serialize/materialize' }
OPFuelDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	^ self materialize: aStream
]

{ #category : #'fuel - serialize/materialize' }
OPFuelDiagramSerializer >> serialize: anObject [
	^ (FLSerializer serializeToByteArray: anObject) base64Encoded
]

{ #category : #'serialize/materialize' }
OPFuelDiagramSerializer >> serializeDiagram: aDiagramMemento [
	^ self serialize: aDiagramMemento
]
