Class {
	#name : #OPStonDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPStonDiagramSerializer >> formatName [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	^ self stonMaterialize: aStream
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> serializeDiagram: aDiagramMemento [
	^ self stonSerialize: aDiagramMemento
]

{ #category : #'ston - serialize/materialize' }
OPStonDiagramSerializer >> stonMaterialize: aString [
	^ (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next
]

{ #category : #'ston - serialize/materialize' }
OPStonDiagramSerializer >> stonSerialize: anObject [
	^ STON toStringPretty: anObject
]
