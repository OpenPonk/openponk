Class {
	#name : #OPDirectorySerializer,
	#superclass : #OPSerializer,
	#instVars : [
		'modelSerializer',
		'diagramSerializer'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPDirectorySerializer class >> withModelSerializer: aModelSerializer diagramsSerializer: aDiagramsSerializer [
	^ self new
		modelSerializer: aModelSerializer;
		diagramSerializer: aDiagramsSerializer;
		yourself
]

{ #category : #accessing }
OPDirectorySerializer >> diagramSerializer: aDiagramSerializer [
	diagramSerializer := aDiagramSerializer
]

{ #category : #accessing }
OPDirectorySerializer >> formatName [
	^ self subclassResponsibility
]

{ #category : #loading }
OPDirectorySerializer >> loadDiagramFrom: aFile [
	^ diagramSerializer materializeDiagramFrom: aFile readStream
]

{ #category : #loading }
OPDirectorySerializer >> loadDiagramsFrom: aFolder [
	aFolder exists
		ifFalse: [ ^ #() ].
	^ (aFolder filesMatching: '*.' , diagramSerializer formatName)
		collect: [ :eachFile | self loadDiagramFrom: eachFile ]
]

{ #category : #loading }
OPDirectorySerializer >> loadMementoFrom: aFolder [
	^ OPPersistenceMemento
		model: (self loadModelFrom: aFolder)
		diagrams: (self loadDiagramsFrom: aFolder)
]

{ #category : #loading }
OPDirectorySerializer >> loadModelFrom: aFolder [
	| modelFile |
	modelFile := aFolder / 'model' , modelSerializer formatName.
	modelFile exists
		ifFalse: [ ^ nil ].
	^ modelFile
		readStreamDo: [ :stream | modelSerializer materializeModelFrom: stream ]
]

{ #category : #accessing }
OPDirectorySerializer >> modelSerializer: aModelSerializer [
	modelSerializer := aModelSerializer
]

{ #category : #saving }
OPDirectorySerializer >> saveDiagram: aDiagram to: aFolder [
	(aFolder
		/
		(aDiagram order asString , '-'
		, (aDiagram name ifEmpty: [ 'diagram' ]))
		, diagramSerializer formatName)
		ensureDelete;
		writeStreamDo:
				[ :stream | stream nextPutAll: (diagramSerializer serializeDiagram: aDiagram) ]
]

{ #category : #saving }
OPDirectorySerializer >> saveDiagramsOf: aMemento to: aFolder [
	aMemento diagrams ifEmpty: [ ^ self ].
	aFolder ensureCreateDirectory.
	aMemento diagrams do: [ :each | self saveDiagram: each to: aFolder ]
]

{ #category : #saving }
OPDirectorySerializer >> saveMemento: aMemento to: aFolder [
	self saveModelOf: aMemento to: aFolder.
	self saveDiagramsOf: aMemento to: aFolder / 'diagrams'
]

{ #category : #saving }
OPDirectorySerializer >> saveModelOf: aMemento to: aFolder [
	(aFolder / 'model' , modelSerializer formatName)
		ensureDelete;
		writeStreamDo:
				[ :stream | stream nextPutAll: (modelSerializer serializeModel: aMemento model) ]
]
