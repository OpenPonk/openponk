Class {
	#name : #OPProjectPersistence,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #saving }
OPProjectPersistence >> diagramFileNameFor: aModel [
	^ ((self diagramNameFor: aModel) ifNil: [ '_test' ]) asFileName , '.'
		,
			(OPPluginRegistry default pluginFor: aModel) serializerClass new
				diagramExtension
]

{ #category : #saving }
OPProjectPersistence >> diagramNameFor: aModel [
	^ aModel name
]

{ #category : #saving }
OPProjectPersistence >> diagramsFolder [
	OSPlatform current isUnix
		ifTrue: [ ^ FileLocator temp asFileReference / 'NSP-testing' / 'diagrams' ].
	^ FileLocator appData asFileReference / 'NSP' / 'diagrams'
]

{ #category : #saving }
OPProjectPersistence >> exporter [
	^ 'OpenPonk'
]

{ #category : #saving }
OPProjectPersistence >> exporterVersion [
	^ OPVersion version
]

{ #category : #saving }
OPProjectPersistence >> extractAppModelForProject: aProject fromMementos: aCollection [
	| appModel flowTasks |
	appModel := aProject storage applicationModel.
	flowTasks := OrderedCollection new.
	aCollection
		select: [ :each | each model isKindOf: NSPFlowModel ]
		thenDo: [ :each | flowTasks addAll: (NSPDataFlowTaskTransformation new transformFromFlow: each model) ].
	appModel dataFlowTasks: flowTasks.
	^ appModel
]

{ #category : #saving }
OPProjectPersistence >> extractComponentModelsFromMementos: aCollection [
	^ aCollection select: [ :each | each model isKindOf: NSMComponent ]
]

{ #category : #saving }
OPProjectPersistence >> isValidFormat: anObject [
	anObject isDictionary
		ifFalse: [ ^ false ].
	(anObject includesKey: #exporter)
		ifFalse: [ ^ false ].
	(anObject includesKey: #project)
		ifFalse: [ ^ false ].
	(anObject includesKey: #components)
		ifFalse: [ ^ false ].
	^ true
]

{ #category : #materialization }
OPProjectPersistence >> materializeComponent: aDictionary [
	| diagram |
	diagram := Dictionary new.
	(aDictionary at: #diagram)
		keysAndValuesDo: [ :key :value | diagram at: key put: value first @ value second ].
	^ OPPersistenceMemento
		model: (self materializedModelFrom: (aDictionary at: #model))
		diagram: diagram
]

{ #category : #materialization }
OPProjectPersistence >> materializeProject: aDictionary [
	^ NSPProject new
		name: (aDictionary at: #name);
		uuid: (UUID fromString: (aDictionary at: #uuid));
		yourself
]

{ #category : #materialization }
OPProjectPersistence >> materializedModelFrom: aString [
	| materializer |
	materializer := aString first = $<
		ifTrue: [ NSPERSerializer new ]
		ifFalse: [ NSPFlowSerializer new ].
	^ materializer materializeModelFrom: aString
]

{ #category : #saving }
OPProjectPersistence >> modelReferencesToJson: models [
	| references |
	references := models asArray
		collect: [ :each | 
			| plugin |
			plugin := OPPluginRegistry default pluginFor: each.
			{'uuid' -> each uuid asString.
			'plugin' -> plugin className.
			'pluginVersion' -> plugin version} asDictionary ].
	^ STON toJsonStringPretty: references
]

{ #category : #saving }
OPProjectPersistence >> projectToJson: aProject [
	^ STON
		toJsonStringPretty:
			{'project'
				->
					{'name' -> aProject name.
					'uuid' -> aProject uuid asString} asDictionary.
			'exporter'
				->
					{'exporter' -> self exporter.
					'exporterVersion' -> self exporterVersion.
					'timestamp' -> DateAndTime now truncated asString} asDictionary} asDictionary
]

{ #category : #saving }
OPProjectPersistence >> removeModelsNotIn: aCollection from: aFolder [
	| toDelete ids |
	ids := aCollection collect: [ :each | each uuid asString ].
	toDelete := aFolder children reject: [ :each | ids includes: each basename ].
	toDelete
		do: [ :each | 
			each files do: #delete.
			each delete ]
]

{ #category : #saving }
OPProjectPersistence >> saveMemento: aMemento to: aRoot with: aSerializer [
	| folder |
	folder := aRoot / aMemento uuid asString.
	folder ensureCreateDirectory.
	aSerializer saveMemento: aMemento to: folder
]

{ #category : #saving }
OPProjectPersistence >> saveMementos: aCollection to: aFolder [
	aCollection
		do: [ :each | 
			self
				saveMemento: each
				to: aFolder / 'models'
				with: (OPPluginRegistry default pluginFor: each model) serializerClass new ]
]

{ #category : #saving }
OPProjectPersistence >> saveProject: aProject to: aFolder [
	aFolder ensureCreateDirectory.
	(aFolder / 'models') ensureCreateDirectory.
	(aFolder / '.history' / 'models') ensureCreateDirectory.
	(aFolder / 'project.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self projectToJson: aProject) ].
	(aFolder / 'models.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self modelReferencesToJson: aProject models) ]
]

{ #category : #saving }
OPProjectPersistence >> saveProject: aProject withMementos: aCollection to: aFolder [
	self saveProject: aProject to: aFolder asFileReference.
	self removeModelsNotIn: aCollection from: aFolder / 'models'.
	self saveMementos: aCollection to: aFolder asFileReference.
	OPDiagramsWriter
		persistViewsOf: aProject
		to: aFolder asFileReference / 'views'
]

{ #category : #serialization }
OPProjectPersistence >> serializedModelFor: aModel [
	^ (OPPluginRegistry default pluginFor: aModel) serializerClass new serializeModel: aModel
]
