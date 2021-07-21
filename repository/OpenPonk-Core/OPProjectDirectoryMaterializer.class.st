"
I take a folder and try to materialize a project from it.
"
Class {
	#name : #OPProjectDirectoryMaterializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPProjectDirectoryMaterializer >> exporter [
	^ 'OpenPonk'
]

{ #category : #accessing }
OPProjectDirectoryMaterializer >> exporterVersion [
	^ OPVersion current fullVersionString
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
				with: pair value serializer ]
]

{ #category : #reading }
OPProjectDirectoryMaterializer >> readMementoFrom: aFolder with: aSerializer [
	^ (aSerializer loadMementoFrom: aFolder)
		ifNil:
			[ self error: 'Unable to deserialize memento from ' , aFolder asString ]
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
	| project json exporter exporterVersion |
	json := STON fromStream: aFile readStream.
	exporter := (json at: 'exporter') at: 'exporter'.
	exporterVersion := (json at: 'exporter') at: 'exporterVersion'.
	(exporter = self exporter and: [ exporterVersion = exporterVersion ])
		ifFalse: [ self error: 'Unsupported exporter ' , exporter , ' version ' , exporterVersion ].
	project := OPProject new.
	project name: ((json at: 'project') at: 'name').
	project uuid: (UUID fromString: ((json at: 'project') at: 'uuid')).
	project storageFolder: aFile parent.
	^ project
]
