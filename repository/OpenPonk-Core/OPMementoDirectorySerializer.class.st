Class {
	#name : #OPMementoDirectorySerializer,
	#superclass : #OPMementoSerializer,
	#instVars : [
		'rootFolder',
		'modelSerializer',
		'diagramSerializer',
		'commonElementsSerializer'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPMementoDirectorySerializer class >> withModelSerializer: aModelSerializer diagramsSerializer: aDiagramsSerializer [
	^ self new
		modelSerializer: aModelSerializer;
		diagramSerializer: aDiagramsSerializer;
		yourself
]

{ #category : #accessing }
OPMementoDirectorySerializer >> commonElementsSerializer: aCommonElementsSerializer [
	commonElementsSerializer := aCommonElementsSerializer
]

{ #category : #accessing }
OPMementoDirectorySerializer >> diagramSerializer: aDiagramSerializer [
	diagramSerializer := aDiagramSerializer
]

{ #category : #initialization }
OPMementoDirectorySerializer >> initialize [
	super initialize.
	commonElementsSerializer := OPStonCommonElementsSerializer new
]

{ #category : #loading }
OPMementoDirectorySerializer >> loadDiagramOf: aModel from: aFile [
	^ diagramSerializer
		materializeDiagramOf: aModel
		from: aFile readStream
]

{ #category : #loading }
OPMementoDirectorySerializer >> loadDiagramsOf: aModel from: aFolder [
	aFolder exists
		ifFalse: [ ^ #() ].
	^ (aFolder filesMatching: '*.' , diagramSerializer formatName)
		collect: [ :eachFile | self loadDiagramOf: aModel from: eachFile ]
]

{ #category : #loading }
OPMementoDirectorySerializer >> loadMementoFrom: aFolder [
	| model |
	model := self loadModelFrom: aFolder.
	^ OPPersistenceMemento
		model: model
		diagrams: (self loadDiagramsOf: model from: aFolder / 'diagrams')
]

{ #category : #loading }
OPMementoDirectorySerializer >> loadModelFrom: aFolder [
	| modelFile |
	modelFile := aFolder / 'model' , modelSerializer formatName.
	modelFile exists
		ifFalse: [ ^ nil ].
	^ modelFile
		readStreamDo: [ :stream | modelSerializer materializeModelFrom: stream ]
]

{ #category : #accessing }
OPMementoDirectorySerializer >> modelSerializer: aModelSerializer [
	modelSerializer := aModelSerializer
]

{ #category : #saving }
OPMementoDirectorySerializer >> saveDiagram: aDiagram to: aFolder [
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
OPMementoDirectorySerializer >> saveDiagramsOf: aMemento to: aFolder [
	aMemento diagrams ifEmpty: [ ^ self ].
	aFolder ensureCreateDirectory.
	aMemento diagrams do: [ :each | self saveDiagram: each to: aFolder ]
]

{ #category : #saving }
OPMementoDirectorySerializer >> saveMemento: aMemento to: aFolder [
	aFolder ensureCreateDirectory.
	self saveModelOf: aMemento to: aFolder.
	self saveDiagramsOf: aMemento to: aFolder / 'diagrams'
]

{ #category : #saving }
OPMementoDirectorySerializer >> saveModelOf: aMemento to: aFolder [
	(aFolder / 'model' , modelSerializer formatName)
		ensureDelete;
		writeStreamDo:
				[ :stream | stream nextPutAll: (modelSerializer serializeModel: aMemento model) ]
]
