"
I take a folder and try to materialize a project from it.
"
Class {
	#name : #OPProjectDirectoryMaterializer,
	#superclass : #OPSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'as yet unclassified' }
OPProjectDirectoryMaterializer class >> exportSubject [

	^ #project
]

{ #category : #'as yet unclassified' }
OPProjectDirectoryMaterializer class >> exportVersion [

	^ 0
]

{ #category : #formatting }
OPProjectDirectoryMaterializer class >> formatName [

	^ #directory
]

{ #category : #accessing }
OPProjectDirectoryMaterializer class >> maxImportVersion [

	^ 1
]

{ #category : #accessing }
OPProjectDirectoryMaterializer class >> minImportVersion [

	^ 1
]

{ #category : #accessing }
OPProjectDirectoryMaterializer >> exporter [
	^ 'OpenPonk'
]

{ #category : #'public - reading' }
OPProjectDirectoryMaterializer >> loadProjectFrom: aFolder [
	| project |
	project := self readProjectInfoFrom: aFolder / 'project.json'.
	(self readAllMementosFrom: aFolder)
		do: [ :each | 
			project addModel: each model.
			project addDiagrams: each diagrams ].
	^ project
]

{ #category : #accessing }
OPProjectDirectoryMaterializer >> modelIdFrom: aString [
	aString size = 36
		ifTrue: [ ^ UUID fromString: aString ].
	(NumberParser isNumber: aString)
		ifTrue: [ ^ aString asNumber ].
	^ aString
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> pluginForName: aName pluginVersion: aVersion [
	| plugin |
	plugin := OPPluginRegistry default plugins
		detect: [ :each | each className = aName and: [ each version = aVersion ] ]
		ifNone: [ ^ self error: 'Unrecognized plugin ' , aName , ' version ' , aVersion ].
	^ plugin
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> readAllMementosFrom: aRootFolder [
	| references |
	references := self readModelReferences: aRootFolder.	
	^ references
		collect: [ :pair | 
			self
				readMementoFrom: aRootFolder / 'models' / pair key asString
				asPlugin: pair value ]
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> readMementoFrom: aFolder asPlugin: aPlugin [

	| materializer |
	materializer := aFolder files
		                detect: [ :any | 
		                any basename = OPExportInfo fileName ]
		                ifFound: [ :exportInfoFile | 
			                (OPSerializer forExportInfoFile: exportInfoFile)
				                plugin: aPlugin;
				                yourself ]
		                ifNone: [ aPlugin serializer ].
	^ (materializer loadMementoFrom: aFolder) ifNil: [ 
		  self error:
			  'Unable to deserialize memento from ' , aFolder asString ]
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> readModelReferences: aRootFolder [
	| references |
	references := STON
		fromStream: (aRootFolder / 'models.json') readStream.
	^ references
		collect: [ :each | 
			| uuid model |
			uuid := self modelIdFrom: (each at: 'uuid').
			model := self
				pluginForName: (each at: 'plugin')
				pluginVersion: (each at: 'pluginVersion').
			uuid -> model ]
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> readProjectInfoFrom: aFile [

	| project json exporter |
	json := STON fromStream: aFile readStream.
	exporter := (json at: 'export' ifAbsent: [ json at: 'exporter' ]) 
		            at: 'exporter'.
	exporter = self exporter ifFalse: [ 
		self error: 'Unsupported exporter ' , exporter ].
	project := OPProject new.
	project name: ((json at: 'project') at: 'name').
	project uuid: (UUID fromString: ((json at: 'project') at: 'uuid')).
	project storageFolder: aFile parent.
	^ project
]
