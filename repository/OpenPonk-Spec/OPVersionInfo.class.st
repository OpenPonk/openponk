Class {
	#name : 'OPVersionInfo',
	#superclass : 'SpPresenter',
	#instVars : [
		'version',
		'releaseNameLabel',
		'releaseName',
		'buildDateLabel',
		'buildDate',
		'onInfoDownloadBlock'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'as yet unclassified' }
OPVersionInfo class >> defaultLayout [
	^ SpGridLayout new
		borderWidth: 0;
		beColumnNotHomogeneous;
		add: #releaseNameLabel at: 1 @ 1;
		add: #releaseName at: 2 @ 1;
		add: #buildDateLabel at: 1 @ 2;
		add: #buildDate at: 2 @ 2;
		add: '' at: 1 @ 5 span: 2 @ 1;
		yourself
]

{ #category : 'initialization' }
OPVersionInfo >> connectPresenters [

	(version needsDownloadInfo and: [ version canDownloadInfo ])
		ifFalse: [ ^ self ].

	self whenBuiltDo: [
		[
		version downloadInfo.
		[ self refreshInfo ]
			on: ZnHttpUnsuccessful
			do: [ self setFailedInfo ] ]
			forkAt: Processor userBackgroundPriority
			named: 'Loading OpenPonk version info from GitHub' ]
]

{ #category : 'initialization' }
OPVersionInfo >> initialize [
	onInfoDownloadBlock := [  ].
	super initialize
]

{ #category : 'initialization' }
OPVersionInfo >> initializePresenters [

	| unknownLabel |
	releaseNameLabel := self newLabel.
	releaseNameLabel label: 'Version: '.
	releaseName := self newLink.
	buildDateLabel := self newLabel.
	buildDateLabel label: 'Build/release date: '.
	buildDate := self newLabel.
	unknownLabel := version canDownloadInfo
		                ifTrue: [ 'Loading...' ]
		                ifFalse: [ 'Unknown' ].
	version needsDownloadInfo ifFalse: [ ^ self refreshInfo ].
	releaseName
		label: unknownLabel;
		url: 'https://openponk.org'.
	buildDate label: unknownLabel
]

{ #category : 'enumerating' }
OPVersionInfo >> onInfoDownloadDo: aBlock [

	version needsDownloadInfo
		ifTrue: [ onInfoDownloadBlock := aBlock ]
		ifFalse: aBlock
]

{ #category : 'updating' }
OPVersionInfo >> refreshInfo [

	version needsDownloadInfo ifTrue: [ ^ self ].
	releaseName
		label: version releaseName;
		url: 'https://github.com/OpenPonk/' , version repositoryName
			, '/releases/tag/' , version releaseName.
	buildDate label: version buildDate asStringYMDHM.
	onInfoDownloadBlock value
]

{ #category : 'updating' }
OPVersionInfo >> setFailedInfo [

	| label |
	label := 'failed to download'.
	releaseName label: label.
	buildDate label: label
]

{ #category : 'accessing - model' }
OPVersionInfo >> setModelBeforeInitialization: aVersion [

	version := aVersion
]
