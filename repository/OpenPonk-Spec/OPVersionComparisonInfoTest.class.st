Class {
	#name : 'OPVersionComparisonInfoTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedCurrent',
		'savedLatest'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
OPVersionComparisonInfoTest class >> urlFromLink: aLinkPresenter [
	| act closure |
	act := aLinkPresenter action.
	act ifNil: [ ^ nil ].
	closure := act isClosure
		ifTrue: [ act ]
		ifFalse: [
			(act respondsTo: #value)
				ifTrue: [ act value ]
				ifFalse: [ act ] ].
	(closure respondsTo: #basicSize) ifTrue: [
		1 to: closure basicSize do: [ :i |
			| val |
			val := closure basicAt: i.
			val isString ifTrue: [ ^ val ] ] ].
	(closure respondsTo: #outerContext) ifTrue: [
		closure outerContext ifNotNil: [ :ctx |
			(ctx hasTemporaryVariableNamed: #aString)
				ifTrue: [ ^ ctx tempNamed: #aString ] ] ].
	^ nil
]

{ #category : 'running' }
OPVersionComparisonInfoTest >> setUp [

	super setUp.
	savedCurrent := OPVersion instVarNamed: #current.
	savedLatest := OPVersion instVarNamed: #latest
]

{ #category : 'running' }
OPVersionComparisonInfoTest >> tearDown [

	OPVersion instVarNamed: #current put: savedCurrent.
	OPVersion instVarNamed: #latest put: savedLatest.
	super tearDown
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializePresentersWithUnknownRepository [

	| mockVersion presenter |
	mockVersion := OPVersion new
		               repositoryName: OPVersion unknownRepositoryName;
		               yourself.
	OPVersion instVarNamed: #current put: mockVersion.
	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Unable to determine.'.
	self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Unable to determine.'
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializePresentersWithoutNetwork [

	| mockVersion presenter |
	mockVersion := OPVersion new
		               repositoryName: 'petrinets';
		               yourself.
	OPVersion instVarNamed: #current put: mockVersion.
	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	self assert: (presenter instVarNamed: #repositoryName) label equals: 'petrinets'.
	self assert: (self class urlFromLink: (presenter instVarNamed: #repositoryName)) equals: 'https://github.com/OpenPonk/petrinets'.
	self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Loading...'.
	self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Loading...'
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializeWindow [

	| mockVersion presenter window |
	mockVersion := OPVersion new
		               repositoryName: 'petrinets';
		               yourself.
	OPVersion instVarNamed: #current put: mockVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	window := SpWindowPresenter new.
	presenter initializeWindow: window.

	self assert: window title equals: 'OpenPonk version info'.
	self assert: window initialExtent equals: 720 @ 200
]
