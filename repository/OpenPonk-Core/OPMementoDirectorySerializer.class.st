Class {
	#name : 'OPMementoDirectorySerializer',
	#superclass : 'OPMementoSerializer',
	#instVars : [
		'rootFolder'
	],
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'as yet unclassified' }
OPMementoDirectorySerializer class >> exportVersion [

	^ 1
]

{ #category : 'formatting' }
OPMementoDirectorySerializer class >> formatName [

	^ #directory
]

{ #category : 'accessing' }
OPMementoDirectorySerializer class >> minImportVersion [

	^ 1
]

{ #category : 'loading' }
OPMementoDirectorySerializer >> loadDiagramOf: aModel from: aFile by: aDiagramMaterializer [
	^ aDiagramMaterializer
		materializeDiagramOf: aModel
		from: aFile readStream
]

{ #category : 'loading' }
OPMementoDirectorySerializer >> loadDiagramsOf: aModel from: aFolder [

	| materializer |
	aFolder exists ifFalse: [ ^ #(  ) ].
	materializer := aFolder files
		                detect: [ :any |
		                any basename = OPExportInfo fileName ]
		                ifFound: [ :exportInfoFile |
		                OPSerializer forExportInfoFile: exportInfoFile ]
		                ifNone: [ OPJsonDiagramSerializer new ].
	^ aFolder files
		  select: [ :any |
			  (materializer fileExtensions includes: any extension) and: [
				  any basename ~= OPExportInfo fileName ] ]
		  thenCollect: [ :eachFile |
			  self loadDiagramOf: aModel from: eachFile by: materializer ]
]

{ #category : 'loading' }
OPMementoDirectorySerializer >> loadMementoFrom: aFolder [

	| model modelDir |
	modelDir := aFolder / 'model'.
	(modelDir exists and: [ modelDir isDirectory ]) ifFalse: [
		modelDir := aFolder ].
	model := self loadModelFrom: modelDir.
	^ OPMemento
		  model: model
		  diagrams: (self loadDiagramsOf: model from: aFolder / 'diagrams')
]

{ #category : 'loading' }
OPMementoDirectorySerializer >> loadModelFrom: aFolder [

	| modelFile materializer |
	materializer := aFolder files
		                detect: [ :any |
		                any basename = OPExportInfo fileName ]
		                ifFound: [ :exportInfoFile |
			                plugin modelSerializerClass forExportInfoFile:
				                exportInfoFile ]
		                ifNone: [ plugin modelSerializerClass new ].

	modelFile := aFolder files
		             detect: [ :anyFile |
			             materializer fileExtensions anySatisfy: [
				             :anyExtension |
				             anyFile basename = ('model.' , anyExtension) ] ]
		             ifNone: [
			             self error:
				             'Failed to find model file in .opp'
				             , aFolder absolutePath pathString ].
	^ modelFile readStreamDo: [ :stream |
		  materializer materializeModelFrom: stream ]
]

{ #category : 'saving' }
OPMementoDirectorySerializer >> saveDiagram: aDiagram to: aFolder index: aNumber [

	| diagramSerializer |
	diagramSerializer := OPStonDiagramSerializer new.
	(aFolder
	 / (aNumber asString , '-' , (aDiagram name ifEmpty: [ 'diagram' ]))
	 , diagramSerializer fileExtension)
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (diagramSerializer serializeDiagram: aDiagram) ]
]

{ #category : 'saving' }
OPMementoDirectorySerializer >> saveDiagramsOf: aMemento to: aFolder [

	aMemento diagrams ifEmpty: [ ^ self ].
	aFolder ensureCreateDirectory.
	OPStonDiagramSerializer saveExportInfoTo: aFolder.
	aMemento diagrams withIndexDo: [ :each :index | 
		self saveDiagram: each to: aFolder index: index ]
]

{ #category : 'saving' }
OPMementoDirectorySerializer >> saveMemento: aMemento to: aFolder [

	| modelDirectory |
	aFolder ensureCreateDirectory.
	self class saveExportInfoTo: aFolder.
	modelDirectory := aFolder / 'model'.
	modelDirectory ensureCreateDirectory.
	self saveModelOf: aMemento to: modelDirectory.
	self saveDiagramsOf: aMemento to: aFolder / 'diagrams'
]

{ #category : 'saving' }
OPMementoDirectorySerializer >> saveModelOf: aMemento to: aFolder [

	| modelSerializer |
	modelSerializer := plugin modelSerializerClass new.
	modelSerializer class saveExportInfoTo: aFolder.
	(aFolder / 'model' , modelSerializer fileExtension)
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (modelSerializer serializeModel: aMemento model) ]
]
