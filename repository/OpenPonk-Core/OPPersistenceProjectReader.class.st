"
I take a folder and try to materialize a project from it.
"
Class {
	#name : #OPPersistenceProjectReader,
	#superclass : #Object,
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPPersistenceProjectReader >> exporter [
	^ 'OpenPonk'
]

{ #category : #accessing }
OPPersistenceProjectReader >> exporterVersion [
	^ OPVersion version
]

{ #category : #'public - reading' }
OPPersistenceProjectReader >> fromFolder: aFolder [
	| project |
	project := self readProjectFrom: aFolder / 'project.json'.
	(self readAllMementosFrom: aFolder)
		do: [ :each | 
			project addModel: each model.
			project layout: each diagram for: each model ].
	^ project
]

{ #category : #accessing }
OPPersistenceProjectReader >> modelIdFrom: aString [
	aString size = 36
		ifTrue: [ ^ UUID fromString: aString ].
	(NumberParser isNumber: aString)
		ifTrue: [ ^ aString asNumber ].
	^ aString
]

{ #category : #reading }
OPPersistenceProjectReader >> pluginForName: aName pluginVersion: aVersion [
	| plugin |
	plugin := OPPluginRegistry default plugins
		detect: [ :each | each className = aName and: [ each version = aVersion ] ]
		ifNone: [ ^ self error: 'Unrecognized plugin ' , aName , ' version ' , aVersion ].
	^ plugin
]

{ #category : #reading }
OPPersistenceProjectReader >> readAllMementosFrom: aRootFolder [
	| references |
	references := self readModelReferences: aRootFolder.
	^ references
		collect: [ :pair | 
			self
				readMementoFrom: aRootFolder / 'models' / pair key asString
				with: pair value serializerClass new ]
]

{ #category : #reading }
OPPersistenceProjectReader >> readMementoFrom: aFolder with: aSerializer [
	^ (aSerializer loadMementoFrom: aFolder)
		ifNil: [ self error: 'Unable to deserialize memento from ' , aFolder asString ]
]

{ #category : #reading }
OPPersistenceProjectReader >> readModelReferences: aRootFolder [
	| references |
	references := STON fromString: (aRootFolder / 'models.json') readStream.
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
OPPersistenceProjectReader >> readProjectFrom: aFile [
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
