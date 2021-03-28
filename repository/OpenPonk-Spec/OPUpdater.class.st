Class {
	#name : #OPUpdater,
	#superclass : #SpPresenter,
	#instVars : [
		'version',
		'lastVersion',
		'lastNightlyVersion',
		'repositoryNameLabel',
		'repositoryName',
		'versionInfoLabel',
		'lastVersionInfoLabel',
		'lastNightlyVersionInfoLabel',
		'versionInfo',
		'lastVersionInfo',
		'lastNightlyVersionInfo'
	],
	#category : #'OpenPonk-Spec-Dialogs'
}

{ #category : #specs }
OPUpdater class >> defaultSpec [
	^ SpBoxLayout newVertical
		borderWidth: 5;
		add:
			(SpBoxLayout newHorizontal
					spacing: 5;
					add: SpBoxLayout newVertical;
					add: #repositoryNameLabel expand: false;
					add: #repositoryName expand: false;
					add: SpBoxLayout newVertical;
					yourself)
			expand: false
			fill: false
			padding: 12;
		add:
			(SpBoxLayout newHorizontal
				spacing: 5;
				add:
					(SpBoxLayout newVertical
						add: #versionInfoLabel height: self labelHeight * 1.6;
						add: #versionInfo);
				add:
					(SpBoxLayout newVertical
						add: #lastVersionInfoLabel height: self labelHeight * 1.6;
						add: #lastVersionInfo;
						yourself);
				add:
					(SpBoxLayout newVertical
						add: #lastNightlyVersionInfoLabel
							height: self labelHeight * 1.6;
						add: #lastNightlyVersionInfo;
						yourself);
				yourself);
		yourself
]

{ #category : #initialization }
OPUpdater >> connectPresenters [
	version needsDownloadInfo
		ifFalse: [ ^ self currentVersionInfoLoaded ].
	version canDownloadInfo
		ifTrue: [ versionInfo onInfoDownloadDo: [ self currentVersionInfoLoaded ] ]
]

{ #category : #'as yet unclassified' }
OPUpdater >> currentVersionInfoLoaded [
	[ [ lastVersion := version getOfLatestRelease.
	lastVersion
		ifNil: [ lastVersionInfo label: 'Unknown.' ]
		ifNotNil: [ lastVersionInfo := OPVersionInfo
				newApplication: self application
				model: lastVersion.
			self update ] ]
		on: ZnHttpUnsuccessful
		do: [ lastVersionInfo label: 'Failed to download info.' ] ]
		forkAt: Processor userBackgroundPriority
		named: 'Loading OpenPonk latest release info from GitHub'.
	[ [ lastNightlyVersion := version getOfLatestNightlyBuild.
	lastNightlyVersion
		ifNil: [ lastNightlyVersionInfo label: 'Unknown.' ]
		ifNotNil: [ lastNightlyVersionInfo := OPVersionInfo
				newApplication: self application
				model: lastNightlyVersion.
			self update ] ]
		on: ZnHttpUnsuccessful
		do: [ lastNightlyVersionInfo label: 'Failed to download info.' ] ]
		forkAt: Processor userBackgroundPriority
		named: 'Loading OpenPonk nightly build info from GitHub'
]

{ #category : #initialization }
OPUpdater >> initializePresenters [
	repositoryNameLabel := self newLabel.
	repositoryNameLabel label: 'Plugin build / repository: '.
	repositoryName := self newLink.
	versionInfoLabel := self newLabel label: 'This version: '.
	lastVersionInfoLabel := self newLabel label: 'Last stable version: '.
	lastNightlyVersionInfoLabel := self newLabel
		label: 'Last nightly build: '.
	version := OPVersion current.
	(version needsDownloadInfo not or: [ version canDownloadInfo ])
		ifTrue: [ repositoryName
				label: version repositoryName;
				url: 'https://github.com/OpenPonk/' , version repositoryName.
			versionInfo := OPVersionInfo
				newApplication: self application
				owner: self
				model: version.
			lastVersionInfo := self newLabel label: 'Loading...'.
			lastNightlyVersionInfo := self newLabel label: 'Loading...'.
			^ self ].
	repositoryName
		label: version repositoryName;
		url:
			(version isRepositoryNameKnown
				ifTrue: [ 'https://github.com/OpenPonk/' , version repositoryName ]
				ifFalse: [ 'https://openponk.org' ]).
	versionInfo := OPVersionInfo
		newApplication: self application
		owner: self
		model: version.
	lastVersionInfo := self newLabel label: 'Unable to determine.'.
	lastNightlyVersionInfo := self newLabel label: 'Unable to determine.'
]

{ #category : #initialization }
OPUpdater >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'OpenPonk version info';
		initialExtent: 700 @ 210
]
