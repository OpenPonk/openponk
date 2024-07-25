Class {
	#name : 'OPDiagramSerializer',
	#superclass : 'OPSerializer',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'as yet unclassified' }
OPDiagramSerializer class >> exportSubject [

	^ #diagram
]

{ #category : 'serialize/materialize' }
OPDiagramSerializer >> materializeDiagramOf: aModel from: aStream [
	"materialize aStream into a diagram that will be consumed by your controller"

	^ self subclassResponsibility
]

{ #category : 'serialize/materialize' }
OPDiagramSerializer >> serializeDiagram: aDiagram [
	"Serialize a diagram returned by your controller to a string"

	^ String
		streamContents: [ :stream | self serializeDiagram: aDiagram to: stream ]
]

{ #category : 'serialize/materialize' }
OPDiagramSerializer >> serializeDiagram: aDiagram to: aStream [
	"Serialize a diagram returned by your controller to a string"

	^ self subclassResponsibility
]
