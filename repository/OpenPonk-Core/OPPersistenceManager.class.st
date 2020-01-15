"
I handle storing in-image snapshots (mementos) and I pass the memento also onto Plugin Exporter (or ask Importer to retrieve it).
"
Class {
	#name : #OPPersistenceManager,
	#superclass : #Object,
	#instVars : [
		'history',
		'current',
		'future'
	],
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPPersistenceManager >> autosaveFileFor: aUUID [
	self autosavePath ensureCreateDirectory.
	^ self autosavePath / aUUID asString , 'json'
]

{ #category : #accessing }
OPPersistenceManager >> autosavePath [
	^ FileLocator imageDirectory asFileReference / 'autosave'
]

{ #category : #testing }
OPPersistenceManager >> futureIsEmpty [
	^ future isEmpty
]

{ #category : #testing }
OPPersistenceManager >> historyIsEmpty [
	^ history isEmpty
]

{ #category : #initialization }
OPPersistenceManager >> initialize [
	super initialize.
	history := OrderedCollection new.
	future := OrderedCollection new
]

{ #category : #'save/load' }
OPPersistenceManager >> loadCurrent [
	| import |
	current ifNil: [ ^ nil ].
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)
]

{ #category : #'save/load' }
OPPersistenceManager >> loadNext [
	| import |
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)
]

{ #category : #'save/load' }
OPPersistenceManager >> loadPrevious [
	| import |
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)
]

{ #category : #accessing }
OPPersistenceManager >> pluginFor: aModel [
	^ OPPluginRegistry default pluginFor: aModel
]

{ #category : #initialization }
OPPersistenceManager >> resetFuture [
	future ifNotEmpty: [ future := OrderedCollection new ]
]

{ #category : #saving }
OPPersistenceManager >> saveMemento: aMemento to: aFolder [
	(aFolder / #models / aMemento uuid asString) ensureCreateDirectory.
	(self pluginFor: aMemento model) serializerClass new
		export: aMemento
		to: aFolder / #models / aMemento uuid asString
]

{ #category : #saving }
OPPersistenceManager >> saveProject: aProjectMemento models: modelMementos to: aFolder [
	(aFolder / aProjectMemento projectFile) asFileReference
		writeStreamDo:
			[ :stream | stream nextPutAll: (STON toJsonStringPretty: aProjectMemento projectDescription) ].
	modelMementos do: [ :each | self saveMemento: each to: aFolder ]
]

{ #category : #'save/load' }
OPPersistenceManager >> saveState: aMemento [
	self resetFuture.
	current ifNotNil: [ history addLast: current ].
	current := OPFsmGraphML new export: aMemento model withLayout: aMemento layout.
	(self autosaveFileFor: aMemento id)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: current ]
]
