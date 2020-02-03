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

{ #category : #'ston - serialize/materialize' }
OPStonDiagramSerializer >> serialize: anObject [
	^ STON toStringPretty: anObject
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> serializeDiagram: aDiagramMemento [
	^ self serialize: aDiagramMemento
]

{ #category : #'ston - serialize/materialize' }
OPStonDiagramSerializer >> stonMaterialize: aString [
	^ (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next
]
