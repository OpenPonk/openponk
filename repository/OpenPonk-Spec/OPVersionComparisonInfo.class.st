Class {
	#name : 'OPVersionComparisonInfo',
	#superclass : 'SpPresenter',
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
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'as yet unclassified' }
OPVersionComparisonInfo class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 5;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: SpBoxLayout newTopToBottom;
				   add: #repositoryNameLabel expand: false;
				   add: #repositoryName expand: false;
				   add: SpBoxLayout newTopToBottom;
				   yourself)
		  expand: false
		  fill: false
		  padding: 12;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: (SpBoxLayout newTopToBottom
						    add: #versionInfoLabel height: self labelHeight * 1.6;
						    add: #versionInfo);
				   add: (SpBoxLayout newTopToBottom
						    add: #lastVersionInfoLabel height: self labelHeight * 1.6;
						    add: #lastVersionInfo;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: #lastNightlyVersionInfoLabel
						    height: self labelHeight * 1.6;
						    add: #lastNightlyVersionInfo;
						    yourself);
				   yourself);
		  yourself
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> connectPresenters [

	versionInfo onInfoDownloadDo: [ self thisVersionInfoLoaded ]
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> initializePresenters [

	| versionlabelText |
	repositoryNameLabel := self newLabel.
	repositoryNameLabel label: 'Plugin build / repository: '.
	versionInfoLabel := self newLabel label: 'This version / build: '.
	lastVersionInfoLabel := self newLabel label: 'Latest version: '.
	lastNightlyVersionInfoLabel := self newLabel label:
		                               'Latest nightly build: '.
	version := OPVersion current.
	repositoryName := self newLink.
	repositoryName
		label: version repositoryName;
		url: version repositoryLink.
	versionInfo := OPVersionInfo
		               newApplication: self application
		               owner: self
		               model: version.
	versionlabelText := (version needsDownloadInfo not or: [
		                     version canDownloadInfo ])
		                    ifTrue: [ 'Loading...' ]
		                    ifFalse: [ 'Unable to determine.' ].
	lastVersionInfo := self newLabel label: versionlabelText.
	lastNightlyVersionInfo := self newLabel label: versionlabelText
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		title: 'OpenPonk version info';
		initialExtent: 720 @ 200.
	aWindow windowIcon: OPCoreIcons openponkIcon
]

{ #category : 'as yet unclassified' }
OPVersionComparisonInfo >> thisVersionInfoLoaded [

	[
	[
	lastVersion := version getOfLatestRelease.
	lastVersion ifNil: [ lastVersionInfo label: 'Unknown.' ] ifNotNil: [
		lastVersionInfo := OPVersionInfo
			                   newApplication: self application
			                   model: lastVersion ].
	lastNightlyVersion := version getOfLatestNightlyBuild.
	lastNightlyVersion
		ifNil: [ lastNightlyVersionInfo label: 'Unknown.' ]
		ifNotNil: [
			lastNightlyVersionInfo := OPVersionInfo
				                          newApplication: self application
				                          model: lastNightlyVersion ].
	self layout: self defaultLayout ]
		on: ZnHttpUnsuccessful
		do: [ lastVersionInfo label: 'Failed to download info.' ] ]
		forkAt: Processor userBackgroundPriority
		named: 'Loading OpenPonk version info from GitHub'
]
