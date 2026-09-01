"
Serializer responsible for converting diagram representations to and from STON format.
"
Class {
	#name : 'OPStonDiagramSerializer',
	#superclass : 'OPDiagramSerializer',
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'accessing' }
OPStonDiagramSerializer class >> exportVersion [

	^ 2
]

{ #category : 'formatting' }
OPStonDiagramSerializer class >> formatName [

	^ #ston
]

{ #category : 'accessing' }
OPStonDiagramSerializer class >> minImportVersion [

	^ 1
]

{ #category : 'serialize/materialize' }
OPStonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [

	| diagram innerElements |
	diagram := STON fromStream: aStream.
	innerElements := OPViewModelRegistry forNewProject allChildrenFor:
		                 aModel.
	diagram resolveAllModelElements:
		(innerElements asArray copyWith: aModel).
	^ diagram
]

{ #category : 'serialize/materialize' }
OPStonDiagramSerializer >> serializeDiagram: aDiagram to: aStream [

	^ STON put: aDiagram onStreamPretty: aStream
]
