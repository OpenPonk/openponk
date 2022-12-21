Class {
	#name : #OPJsonDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPJsonDiagramSerializer class >> exportVersion [

	^ 1
]

{ #category : #formatting }
OPJsonDiagramSerializer class >> formatName [

	^ #json
]

{ #category : #accessing }
OPJsonDiagramSerializer class >> minImportVersion [

	^ 1
]

{ #category : #accessing }
OPJsonDiagramSerializer >> formatName [
	^ 'json'
]

{ #category : #'serialize/materialize' }
OPJsonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	"materialize aStream into a diagram that will be consumed by your controller"

	^ (OPLegacyDiagram ofModel: aModel fromJson: aStream) asOPDiagram
]

{ #category : #'serialize/materialize' }
OPJsonDiagramSerializer >> serializeDiagram: aDiagram to: aStream [
	"Serialize a diagram returned by your controller to a string"

	^ aDiagram asJsonTo: aStream
]
