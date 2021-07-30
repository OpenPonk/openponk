Class {
	#name : #OPVersionInfo,
	#superclass : #SpPresenter,
	#instVars : [
		'version',
		'releaseNameLabel',
		'releaseName',
		'buildDateLabel',
		'buildDate',
		'commitLabel',
		'commit',
		'commitDateLabel',
		'commitDate',
		'onInfoDownloadBlock'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #specs }
OPVersionInfo class >> defaultSpec [
	^ SpGridLayout new
		borderWidth: 0;
		beColumnNotHomogeneous;
		add: #releaseNameLabel at: 1 @ 1;
		add: #releaseName at: 2 @ 1;
		add: #buildDateLabel at: 1 @ 2;
		add: #buildDate at: 2 @ 2;
		add: #commitLabel at: 1 @ 3;
		add: #commit at: 2 @ 3;
		add: #commitDateLabel at: 1 @ 4;
		add: #commitDate at: 2 @ 4;
		add: '' at: 1 @ 5 span: 2 @ 1;
		yourself
]

{ #category : #initialization }
OPVersionInfo >> connectPresenters [
	(version needsDownloadInfo and: [ version canDownloadInfo ])
		ifTrue: [ [ version downloadInfo.
			[ self refreshInfo ]
				on: ZnHttpUnsuccessful
				do: [ self setFailedInfo ] ]
				forkAt: Processor userBackgroundPriority
				named: 'Loading OpenPonk version info from GitHub' ]
]

{ #category : #initialization }
OPVersionInfo >> initialize [
	onInfoDownloadBlock := [  ].
	super initialize
]

{ #category : #initialization }
OPVersionInfo >> initializePresenters [
	| unknownLabel |
	releaseNameLabel := self newLabel.
	releaseNameLabel label: 'Version: '.
	releaseName := self newLink.
	buildDateLabel := self newLabel.
	buildDateLabel label: 'Build/release date: '.
	buildDate := self newLabel.
	commitLabel := self newLabel.
	commitLabel label: 'Built from commit: '.
	commit := self newLink.
	commitDateLabel := self newLabel.
	commitDateLabel label: 'Commit date: '.
	commitDate := self newLabel.
	unknownLabel := version canDownloadInfo
		ifTrue: [ 'Loading...' ]
		ifFalse: [ 'Unknown' ].
	version needsDownloadInfo
		ifFalse: [ ^ self refreshInfo ].
	releaseName
		label: unknownLabel;
		url: 'https://openponk.org'.
	buildDate label: unknownLabel.
	commit
		label: unknownLabel;
		url: 'https://openponk.org'.
	commitDate label: unknownLabel
]

{ #category : #enumerating }
OPVersionInfo >> onInfoDownloadDo: aBlock [
	version needsDownloadInfo
		ifTrue: [ onInfoDownloadBlock := aBlock ]
		ifFalse: aBlock
]

{ #category : #'as yet unclassified' }
OPVersionInfo >> refreshInfo [
	version needsDownloadInfo
		ifTrue: [ ^ self ].
	releaseName
		label: version releaseName;
		url:
			'https://github.com/OpenPonk/' , version repositoryName
				, '/releases/tag/' , version releaseName.
	buildDate label: version buildDate asStringYMDHM.
	commit
		label: (version commit asString first: 7);
		url:
			'https://github.com/OpenPonk/' , version repositoryName , '/commit/'
				, version commit asString.
	commitDate label: version commitDate asStringYMDHM.
	onInfoDownloadBlock value
]

{ #category : #'as yet unclassified' }
OPVersionInfo >> setFailedInfo [
	| label |
	label := 'failed to download'.
	releaseName label: label.
	buildDate label: label.
	commit label: label.
	commitDate label: label
]

{ #category : #'accessing model' }
OPVersionInfo >> setModelBeforeInitialization: aVersion [
	version := aVersion
]
