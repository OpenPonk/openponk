"
Tests semantic version comparison, upgrade detection, and release notification formatting.
"
Class {
	#name : 'OPVersionComparisonInfoTest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'savedCurrent',
		'savedLatest',
		'savedWindows'
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
	savedLatest := OPVersion instVarNamed: #latest.
	savedWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet
]

{ #category : 'running' }
OPVersionComparisonInfoTest >> tearDown [

	[
		savedWindows ifNotNil: [
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (savedWindows includes: each) not ]) ifTrue: [ each close ] ] ] ] ensure: [
			OPVersion instVarNamed: #current put: savedCurrent.
			OPVersion instVarNamed: #latest put: savedLatest ].
	super tearDown
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testApplyLoadedReleaseAndFailureUpdateContainersWithoutRebuildingRootLayout [

	| unknownVersion presenter window rootAdapter rootWidget versionInfoWidget lastVersionContainer lastNightlyContainer lastVersionContainerWidget lastNightlyContainerWidget releaseVer nightlyVer releaseInfoWidget nightlyInfoWidget failedReleaseLabel failedNightlyLabel |
	unknownVersion := OPVersion new
		                  repositoryName: OPVersion unknownRepositoryName;
		                  yourself.
	OPVersion instVarNamed: #current put: unknownVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	window := presenter asWindow.
	[
		window buildWithSpecLayout: presenter layout.
		rootAdapter := presenter adapter.
		rootWidget := rootAdapter widget.
		versionInfoWidget := (presenter instVarNamed: #versionInfo) adapter widget.
		lastVersionContainer := presenter instVarNamed: #lastVersionContainer.
		lastNightlyContainer := presenter instVarNamed: #lastNightlyVersionContainer.
		lastVersionContainerWidget := lastVersionContainer adapter widget.
		lastNightlyContainerWidget := lastNightlyContainer adapter widget.

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

		presenter applyLoadedRelease: releaseVer nightly: nightlyVer generation: (presenter instVarNamed: #loadingGeneration).

		self assert: presenter adapter identicalTo: rootAdapter.
		self assert: presenter adapter widget identicalTo: rootWidget.
		self assert: (presenter instVarNamed: #versionInfo) adapter widget identicalTo: versionInfoWidget.
		self assert: lastVersionContainer adapter widget identicalTo: lastVersionContainerWidget.
		self assert: lastNightlyContainer adapter widget identicalTo: lastNightlyContainerWidget.

		self assert: (presenter instVarNamed: #lastVersionInfo) class identicalTo: OPVersionInfo.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) class identicalTo: OPVersionInfo.
		self assert: (presenter instVarNamed: #lastVersionInfo) owner identicalTo: lastVersionContainer.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) owner identicalTo: lastNightlyContainer.
		releaseInfoWidget := (presenter instVarNamed: #lastVersionInfo) adapter widget.
		nightlyInfoWidget := (presenter instVarNamed: #lastNightlyVersionInfo) adapter widget.
		self assertCollection: lastVersionContainerWidget allMorphs includesAll: { releaseInfoWidget }.
		self assertCollection: lastNightlyContainerWidget allMorphs includesAll: { nightlyInfoWidget }.

		presenter applyFailedDownloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration).

		self assert: presenter adapter identicalTo: rootAdapter.
		self assert: presenter adapter widget identicalTo: rootWidget.
		self assert: lastVersionContainer adapter widget identicalTo: lastVersionContainerWidget.
		self assert: lastNightlyContainer adapter widget identicalTo: lastNightlyContainerWidget.
		failedReleaseLabel := presenter instVarNamed: #lastVersionInfo.
		failedNightlyLabel := presenter instVarNamed: #lastNightlyVersionInfo.
		self assert: failedReleaseLabel class identicalTo: SpLabelPresenter.
		self assert: failedNightlyLabel class identicalTo: SpLabelPresenter.
		self assert: failedReleaseLabel label equals: 'Failed to download info.'.
		self assert: failedNightlyLabel label equals: 'Failed to download info.'.
		self assert: failedReleaseLabel owner identicalTo: lastVersionContainer.
		self assert: failedNightlyLabel owner identicalTo: lastNightlyContainer.
		self assertCollection: lastVersionContainerWidget allMorphs includesAll: { failedReleaseLabel adapter widget }.
		self assertCollection: lastNightlyContainerWidget allMorphs includesAll: { failedNightlyLabel adapter widget }.
		self denyCollection: lastVersionContainerWidget allMorphs includesAny: { releaseInfoWidget }.
		self denyCollection: lastNightlyContainerWidget allMorphs includesAny: { nightlyInfoWidget }.

		presenter applyLoadedRelease: releaseVer nightly: nightlyVer generation: 999.
		self assert: (presenter instVarNamed: #lastVersionInfo) identicalTo: failedReleaseLabel.

		presenter cancelLoading.
		presenter applyLoadedRelease: releaseVer nightly: nightlyVer generation: (presenter instVarNamed: #loadingGeneration).
		self assert: (presenter instVarNamed: #lastVersionInfo) identicalTo: failedReleaseLabel ] ensure: [
			presenter cancelLoading.
			window close ]
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testFetchVersionInfoAbortsWhenClosedOrSupersededWithoutSecondFetch [

	| unknownVersion mockVersion presenter window nightlyCalled successCount failureCount |
	unknownVersion := OPVersion new
		                  repositoryName: OPVersion unknownRepositoryName;
		                  yourself.
	OPVersion instVarNamed: #current put: unknownVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	window := nil.
	[
		window := presenter open.
		nightlyCalled := false.
		successCount := 0.
		failureCount := 0.

		mockVersion := Mock new.
		mockVersion stub getOfLatestRelease willRaise: (NameLookupFailure hostName: 'api.github.com').
		mockVersion stub getOfLatestNightlyBuild will: [
				nightlyCalled := true.
				nil ].
		presenter instVarNamed: #version put: mockVersion.
		presenter
			fetchVersionInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
			onSuccess: [ :rel :nig | successCount := successCount + 1 ]
			onFailure: [ failureCount := failureCount + 1 ].
		self assert: failureCount equals: 1.
		self assert: successCount equals: 0.
		self deny: nightlyCalled description: 'NetworkError during release fetch should trigger failure without nightly fetch'.

		mockVersion := Mock new.
		mockVersion stub getOfLatestRelease will: [
				window close.
				OPVersion new ].
		mockVersion stub getOfLatestNightlyBuild will: [
				nightlyCalled := true.
				nil ].
		presenter instVarNamed: #version put: mockVersion.
		presenter
			fetchVersionInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
			onSuccess: [ :rel :nig | successCount := successCount + 1 ]
			onFailure: [ failureCount := failureCount + 1 ].
		self assert: (presenter instVarNamed: #isClosed) description: 'Closing the window must mark presenter closed'.
		self deny: nightlyCalled description: 'Closing the window during release fetch must abort before nightly fetch'.
		self assert: successCount equals: 0.
		self assert: failureCount equals: 1 ] ensure: [
			presenter cancelLoading.
			window ifNotNil: [ window close ] ]
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
OPVersionComparisonInfoTest >> testInitializeWindowRegistersCancelLoadingBeforeBuild [

	| unknownVersion presenter window |
	unknownVersion := OPVersion new
		                  repositoryName: OPVersion unknownRepositoryName;
		                  yourself.
	OPVersion instVarNamed: #current put: unknownVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	window := presenter asWindow.
	window windowIsOpened.
	window windowClosed.

	self
		assert: (presenter instVarNamed: #isClosed)
		description: 'Closing window initialized via asWindow must invoke cancelLoading even before widget build'.
	self
		assert: ((presenter instVarNamed: #versionInfo) instVarNamed: #isClosed)
		description: 'Closing OPVersionComparisonInfo window must also cancel child versionInfo loading'
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testReplacePresenterCancelsPreviousVersionInfoLoading [

	| unknownVersion presenter window firstRelease secondRelease previousVersionInfo |
	unknownVersion := OPVersion new
		                  repositoryName: OPVersion unknownRepositoryName;
		                  yourself.
	OPVersion instVarNamed: #current put: unknownVersion.

	presenter := OPVersionComparisonInfo newApplication: SpApplication defaultApplication.
	window := presenter asWindow.
	[
		window buildWithSpecLayout: presenter layout.
		firstRelease := OPVersion new
			                repositoryName: 'openponk';
			                releaseName: 'v1.0.0';
			                buildDate: DateAndTime now;
			                yourself.
		secondRelease := OPVersion new
			                 repositoryName: 'openponk';
			                 releaseName: 'v2.0.0';
			                 buildDate: DateAndTime now;
			                 yourself.
		presenter applyLoadedRelease: firstRelease nightly: nil generation: (presenter instVarNamed: #loadingGeneration).
		previousVersionInfo := presenter instVarNamed: #lastVersionInfo.
		presenter applyLoadedRelease: secondRelease nightly: nil generation: (presenter instVarNamed: #loadingGeneration).
		self
			assert: (previousVersionInfo instVarNamed: #isClosed)
			description: 'Replacing an OPVersionInfo child presenter must cancel its loading state' ] ensure: [
			presenter cancelLoading.
			window close ]
]

{ #category : 'tests' }
OPVersionComparisonInfoTest >> testThisVersionInfoLoadedWithReleaseNightlyUnknownAndHttpError [

	| mockVersion presenter window releaseVersion nightlyVersion rootAdapter rootWidget versionInfoWidget |
	self assert: OPVersionComparisonInfo defaultLayout class identicalTo: SpBoxLayout.

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
	window := presenter asWindow.
	[
		window buildWithSpecLayout: presenter layout.
		rootAdapter := presenter adapter.
		rootWidget := rootAdapter widget.
		versionInfoWidget := (presenter instVarNamed: #versionInfo) adapter widget.
		presenter thisVersionInfoLoaded.
		self waitForLoadingToFinishOn: presenter.
		self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Unknown.'.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Unknown.'.

		releaseVersion := OPVersion new
			                  repositoryName: 'openponk';
			                  releaseName: 'v2.0.0';
			                  buildDate: DateAndTime now;
			                  yourself.
		nightlyVersion := OPVersion new
			                  repositoryName: 'openponk';
			                  releaseName: 'nightly-12345';
			                  githubWorkflowRunId: 12345;
			                  buildDate: DateAndTime now;
			                  yourself.
		mockVersion stub getOfLatestRelease willReturn: releaseVersion.
		mockVersion stub getOfLatestNightlyBuild willReturn: nightlyVersion.

		presenter thisVersionInfoLoaded.
		self waitForLoadingToFinishOn: presenter.
		self assert: (presenter instVarNamed: #lastVersionInfo) class identicalTo: OPVersionInfo.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) class identicalTo: OPVersionInfo.
		self assert: presenter adapter identicalTo: rootAdapter.
		self assert: presenter adapter widget identicalTo: rootWidget.
		self assert: (presenter instVarNamed: #versionInfo) adapter widget identicalTo: versionInfoWidget.

		mockVersion stub getOfLatestRelease willRaise: ZnHttpUnsuccessful new.
		presenter thisVersionInfoLoaded.
		self waitForLoadingToFinishOn: presenter.
		self assert: (presenter instVarNamed: #lastVersionInfo) class identicalTo: SpLabelPresenter.
		self assert: (presenter instVarNamed: #lastVersionInfo) label equals: 'Failed to download info.'.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) class identicalTo: SpLabelPresenter.
		self assert: (presenter instVarNamed: #lastNightlyVersionInfo) label equals: 'Failed to download info.'.
		self assert: presenter adapter identicalTo: rootAdapter.
		self assert: presenter adapter widget identicalTo: rootWidget.
		self assert: (presenter instVarNamed: #versionInfo) adapter widget identicalTo: versionInfoWidget ] ensure: [
			presenter cancelLoading.
			window close ]
]

{ #category : 'private' }
OPVersionComparisonInfoTest >> waitForLoadingToFinishOn: aPresenter [

	| process attempts |
	process := aPresenter instVarNamed: #loadingProcess.
	attempts := 0.
	[ process isNotNil and: [ process isTerminated not and: [ attempts < 200 ] ] ] whileTrue: [
			(Delay forMilliseconds: 10) wait.
			attempts := attempts + 1 ].
	self assert: (process isNil or: [ process isTerminated ]) description: 'Background loading process should finish within timeout'.
	self currentWorld doOneCycleNow
]
