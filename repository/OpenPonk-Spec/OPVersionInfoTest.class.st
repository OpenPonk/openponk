Class {
	#name : 'OPVersionInfoTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWhenDownloadImpossible [

	| version presenter |
	version := (Smalltalk classNamed: #OPVersion) new.

	presenter := (Smalltalk classNamed: #OPVersionInfo)
		             newApplication:
		             (Smalltalk classNamed: #SpApplication)
			             defaultApplication
		             model: version.

	self
		assert: (presenter instVarNamed: #releaseName) label
		equals: 'Unknown'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink:
				 (presenter instVarNamed: #releaseName))
		equals: 'https://openponk.org'.
	self
		assert: (presenter instVarNamed: #buildDate) label
		equals: 'Unknown'
]

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWhenDownloadPossible [

	| version presenter |
	version := (Smalltalk classNamed: #OPVersion) new
		           githubWorkflowRunId: 12345;
		           repositoryName: 'fsm-editor'.

	presenter := (Smalltalk classNamed: #OPVersionInfo)
		             newApplication:
		             (Smalltalk classNamed: #SpApplication)
			             defaultApplication
		             model: version.

	self
		assert: (presenter instVarNamed: #releaseName) label
		equals: 'Loading...'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink:
				 (presenter instVarNamed: #releaseName))
		equals: 'https://openponk.org'.
	self
		assert: (presenter instVarNamed: #buildDate) label
		equals: 'Loading...'
]

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWithKnownRelease [

	| version presenter date |
	date := '2026-08-15T12:00:00+00:00' asDateAndTime.
	version := (Smalltalk classNamed: #OPVersion) new
		           releaseName: 'v1.0.0';
		           repositoryName: 'class-editor';
		           buildDate: date.
	presenter := (Smalltalk classNamed: #OPVersionInfo)
		             newApplication:
		             (Smalltalk classNamed: #SpApplication)
			             defaultApplication
		             model: version.
	self
		assert: (presenter instVarNamed: #releaseName) label
		equals: 'v1.0.0'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink:
				 (presenter instVarNamed: #releaseName))
		equals:
		'https://github.com/OpenPonk/class-editor/releases/tag/v1.0.0'.
	self
		assert: (presenter instVarNamed: #buildDate) label
		equals: date asLocal asStringYMDHM
]

{ #category : 'tests' }
OPVersionInfoTest >> testSetFailedInfo [
	| version presenter |
	version := (Smalltalk classNamed: #OPVersion) new.

	presenter := (Smalltalk classNamed: #OPVersionInfo)
		newApplication: (Smalltalk classNamed: #SpApplication) defaultApplication
		model: version.
	presenter setFailedInfo.

	self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'failed to download'
]
