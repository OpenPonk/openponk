"
I manage autosaving and undo/redo operations of a single controller.

!! Warning

As I manage only a single controller, do not rely on this for cross-model operations (such as instance modeling), as changes in the ""linked-to"" model can make your model invalid if you undo/redo/recover only the instance.
"
Class {
	#name : #OPAutosaveManager,
	#superclass : #Object,
	#instVars : [
		'history',
		'current',
		'future',
		'serializer'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPAutosaveManager class >> on: aSerializer [
	^ self new
		serializer: aSerializer;
		yourself
]

{ #category : #'instance creation' }
OPAutosaveManager >> autosaveFileFor: aUUID [
	self autosavePath ensureCreateDirectory.
	^ self autosavePath / aUUID asString , 'ston'
]

{ #category : #accessing }
OPAutosaveManager >> autosavePath [
	^ FileLocator imageDirectory asFileReference / 'autosave'
]

{ #category : #testing }
OPAutosaveManager >> futureIsEmpty [
	^ future isEmpty
]

{ #category : #testing }
OPAutosaveManager >> historyIsEmpty [
	^ history isEmpty
]

{ #category : #initialization }
OPAutosaveManager >> initialize [
	super initialize.
	history := OrderedCollection new.
	future := OrderedCollection new
]

{ #category : #'save/load' }
OPAutosaveManager >> loadCurrent [
	current ifNil: [ ^ nil ].
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : #'save/load' }
OPAutosaveManager >> loadNext [
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : #'save/load' }
OPAutosaveManager >> loadPrevious [
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	^ current
		readStreamDo: [ :stream | self serializer materializeFrom: stream ]
]

{ #category : #'save/load' }
OPAutosaveManager >> saveState: aMemento [
	future reset.
	current ifNotNil: [ history addLast: current ].
	current := String
		streamContents: [ :stream | self serializer saveMemento: aMemento to: stream ].
	(self autosaveFileFor: aMemento uuid)
		ensureDelete;
		writeStreamDo: [ :stream | 
			stream
				wantsLineEndConversion: true;
				nextPutAll: current ]
]

{ #category : #accessing }
OPAutosaveManager >> serializer [
	^ serializer
]

{ #category : #accessing }
OPAutosaveManager >> serializer: aSerializer [
	serializer := aSerializer
]
