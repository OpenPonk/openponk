"
Serializer responsible for converting diagram representations (visual layouts and configuration) to and from JSON format.
"
Class {
	#name : 'OPJsonDiagramSerializer',
	#superclass : 'OPDiagramSerializer',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPJsonDiagramSerializer class >> exportVersion [

	^ 1
]

{ #category : 'formatting' }
OPJsonDiagramSerializer class >> formatName [

	^ #json
]

{ #category : 'accessing' }
OPJsonDiagramSerializer class >> minImportVersion [

	^ 1
]

{ #category : 'serialize/materialize' }
OPJsonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [

	"materialize aStream into a diagram that will be consumed by your controller"

	^ (OPLegacyDiagram ofModel: aModel fromJson: aStream) asOPDiagram
]

{ #category : 'serialize/materialize' }
OPJsonDiagramSerializer >> serializeDiagram: aDiagram to: aStream [
	"Legacy JSON diagram export is no longer supported; diagrams are serialized with OPStonDiagramSerializer."

	self shouldNotImplement
]
