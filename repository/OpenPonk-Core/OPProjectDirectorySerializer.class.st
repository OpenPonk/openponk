"
My job is to store a project with all the plugins into a provided directory.
"
Class {
	#name : #OPProjectDirectorySerializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPProjectDirectorySerializer >> exporter [
	^ 'OpenPonk'
]

{ #category : #accessing }
OPProjectDirectorySerializer >> exporterVersion [
	^ OPVersion version
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

{ #category : #saving }
OPProjectDirectorySerializer >> removeModelsNotIn: aCollection from: aFolder [
	| toDelete ids |
	ids := aCollection collect: [ :each | each uuid asString ].
	toDelete := aFolder children
		reject: [ :each | ids includes: each basenameWithoutExtension ].
	toDelete do: [ :each | each deleteAll ]
]

{ #category : #saving }
OPProjectDirectorySerializer >> saveMemento: aMemento to: aRoot with: aSerializer [
	| fileReference |
	aRoot ensureCreateDirectory.
	fileReference := aSerializer
		addFormatNameTo: aRoot / aMemento uuid asString.
	aSerializer saveMemento: aMemento to: fileReference
]

{ #category : #saving }
OPProjectDirectorySerializer >> saveMementos: aCollection to: aFolder [
	aCollection
		do: [ :each | 
			self
				saveMemento: each
				to: aFolder / 'models'
				with: (OPPluginRegistry default pluginFor: each model) serializer ]
]

{ #category : #saving }
OPProjectDirectorySerializer >> saveProject: aProject to: aFolder [
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

{ #category : #'public - saving' }
OPProjectDirectorySerializer >> saveProject: aProject withMementos: aCollection to: aFolder [
	self saveProject: aProject to: aFolder asFileReference.
	self saveMementos: aCollection to: aFolder asFileReference.
	self removeModelsNotIn: aCollection from: aFolder / 'models'
]
