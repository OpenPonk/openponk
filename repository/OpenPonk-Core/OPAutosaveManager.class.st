"
Manages autosaving, history, and state serialization.
Maintains a history of states to support undo/redo operations utilizing the memento pattern.
"
Class {
	#name : 'OPAutosaveManager',
	#superclass : 'Object',
	#instVars : [
		'history',
		'current',
		'future',
		'serializer'
	],
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'instance creation' }
OPAutosaveManager class >> on: aSerializer [
	^ self new
		serializer: aSerializer;
		yourself
]

{ #category : 'instance creation' }
OPAutosaveManager >> autosaveFileFor: aUUID [
	self autosavePath ensureCreateDirectory.
	^ self autosavePath / aUUID asString , 'ston'
]

{ #category : 'accessing' }
OPAutosaveManager >> autosavePath [
	^ FileLocator imageDirectory asFileReference / 'autosave'
]

{ #category : 'testing' }
OPAutosaveManager >> futureIsEmpty [
	^ future isEmpty
]

{ #category : 'testing' }
OPAutosaveManager >> historyIsEmpty [
	^ history isEmpty
]

{ #category : 'initialization' }
OPAutosaveManager >> initialize [
	super initialize.
	history := OrderedCollection new.
	future := OrderedCollection new
]

{ #category : 'save/load' }
OPAutosaveManager >> loadCurrent [
	current ifNil: [ ^ nil ].
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : 'save/load' }
OPAutosaveManager >> loadNext [
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : 'save/load' }
OPAutosaveManager >> loadPrevious [
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : 'save/load' }
OPAutosaveManager >> saveState: aMemento [
	future reset.
	current ifNotNil: [ history addLast: current ].
	current := String
		streamContents: [ :stream | self serializer saveMemento: aMemento to: stream ].
	(self autosaveFileFor: aMemento uuid)
		ensureDelete;
		writeStreamDo: [ :stream | 
			stream
				"wantsLineEndConversion: true; incompatible with Pharo 9"
				nextPutAll: current ]
]

{ #category : 'accessing' }
OPAutosaveManager >> serializer [
	^ serializer
]

{ #category : 'accessing' }
OPAutosaveManager >> serializer: aSerializer [
	serializer := aSerializer
]
