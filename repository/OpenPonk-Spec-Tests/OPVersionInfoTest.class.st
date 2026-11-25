"
Tests project version parsing, metadata extraction, and semantic version comparison.
"
Class {
	#name : 'OPVersionInfoTest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'savedWindows'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'running' }
OPVersionInfoTest >> setUp [

	super setUp.
	savedWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet
]

{ #category : 'running' }
OPVersionInfoTest >> tearDown [

	savedWindows ifNotNil: [
		self currentWorld submorphs do: [ :each |
			(each isSystemWindow and: [ (savedWindows includes: each) not ]) ifTrue: [ each close ] ] ].
	super tearDown
]

{ #category : 'tests' }
OPVersionInfoTest >> testConnectPresentersRegistersCancelLoadingOnWindowClose [

	| mockVersion presenter window |
	mockVersion := Mock new.
	mockVersion stub needsDownloadInfo willReturn: true.
	mockVersion stub canDownloadInfo willReturn: true.
	mockVersion stub downloadInfo willReturn: mockVersion.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: mockVersion.
	window := nil.
	[
		window := presenter asWindow.
		window buildWithSpecLayout: presenter layout.
		window windowIsOpened.
		window windowClosed.
		self assert: (presenter instVarNamed: #isClosed) description: 'Closing parent window must cancel loading on OPVersionInfo'.
		self assert: (presenter instVarNamed: #loadingProcess) identicalTo: nil ] ensure: [
			presenter cancelLoading.
			window ifNotNil: [ window close ].
			self currentWorld doOneCycleNow ]
]

{ #category : 'tests' }
OPVersionInfoTest >> testDownloadInfoForGenerationHandlesHttpAndNetworkErrorsAndAbortsWhenClosed [

	| mockVersion presenter successCount failureCount expectedDate |
	expectedDate := DateAndTime fromString: '2026-09-01T10:05:00Z'.
	mockVersion := Mock new.
	mockVersion stub needsDownloadInfo willReturn: true.
	mockVersion stub canDownloadInfo willReturn: true.
	mockVersion stub repositoryName willReturn: 'fsm-editor'.
	mockVersion stub downloadInfo willRaise: ZnHttpUnsuccessful new.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: mockVersion.
	successCount := 0.
	failureCount := 0.

	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [ successCount := successCount + 1 ]
		onFailure: [ failureCount := failureCount + 1 ].
	self assert: failureCount equals: 1.
	self assert: successCount equals: 0.

	mockVersion stub downloadInfo willRaise: (NameLookupFailure hostName: 'api.github.com').
	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [ successCount := successCount + 1 ]
		onFailure: [ failureCount := failureCount + 1 ].
	self assert: failureCount equals: 2.
	self assert: successCount equals: 0.

	mockVersion stub downloadInfo will: [
			mockVersion stub needsDownloadInfo willReturn: false.
			mockVersion stub releaseName willReturn: 'v1.2.3'.
			mockVersion stub buildDate willReturn: expectedDate.
			mockVersion ].
	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [
				successCount := successCount + 1.
				presenter applyDownloadedInfoForGeneration: (presenter instVarNamed: #loadingGeneration) ]
		onFailure: [ failureCount := failureCount + 1 ].
	self assert: successCount equals: 1.
	self assert: failureCount equals: 2.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'v1.2.3'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink: (presenter instVarNamed: #releaseName))
		equals: 'https://github.com/OpenPonk/fsm-editor/releases/tag/v1.2.3'.
	self assert: (presenter instVarNamed: #buildDate) label equals: expectedDate asLocal asStringYMDHM.

	presenter applyFailedDownloadInfoForGeneration: 999.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'v1.2.3'.

	presenter applyFailedDownloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration).
	self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'failed to download'.

	mockVersion stub needsDownloadInfo willReturn: true.
	mockVersion stub downloadInfo will: [
			presenter cancelLoading.
			mockVersion stub needsDownloadInfo willReturn: false.
			mockVersion stub releaseName willReturn: 'v9.9.9'.
			mockVersion stub buildDate willReturn: expectedDate.
			mockVersion ].
	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [ successCount := successCount + 1 ]
		onFailure: [ failureCount := failureCount + 1 ].
	self assert: successCount equals: 1.
	self assert: failureCount equals: 2.
	presenter applyDownloadedInfoForGeneration: (presenter instVarNamed: #loadingGeneration).
	self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'
]

{ #category : 'tests' }
OPVersionInfoTest >> testDownloadInfoForGenerationWorksWithRealOPVersion [

	| runJson realVersion presenter expectedDate failureVersion failureCount |
	expectedDate := DateAndTime fromString: '2026-09-01T10:05:00Z'.
	runJson := Dictionary newFrom: {
			           (#id -> 987654).
			           (#head_branch -> 'v2.1.0').
			           (#created_at -> '2026-09-01T10:05:00Z').
			           (#repository -> (Dictionary newFrom: { (#name -> 'borm-editor') })) }.
	realVersion := OPVersion new
		               repositoryName: 'borm-editor';
		               githubWorkflowRunId: 987654;
		               yourself.
	realVersion stub getRun willReturn: runJson.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: realVersion.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'Loading...'.

	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [ presenter applyDownloadedInfoForGeneration: (presenter instVarNamed: #loadingGeneration) ]
		onFailure: [ self fail: 'Successful download on real OPVersion must not trigger failure callback' ].

	self deny: realVersion needsDownloadInfo description: 'Real OPVersion must update needsDownloadInfo after download'.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'v2.1.0'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink: (presenter instVarNamed: #releaseName))
		equals: 'https://github.com/OpenPonk/borm-editor/releases/tag/v2.1.0'.
	self assert: (presenter instVarNamed: #buildDate) label equals: expectedDate asLocal asStringYMDHM.

	failureVersion := OPVersion new
		                  repositoryName: 'borm-editor';
		                  githubWorkflowRunId: 987655;
		                  yourself.
	failureVersion stub getRun willRaise: (NameLookupFailure hostName: 'api.github.com').
	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: failureVersion.
	failureCount := 0.
	presenter
		downloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration)
		onSuccess: [ self fail: 'Network failure on real OPVersion must not trigger success callback' ]
		onFailure: [
				failureCount := failureCount + 1.
				presenter applyFailedDownloadInfoForGeneration: (presenter instVarNamed: #loadingGeneration) ].
	self assert: failureCount equals: 1.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'failed to download'
]

{ #category : 'tests' }
OPVersionInfoTest >> testGuardBranchesAndBackgroundStartLoadingInfo [

	| expectedDate mockVersion downloadCalled presenter process attempts generationBefore |
	expectedDate := DateAndTime fromString: '2026-09-01T10:05:00Z'.
	downloadCalled := false.
	mockVersion := Mock new.
	mockVersion stub needsDownloadInfo willReturn: true.
	mockVersion stub canDownloadInfo willReturn: true.
	mockVersion stub repositoryName willReturn: 'openponk'.
	mockVersion stub downloadInfo will: [
			downloadCalled := true.
			mockVersion stub needsDownloadInfo willReturn: false.
			mockVersion stub releaseName willReturn: 'v3.0.0'.
			mockVersion stub buildDate willReturn: expectedDate.
			mockVersion ].

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: mockVersion.
	[
		presenter refreshInfo.
		self assert: (presenter instVarNamed: #releaseName) label equals: 'Loading...'.

		presenter
			downloadInfoForGeneration: 999
			onSuccess: [ self fail: 'Stale generation must not invoke success callback' ]
			onFailure: [ self fail: 'Stale generation must not invoke failure callback' ].
		self deny: downloadCalled description: 'Stale generation must abort before downloadInfo'.

		presenter startLoadingInfo.
		process := presenter instVarNamed: #loadingProcess.
		attempts := 0.
		[ process isNotNil and: [ process isTerminated not and: [ attempts < 200 ] ] ] whileTrue: [
				(Delay forMilliseconds: 10) wait.
				attempts := attempts + 1 ].
		self assert: (process isNil or: [ process isTerminated ]) description: 'Background loading process should finish within timeout'.
		self currentWorld doOneCycleNow.
		self assert: downloadCalled description: 'startLoadingInfo must execute downloadInfo in background process'.
		self assert: (presenter instVarNamed: #loadingProcess) identicalTo: nil.
		self assert: (presenter instVarNamed: #releaseName) label equals: 'v3.0.0'.
		self assert: (presenter instVarNamed: #buildDate) label equals: expectedDate asLocal asStringYMDHM.

		presenter cancelLoading.
		generationBefore := presenter instVarNamed: #loadingGeneration.
		presenter startLoadingInfo.
		self assert: (presenter instVarNamed: #loadingGeneration) equals: generationBefore.
		self assert: (presenter instVarNamed: #loadingProcess) identicalTo: nil ] ensure: [ presenter cancelLoading ]
]

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWhenDownloadImpossible [

	| version presenter |
	version := OPVersion new.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: version.

	self assert: (presenter instVarNamed: #releaseName) label equals: 'Unknown'.
	self assert: (OPVersionComparisonInfoTest urlFromLink: (presenter instVarNamed: #releaseName)) equals: 'https://openponk.org'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'Unknown'
]

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWhenDownloadPossible [

	| version presenter |
	version := OPVersion new
		           githubWorkflowRunId: 12345;
		           repositoryName: 'fsm-editor'.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: version.

	self assert: (presenter instVarNamed: #releaseName) label equals: 'Loading...'.
	self assert: (OPVersionComparisonInfoTest urlFromLink: (presenter instVarNamed: #releaseName)) equals: 'https://openponk.org'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'Loading...'
]

{ #category : 'tests' }
OPVersionInfoTest >> testInitializeWithKnownRelease [

	| version presenter date |
	date := DateAndTime fromString: '2026-08-15T12:00:00+00:00'.
	version := OPVersion new
		           releaseName: 'v1.0.0';
		           repositoryName: 'class-editor';
		           buildDate: date.
	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: version.
	self assert: (presenter instVarNamed: #releaseName) label equals: 'v1.0.0'.
	self
		assert: (OPVersionComparisonInfoTest urlFromLink: (presenter instVarNamed: #releaseName))
		equals: 'https://github.com/OpenPonk/class-editor/releases/tag/v1.0.0'.
	self assert: (presenter instVarNamed: #buildDate) label equals: date asLocal asStringYMDHM
]

{ #category : 'tests' }
OPVersionInfoTest >> testLoadAndDeferInfoForGenerationAppliesRefreshAndFailureViaDefer [

	| mockVersion presenter expectedDate loadingProcess |
	expectedDate := DateAndTime fromString: '2026-09-01T10:05:00Z'.
	mockVersion := Mock new.
	mockVersion stub needsDownloadInfo willReturn: true.
	mockVersion stub canDownloadInfo willReturn: true.
	mockVersion stub repositoryName willReturn: 'fsm-editor'.
	mockVersion stub downloadInfo will: [
			mockVersion stub needsDownloadInfo willReturn: false.
			mockVersion stub releaseName willReturn: 'v2.0.0'.
			mockVersion stub buildDate willReturn: expectedDate.
			mockVersion ].

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: mockVersion.
	[
		loadingProcess := presenter newLoadingProcessForGeneration: (presenter instVarNamed: #loadingGeneration).
		self assert: loadingProcess priority equals: Processor userBackgroundPriority.
		self assert: loadingProcess name equals: 'Loading OpenPonk version info from GitHub'.
		loadingProcess terminate.

		presenter loadAndDeferInfoForGeneration: (presenter instVarNamed: #loadingGeneration).
		self currentWorld doOneCycleNow.
		self assert: (presenter instVarNamed: #releaseName) label equals: 'v2.0.0'.
		self assert: (presenter instVarNamed: #buildDate) label equals: expectedDate asLocal asStringYMDHM.

		mockVersion stub needsDownloadInfo willReturn: true.
		mockVersion stub downloadInfo willRaise: (NameLookupFailure hostName: 'api.github.com').
		presenter loadAndDeferInfoForGeneration: (presenter instVarNamed: #loadingGeneration).
		self currentWorld doOneCycleNow.
		self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'.
		self assert: (presenter instVarNamed: #buildDate) label equals: 'failed to download' ] ensure: [ presenter cancelLoading ]
]

{ #category : 'tests' }
OPVersionInfoTest >> testSetFailedInfo [

	| version presenter |
	version := OPVersion new.

	presenter := OPVersionInfo newApplication: SpApplication defaultApplication model: version.
	presenter setFailedInfo.

	self assert: (presenter instVarNamed: #releaseName) label equals: 'failed to download'.
	self assert: (presenter instVarNamed: #buildDate) label equals: 'failed to download'
]
