Class {
	#name : #OPDiagramSerializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPDiagramSerializer >> formatName [
	^ 'diagram'
]

{ #category : #'serialize/materialize' }
OPDiagramSerializer >> materializeDiagramFrom: aStream [
	"materialize aStream into a diagram that will be consumed by your controller"

	^ self subclassResponsibility
]

{ #category : #'serialize/materialize' }
OPDiagramSerializer >> materializeDiagramFromString: aString [
	"materialize aString into a diagram that will be consumed by your controller"

	^ self materializeDiagramFrom: aString readStream
]

{ #category : #'serialize/materialize' }
OPDiagramSerializer >> serializeDiagram: aDiagram [
	"Serialize a diagram returned by your controller to a string"

	^ String
		streamContents: [ :stream | self serializeDiagram: aDiagram to: stream ]
]

{ #category : #'serialize/materialize' }
OPDiagramSerializer >> serializeDiagram: aDiagram to: aStream [
	"Serialize a diagram returned by your controller to a string"

	^ self subclassResponsibility
]
