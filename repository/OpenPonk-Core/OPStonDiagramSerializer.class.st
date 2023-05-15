Class {
	#name : #OPStonDiagramSerializer,
	#superclass : #OPDiagramSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPStonDiagramSerializer class >> exportVersion [

	^ 1
]

{ #category : #formatting }
OPStonDiagramSerializer class >> formatName [

	^ #ston
]

{ #category : #accessing }
OPStonDiagramSerializer class >> minImportVersion [

	^ 1
]

{ #category : #accessing }
OPStonDiagramSerializer >> formatName [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> materializeDiagramOf: aModel from: aStream [

	| diagram adapters allModelElements |
	diagram := STON fromStream: aStream.
	adapters := OPNavigatorAdapters new.
	allModelElements := ((Set with: aModel)
	                     , (adapters allChildrenFor: aModel) collect: [ 
		                     :each | each uuid -> each ]) asDictionary.
	diagram resolveAllModelElements: allModelElements.
	^ diagram
]

{ #category : #'serialize/materialize' }
OPStonDiagramSerializer >> serializeDiagram: aDiagram to: aStream [

	^ STON put: aDiagram onStreamPretty: aStream
]
