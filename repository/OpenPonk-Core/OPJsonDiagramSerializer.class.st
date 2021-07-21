Class {
	#name : #OPJsonDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPJsonDiagramSerializer >> formatName [
	^ 'json'
]

{ #category : #'serialize/materialize' }
OPJsonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	"materialize aStream into a diagram that will be consumed by your controller"

	^ OPDiagram ofModel: aModel fromJson: aStream
]

{ #category : #'serialize/materialize' }
OPJsonDiagramSerializer >> serializeDiagram: aDiagram to: aStream [
	"Serialize a diagram returned by your controller to a string"

	^ aDiagram asJsonTo: aStream
]
