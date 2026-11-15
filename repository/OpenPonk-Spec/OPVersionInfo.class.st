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
		'buildDate',
		'loadingProcess',
		'loadingGeneration',
		'isClosed'
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

{ #category : 'updating' }
OPVersionInfo >> applyDownloadedInfoForGeneration: aGeneration [

	(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
	self refreshInfo
]

{ #category : 'updating' }
OPVersionInfo >> applyFailedDownloadInfoForGeneration: aGeneration [

	(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
	self setFailedInfo
]

{ #category : 'private' }
OPVersionInfo >> cancelActiveLoadingProcess [

	loadingProcess ifNotNil: [ :activeProcess |
			loadingProcess := nil.
			(activeProcess ~~ Processor activeProcess and: [ activeProcess isTerminated not ]) ifTrue: [ activeProcess terminate ] ]
]

{ #category : 'private' }
OPVersionInfo >> cancelLoading [

	isClosed := true.
	loadingGeneration := loadingGeneration + 1.
	self cancelActiveLoadingProcess
]

{ #category : 'initialization' }
OPVersionInfo >> connectPresenters [

	(version needsDownloadInfo and: [ version canDownloadInfo ]) ifFalse: [ ^ self ].
	self whenBuiltDo: [
			self withWindowDo: [ :window | window whenClosedDo: [ self cancelLoading ] ].
			self startLoadingInfo ]
]

{ #category : 'private' }
OPVersionInfo >> downloadInfoForGeneration: aGeneration onSuccess: aSuccessBlock onFailure: aFailureBlock [

	[
		(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
		version downloadInfo.
		(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
		aSuccessBlock value ]
		on: ZnHttpUnsuccessful , NetworkError
		do: [ (self shouldAbortLoadingForGeneration: aGeneration) ifFalse: [ aFailureBlock value ] ]
]

{ #category : 'initialization' }
OPVersionInfo >> initializePresenters [

	| unknownLabel |
	isClosed := false.
	loadingGeneration := 0.
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

{ #category : 'private' }
OPVersionInfo >> loadAndDeferInfoForGeneration: aGeneration [

	self
		downloadInfoForGeneration: aGeneration
		onSuccess: [ self defer: [ self applyDownloadedInfoForGeneration: aGeneration ] ]
		onFailure: [ self defer: [ self applyFailedDownloadInfoForGeneration: aGeneration ] ]
]

{ #category : 'private' }
OPVersionInfo >> newLoadingProcessForGeneration: aGeneration [

	^ [
		  [ self loadAndDeferInfoForGeneration: aGeneration ] ensure: [
				  loadingProcess == Processor activeProcess ifTrue: [ loadingProcess := nil ] ] ] newProcess
		  priority: Processor userBackgroundPriority;
		  name: 'Loading OpenPonk version info from GitHub';
		  yourself
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

{ #category : 'private' }
OPVersionInfo >> shouldAbortLoadingForGeneration: aGeneration [

	^ isClosed or: [ aGeneration ~= loadingGeneration ]
]

{ #category : 'private' }
OPVersionInfo >> startLoadingInfo [

	| currentGeneration process |
	isClosed ifTrue: [ ^ self ].
	self cancelActiveLoadingProcess.
	loadingGeneration := loadingGeneration + 1.
	currentGeneration := loadingGeneration.
	process := self newLoadingProcessForGeneration: currentGeneration.
	loadingProcess := process.
	process resume
]
