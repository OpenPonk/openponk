"
Spec presenter that displays detailed metadata for a specific OpenPonk version, including its release name, build date, and commit information.
"
Class {
	#name : 'OPVersionInfo',
	#superclass : 'SpPresenter',
	#instVars : [
		'version',
		'releaseNameLabel',
		'releaseName',
		'buildDateLabel',
		'buildDate'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'layout' }
OPVersionInfo class >> defaultLayout [
	^ SpGridLayout new
		  borderWidth: 0;
		  beColumnNotHomogeneous;
		  add: #releaseNameLabel atPoint: 1 @ 1;
		  add: #releaseName atPoint: 2 @ 1;
		  add: #buildDateLabel atPoint: 1 @ 2;
		  add: #buildDate atPoint: 2 @ 2;
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

{ #category : 'updating' }
OPVersionInfo >> refreshInfo [

	version needsDownloadInfo ifTrue: [ ^ self ].
	releaseName
		label: version releaseName;
		url: 'https://github.com/OpenPonk/' , version repositoryName
			, '/releases/tag/' , version releaseName.
	buildDate label: version buildDate asLocal asStringYMDHM
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
