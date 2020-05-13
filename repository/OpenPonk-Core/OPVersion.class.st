"
I hold the current version of OpenPonk.
"
Class {
	#name : #OPVersion,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'version',
		'buildNumber',
		'buildTimestamp',
		'projectName'
	],
	#classInstVars : [
		'current'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPVersion class >> buildStorageUrl [
	| document versions version |
	document := XMLDOMParser
		parseURL: 'https://dl.bintray.com/openponk/builds/' , self current projectName.
	versions := ((document / 'html' / 'body' / 'pre' / 'a') stringValues
		select: [ :any | any includesNumber ]
		thenCollect: [ :each | ((each withoutPrefix: 'v') withoutSuffix: '/') -> each ])
		asSortedCollection.
	version := versions
		ifEmpty: [ 'latest/' ]
		ifNotEmpty: [ versions last value ].
	^ 'https://dl.bintray.com/openponk/builds/'
		, self current projectName , '/' , version , 'version-info.json'
]

{ #category : #accessing }
OPVersion class >> current [
	^ current ifNil: [ current := self new ]
]

{ #category : #'instance creation' }
OPVersion class >> current: aVersion [
	current := aVersion
]

{ #category : #'instance creation' }
OPVersion class >> currentFromJSON: aString [
	self current: (self fromJSON: aString)
]

{ #category : #'instance creation' }
OPVersion class >> fromBuildStorage [
	^ self fromJSON: (ZnEasy get: self buildStorageUrl)
]

{ #category : #'instance creation' }
OPVersion class >> fromJSON: aString [
	| dictionary |
	dictionary := NeoJSONReader fromString: aString.
	^ self new
		buildNumber: (dictionary at: 'build-number');
		buildTimestamp:
			(DateAndTime
				fromSeconds: (dictionary at: 'build-timestamp') asDateAndTime asSeconds);
		version: (dictionary at: 'version');
		projectName: (dictionary at: 'project-name');
		yourself
]

{ #category : #'instance creation' }
OPVersion class >> fromUrl: anURLString [
	self fromJSON: (ZnEasy get: anURLString)
]

{ #category : #comparing }
OPVersion >> < aComparable [
	(self hasNumberedVersion xor: [ aComparable hasNumberedVersion ])
		ifTrue: [ ^ false ].
	self version = aComparable version
		ifTrue: [ ^ self buildNumber < aComparable buildNumber ].
	^ self version < aComparable version
]

{ #category : #comparing }
OPVersion >> = aComparable [
	^ (self hasNumberedVersion xor: [ aComparable hasNumberedVersion ])
		not
		and: [ self version = aComparable version
				or: [ self buildNumber = aComparable buildNumber ] ]
]

{ #category : #accessing }
OPVersion >> buildNumber [
	^ buildNumber ifNil: [ 0 ]
]

{ #category : #accessing }
OPVersion >> buildNumber: aNumber [
	buildNumber := aNumber
]

{ #category : #accessing }
OPVersion >> buildTimestamp [
	^ buildTimestamp
]

{ #category : #accessing }
OPVersion >> buildTimestamp: aDateAndTime [
	buildTimestamp := aDateAndTime
]

{ #category : #accessing }
OPVersion >> fullVersion [
	^ String
		streamContents: [ :stream | 
			stream << self projectName << '-' << self version << '-build'
				<< self buildNumber asString ]
]

{ #category : #accessing }
OPVersion >> hasNumberedVersion [
	^ version anySatisfy: [ :any | any asString asInteger isNotNil ]
]

{ #category : #comparing }
OPVersion >> hash [
	self hasNumberedVersion
		ifFalse: [ ^ self buildNumber hash ].
	^ self version hash
]

{ #category : #testing }
OPVersion >> isMostRecent [
	^ self class fromBuildStorage > self
]

{ #category : #accessing }
OPVersion >> projectName [
	^ projectName ifNil: [ 'openponk' ]
]

{ #category : #accessing }
OPVersion >> projectName: aString [
	projectName := aString
]

{ #category : #accessing }
OPVersion >> version [
	^ version ifNil: [ 'unknown' ]
]

{ #category : #accessing }
OPVersion >> version: aVersionString [
	version := aVersionString
]
