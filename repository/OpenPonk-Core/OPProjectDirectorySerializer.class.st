"
My job is to store a project with all the plugins into a provided directory.
"
Class {
	#name : #OPProjectDirectorySerializer,
	#superclass : #Object,
	#instVars : [
		'directory'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPProjectDirectorySerializer >> directory [
	^ directory
]

{ #category : #accessing }
OPProjectDirectorySerializer >> directory: aFolder [
	directory := aFolder asFileReference 
]

{ #category : #accessing }
OPProjectDirectorySerializer >> exporter [
	^ 'OpenPonk'
]

{ #category : #accessing }
OPProjectDirectorySerializer >> exporterVersion [
	^ OPVersion current fullVersion
]

{ #category : #writing }
OPProjectDirectorySerializer >> modelReferencesToJson: models [
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

{ #category : #accessing }
OPProjectDirectorySerializer >> modelsDirectory [
	^ directory / 'models'
]

{ #category : #writing }
OPProjectDirectorySerializer >> projectToJson: aProject [
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

{ #category : #'private - saving' }
OPProjectDirectorySerializer >> removeModelsNotIn: aCollection [
	| toDelete ids |
	ids := aCollection collect: [ :each | each uuid asString ].
	toDelete := self modelsDirectory children
		reject: [ :each | ids includes: each basenameWithoutExtension ].
	toDelete do: [ :each | each deleteAll ]
]

{ #category : #'private - saving' }
OPProjectDirectorySerializer >> saveMemento: aMemento with: aSerializer [
	| fileReference |
	self modelsDirectory ensureCreateDirectory.
	fileReference := aSerializer
		addFormatNameTo: self modelsDirectory / aMemento uuid asString.
	aSerializer saveMemento: aMemento to: fileReference
]

{ #category : #'private - saving' }
OPProjectDirectorySerializer >> saveMementos: aCollection [
	aCollection
		do: [ :each | 
			self
				saveMemento: each
				with: (OPPluginRegistry default pluginFor: each model) serializer ]
]

{ #category : #'private - saving' }
OPProjectDirectorySerializer >> saveProject: aProject [
	directory ensureCreateDirectory.
	(directory / 'models') ensureCreateDirectory.
	(directory / '.history' / 'models') ensureCreateDirectory.
	(directory / 'project.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self projectToJson: aProject) ].
	(directory / 'models.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self modelReferencesToJson: aProject models) ]
]

{ #category : #'public - saving' }
OPProjectDirectorySerializer >> saveProject: aProject withMementos: aCollection [
	self saveProject: aProject.
	self saveMementos: aCollection.
	self removeModelsNotIn: aCollection
]
