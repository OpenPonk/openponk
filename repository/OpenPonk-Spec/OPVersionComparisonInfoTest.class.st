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
	savedCurrent := (Smalltalk classNamed: #OPVersion) instVarNamed: #current.
	savedLatest := (Smalltalk classNamed: #OPVersion) instVarNamed: #latest
]

{ #category : 'running' }
OPVersionComparisonInfoTest >> tearDown [
	(Smalltalk classNamed: #OPVersion) instVarNamed: #current put: savedCurrent.
	(Smalltalk classNamed: #OPVersion) instVarNamed: #latest put: savedLatest.
	super tearDown
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializePresentersWithUnknownRepository [
	| mockVersion presenter |
	mockVersion := (Smalltalk classNamed: #OPVersion) new
		               repositoryName: (Smalltalk classNamed: #OPVersion) unknownRepositoryName;
		               yourself.
	(Smalltalk classNamed: #OPVersion)
		instVarNamed: #current
		put: mockVersion.
	presenter := (Smalltalk classNamed: #OPVersionComparisonInfo)
		             newApplication:
		             (Smalltalk classNamed: #SpApplication)
			             defaultApplication.
	self
		assert: (presenter instVarNamed: #lastVersionInfo) label
		equals: 'Unable to determine.'.
	self
		assert: (presenter instVarNamed: #lastNightlyVersionInfo) label
		equals: 'Unable to determine.'
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializePresentersWithoutNetwork [
	| mockVersion presenter |
	mockVersion := (Smalltalk classNamed: #OPVersion) new
		               repositoryName: 'petrinets';
		               yourself.
	(Smalltalk classNamed: #OPVersion)
		instVarNamed: #current
		put: mockVersion.
	presenter := (Smalltalk classNamed: #OPVersionComparisonInfo)
		             newApplication:
		             (Smalltalk classNamed: #SpApplication)
			             defaultApplication.
	self
		assert: (presenter instVarNamed: #repositoryName) label
		equals: 'petrinets'.
	self
		assert:
		(self class urlFromLink: (presenter instVarNamed: #repositoryName))
		equals: 'https://github.com/OpenPonk/petrinets'.
	self
		assert: (presenter instVarNamed: #lastVersionInfo) label
		equals: 'Loading...'.
	self
		assert: (presenter instVarNamed: #lastNightlyVersionInfo) label
		equals: 'Loading...'
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testInitializeWindow [
	| mockVersion presenter window |
	mockVersion := (Smalltalk classNamed: #OPVersion) new
		repositoryName: 'petrinets';
		yourself.
	(Smalltalk classNamed: #OPVersion) instVarNamed: #current put: mockVersion.

	presenter := (Smalltalk classNamed: #OPVersionComparisonInfo)
		newApplication: (Smalltalk classNamed: #SpApplication) defaultApplication.
	window := (Smalltalk classNamed: #SpWindowPresenter) new.
	presenter initializeWindow: window.

	self assert: window title equals: 'OpenPonk version info'.
	self assert: window initialExtent equals: 720 @ 200
]
