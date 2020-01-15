"
I hold the current version of OpenPonk.
"
Class {
	#name : #OPVersion,
	#superclass : #Object,
	#classInstVars : [
		'gitCommit'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPVersion class >> fullVersion [
	^ String
		streamContents: [ :stream | 
			stream << self version.
			self gitCommit ifNotNil: [ stream << '+sha.' << self gitCommit ] ]
]

{ #category : #accessing }
OPVersion class >> gitCommit [
	^ gitCommit ifNil: ''
]

{ #category : #accessing }
OPVersion class >> gitCommit: anObject [
	gitCommit := anObject
]

{ #category : #accessing }
OPVersion class >> moduleVersions [
	| modules plugins |
	modules := {'pharo' -> SystemVersion current highestUpdate.
	'OpenPonk' -> OPVersion fullVersion}.
	plugins := OPPluginRegistry default plugins asArray
		collect: [ :each | each className -> (each version ifNil: [ each gitCommit ]) ].
	^ (modules , plugins) asDictionary
]

{ #category : #accessing }
OPVersion class >> version [
	^ '0.1.0'
]
