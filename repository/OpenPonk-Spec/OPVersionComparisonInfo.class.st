"
Spec presenter that displays version comparison information. 
Shows the current OpenPonk version alongside the latest release and nightly builds to help users track updates and determine if an upgrade is available.
"
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
		'lastNightlyVersionInfo',
		'lastVersionContainer',
		'lastNightlyVersionContainer',
		'loadingProcess',
		'loadingGeneration',
		'isClosed'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'layout' }
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
						    add: #lastVersionContainer;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: #lastNightlyVersionInfoLabel height: self labelHeight * 1.6;
						    add: #lastNightlyVersionContainer;
						    yourself);
				   yourself);
		  yourself
]

{ #category : 'updating' }
OPVersionComparisonInfo >> applyFailedDownloadInfoForGeneration: aGeneration [

	(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
	lastVersionInfo := self updatePresenter: lastVersionInfo in: lastVersionContainer withStatusText: 'Failed to download info.'.
	lastNightlyVersionInfo := self
		                          updatePresenter: lastNightlyVersionInfo
		                          in: lastNightlyVersionContainer
		                          withStatusText: 'Failed to download info.'
]

{ #category : 'updating' }
OPVersionComparisonInfo >> applyLoadedRelease: aReleaseVersion nightly: aNightlyVersion generation: aGeneration [

	(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
	lastVersion := aReleaseVersion.
	lastNightlyVersion := aNightlyVersion.
	lastVersionInfo := self updatePresenter: lastVersionInfo in: lastVersionContainer forVersion: aReleaseVersion.
	lastNightlyVersionInfo := self
		                          updatePresenter: lastNightlyVersionInfo
		                          in: lastNightlyVersionContainer
		                          forVersion: aNightlyVersion
]

{ #category : 'private' }
OPVersionComparisonInfo >> cancelActiveLoadingProcess [

	loadingProcess ifNotNil: [ :activeProcess |
			loadingProcess := nil.
			(activeProcess ~~ Processor activeProcess and: [ activeProcess isTerminated not ]) ifTrue: [ activeProcess terminate ] ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> cancelChildVersionInfos [

	versionInfo ifNotNil: [ versionInfo cancelLoading ].
	lastVersionInfo class == OPVersionInfo ifTrue: [ lastVersionInfo cancelLoading ].
	lastNightlyVersionInfo class == OPVersionInfo ifTrue: [ lastNightlyVersionInfo cancelLoading ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> cancelLoading [

	isClosed := true.
	loadingGeneration := loadingGeneration + 1.
	self cancelActiveLoadingProcess.
	self cancelChildVersionInfos
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> connectPresenters [

	version isRepositoryNameKnown ifTrue: [ self whenBuiltDo: [ self thisVersionInfoLoaded ] ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> fetchVersionInfoForGeneration: aGeneration onSuccess: aSuccessBlock onFailure: aFailureBlock [

	[
		| fetchedRelease fetchedNightly |
		(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
		fetchedRelease := version getOfLatestRelease.
		(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
		fetchedNightly := version getOfLatestNightlyBuild.
		(self shouldAbortLoadingForGeneration: aGeneration) ifTrue: [ ^ self ].
		aSuccessBlock value: fetchedRelease value: fetchedNightly ]
		on: ZnHttpUnsuccessful , NetworkError
		do: [ (self shouldAbortLoadingForGeneration: aGeneration) ifFalse: [ aFailureBlock value ] ]
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> initializeContainer: aContainer withLabelPresenter: aLabelPresenter [

	aLabelPresenter owner: aContainer.
	aContainer layout: (SpBoxLayout newTopToBottom
			 add: aLabelPresenter;
			 yourself)
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> initializePresenters [

	| versionlabelText |
	isClosed := false.
	loadingGeneration := 0.
	repositoryNameLabel := self newLabel.
	repositoryNameLabel label: 'Plugin build / repository: '.
	versionInfoLabel := self newLabel label: 'This version / build: '.
	lastVersionInfoLabel := self newLabel label: 'Latest version: '.
	lastNightlyVersionInfoLabel := self newLabel label: 'Latest nightly build: '.
	version := OPVersion current.
	repositoryName := self newLink.
	repositoryName
		label: version repositoryName;
		url: version repositoryLink.
	versionInfo := OPVersionInfo newApplication: self application owner: self model: version.
	versionlabelText := version isRepositoryNameKnown
		                    ifTrue: [ 'Loading...' ]
		                    ifFalse: [ 'Unable to determine.' ].
	lastVersionContainer := self newPresenter.
	lastVersionInfo := self newLabel label: versionlabelText.
	self initializeContainer: lastVersionContainer withLabelPresenter: lastVersionInfo.
	lastNightlyVersionContainer := self newPresenter.
	lastNightlyVersionInfo := self newLabel label: versionlabelText.
	self initializeContainer: lastNightlyVersionContainer withLabelPresenter: lastNightlyVersionInfo
]

{ #category : 'initialization' }
OPVersionComparisonInfo >> initializeWindow: aWindow [

	super initializeWindow: aWindow.
	aWindow
		title: 'OpenPonk version info';
		initialExtent: 720 @ 200;
		windowIcon: OPCoreIcons openponkIcon;
		whenClosedDo: [ self cancelLoading ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> loadAndDeferVersionInfoForGeneration: aGeneration [

	self
		fetchVersionInfoForGeneration: aGeneration
		onSuccess: [ :releaseVersion :nightlyVersion |
			self defer: [ self applyLoadedRelease: releaseVersion nightly: nightlyVersion generation: aGeneration ] ]
		onFailure: [ self defer: [ self applyFailedDownloadInfoForGeneration: aGeneration ] ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> newLoadingProcessForGeneration: aGeneration [

	^ [
		  [ self loadAndDeferVersionInfoForGeneration: aGeneration ] ensure: [
				  loadingProcess == Processor activeProcess ifTrue: [ loadingProcess := nil ] ] ] newProcess
		  priority: Processor userBackgroundPriority;
		  name: 'Loading OpenPonk version info from GitHub';
		  yourself
]

{ #category : 'private' }
OPVersionComparisonInfo >> replacePresenter: currentPresenter in: containerPresenter with: newPresenter [

	currentPresenter class == OPVersionInfo ifTrue: [ currentPresenter cancelLoading ].
	currentPresenter withAdapterDo: [ :anAdapter | anAdapter unsubscribe ].
	containerPresenter layout replace: currentPresenter with: newPresenter.
	^ newPresenter
]

{ #category : 'private' }
OPVersionComparisonInfo >> shouldAbortLoadingForGeneration: aGeneration [

	^ isClosed or: [ aGeneration ~= loadingGeneration ]
]

{ #category : 'private' }
OPVersionComparisonInfo >> thisVersionInfoLoaded [

	| currentGeneration process |
	isClosed ifTrue: [ ^ self ].
	self cancelActiveLoadingProcess.
	loadingGeneration := loadingGeneration + 1.
	currentGeneration := loadingGeneration.
	process := self newLoadingProcessForGeneration: currentGeneration.
	loadingProcess := process.
	process resume
]

{ #category : 'private' }
OPVersionComparisonInfo >> updatePresenter: currentPresenter in: containerPresenter forVersion: aVersion [

	| newPresenter |
	aVersion ifNil: [ ^ self updatePresenter: currentPresenter in: containerPresenter withStatusText: 'Unknown.' ].
	newPresenter := OPVersionInfo newApplication: self application owner: containerPresenter model: aVersion.
	^ self replacePresenter: currentPresenter in: containerPresenter with: newPresenter
]

{ #category : 'private' }
OPVersionComparisonInfo >> updatePresenter: currentPresenter in: containerPresenter withStatusText: aString [

	| newLabel |
	currentPresenter class == SpLabelPresenter ifTrue: [
			currentPresenter label: aString.
			^ currentPresenter ].
	newLabel := self newLabel
		            label: aString;
		            owner: containerPresenter;
		            yourself.
	^ self replacePresenter: currentPresenter in: containerPresenter with: newLabel
]
