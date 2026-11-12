"
Tests semantic version comparison, upgrade detection, and release notification formatting.
"
Class {
	#name : 'OPVersionComparisonInfoTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedCurrent',
		'savedLatest'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
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

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testThisVersionInfoLoadedWithReleaseNightlyUnknownAndHttpError [
	| mockVersion presenter releaseVer nightlyVer attempts |
	self assert: (OPVersionComparisonInfo defaultLayout isKindOf: SpBoxLayout).

	mockVersion := Mock new.
	mockVersion stub repositoryName willReturn: 'openponk'.
	mockVersion stub repositoryLink willReturn: 'https://github.com/OpenPonk/openponk'.
	mockVersion stub isRepositoryNameKnown willReturn: true.
	mockVersion stub fullVersionString willReturn: 'v1.0.0'.
	mockVersion stub needsDownloadInfo willReturn: false.
	mockVersion stub canDownloadInfo willReturn: false.
	mockVersion stub getOfLatestRelease willReturn: nil.
	mockVersion stub getOfLatestNightlyBuild willReturn: nil.
	OPVersion instVarNamed: #current put: mockVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	presenter build.
	presenter thisVersionInfoLoaded.
	attempts := 0.
	[ (presenter instVarNamed: #lastNightlyVersionInfo) label = 'Loading...' and: [ attempts < 50 ] ]
		whileTrue: [
			(Delay forMilliseconds: 10) wait.
			attempts := attempts + 1 ].
	self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Unknown.'.
	self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Unknown.'.

	releaseVer := OPVersion new
		repositoryName: 'openponk';
		releaseName: 'v2.0.0';
		buildDate: DateAndTime now;
		yourself.
	nightlyVer := OPVersion new
		repositoryName: 'openponk';
		releaseName: 'nightly-12345';
		githubWorkflowRunId: 12345;
		buildDate: DateAndTime now;
		yourself.
	mockVersion stub getOfLatestRelease willReturn: releaseVer.
	mockVersion stub getOfLatestNightlyBuild willReturn: nightlyVer.

	presenter thisVersionInfoLoaded.
	attempts := 0.
	[ ((presenter instVarNamed: #lastNightlyVersionInfo) isKindOf: OPVersionInfo) not and: [ attempts < 50 ] ]
		whileTrue: [
			(Delay forMilliseconds: 10) wait.
			attempts := attempts + 1 ].
	self assert: ((presenter instVarNamed: #lastVersionInfo) isKindOf: OPVersionInfo) description: 'lastVersionInfo should become OPVersionInfo presenter'.
	self assert: ((presenter instVarNamed: #lastNightlyVersionInfo) isKindOf: OPVersionInfo) description: 'lastNightlyVersionInfo should become OPVersionInfo presenter'.

	mockVersion stub getOfLatestRelease willRaise: ZnHttpUnsuccessful new.
	presenter thisVersionInfoLoaded.
	attempts := 0.
	[ (((presenter instVarNamed: #lastVersionInfo) respondsTo: #label) not
		or: [ (presenter instVarNamed: #lastVersionInfo) label ~= 'Failed to download info.' ])
		and: [ attempts < 50 ] ]
		whileTrue: [
			(Delay forMilliseconds: 10) wait.
			attempts := attempts + 1 ].
	self assert: ((presenter instVarNamed: #lastVersionInfo) respondsTo: #label).
	self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Failed to download info.'.
	self assert: ((presenter instVarNamed: #lastNightlyVersionInfo) respondsTo: #label).
	self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Failed to download info.'
]
