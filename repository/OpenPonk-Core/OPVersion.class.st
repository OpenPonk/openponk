"
I hold the current version of OpenPonk.
"
Class {
	#name : #OPVersion,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'commit',
		'buildDate',
		'commitDate',
		'githubWorkflowRunId',
		'repositoryName',
		'releaseName'
	],
	#classInstVars : [
		'current',
		'latest',
		'runsCache'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPVersion class >> current [
	^ current ifNil: [ current := self new ]
]

{ #category : #'instance creation' }
OPVersion class >> current: aVersion [
	current := aVersion.
	latest := nil.
	^ current
]

{ #category : #'instance creation' }
OPVersion class >> currentWithRunId: anId projectName: aProjectName [
	^ self
		current:
			(self new
				githubWorkflowRunId: anId;
				repositoryName: aProjectName;
				downloadInfo;
				yourself)
]

{ #category : #'instance creation' }
OPVersion class >> currentWithRunId: anId repositoryName: aRepositoryName [
	^ self currentWithRunId: anId projectName: aRepositoryName
]

{ #category : #'instance creation' }
OPVersion class >> fromRunJson: aRun [
	^ self new fromRunJson: aRun
]

{ #category : #'as yet unclassified' }
OPVersion class >> getRunsOf: aRepositoryName workflowName: aWorkflowName [

	^ self runsCache
		  at: aRepositoryName , '-' , aWorkflowName asLowercase
		  ifAbsentPut: [ 
			  | response |
			  response := ZnEasy get:
				              'https://api.github.com/repos/openponk/'
				              , aRepositoryName , '/actions/workflows/'
				              , aWorkflowName asLowercase
				              , '.yml/runs?status=success&per_page=1'.
			  response isError ifTrue: [ 
				  (ZnHttpUnsuccessful response: response) signal ].
			  (STONJSON fromString: response entity string) at: #workflow_runs ]
]

{ #category : #accessing }
OPVersion class >> latest [
	current ifNil: [ ^ nil ].
	^ latest ifNil: [ latest := self current getOfLatest ]
]

{ #category : #'as yet unclassified' }
OPVersion class >> ofLastestNightlyOf: aRepositoryName [
	^ self
		fromRunJson:
			((self getRunsOf: aRepositoryName workflowName: 'Nightly')
				ifEmpty: [ ^ nil ]
				ifNotEmpty: [ :runs | runs first ])
]

{ #category : #'as yet unclassified' }
OPVersion class >> ofLastestReleaseOf: aRepositoryName [
	^ self
		fromRunJson:
			((self getRunsOf: aRepositoryName workflowName: 'Release')
				ifEmpty: [ ^ nil ]
				ifNotEmpty: [ :runs | runs first ])
]

{ #category : #accessing }
OPVersion class >> reset [

	<script>
	current := nil.
	latest := nil.
	runsCache := nil
]

{ #category : #'as yet unclassified' }
OPVersion class >> runsCache [
	^ runsCache
		ifNil: [ runsCache := TTLCache new timeToLive: 30 minutes ]
]

{ #category : #constants }
OPVersion class >> semanticVersionRegex [
	^ 'v(\d+)\.(\d+)\.(\d+)'
]

{ #category : #constants }
OPVersion class >> unknownRepositoryName [
	^ 'Unknown / custom'
]

{ #category : #comparing }
OPVersion >> < aComparable [
	(self isRelease xor: [ aComparable isRelease ])
		ifTrue: [ ^ false ].
	self releaseName = aComparable releaseName
		ifTrue: [ ^ self buildDate < aComparable buildDate ].
	^ self releaseName < aComparable releaseName
]

{ #category : #comparing }
OPVersion >> = aComparable [
	^ self isRelease = aComparable isRelease
		and: [ self releaseName = aComparable releaseName
				and: [ self isRelease or: [ self commit = aComparable commit ] ] ]
]

{ #category : #accessing }
OPVersion >> buildDate [
	buildDate ifNil: [ self downloadInfo ].
	^ buildDate
]

{ #category : #accessing }
OPVersion >> buildDate: aDateAndTime [
	buildDate := aDateAndTime
]

{ #category : #downloading }
OPVersion >> canDownloadInfo [
	^ githubWorkflowRunId isNotNil and: [ self repositoryName isNotNil ]
]

{ #category : #accessing }
OPVersion >> commit [
	commit ifNil: [ self downloadInfo ].
	^ commit
]

{ #category : #accessing }
OPVersion >> commit: aString [
	commit := aString
]

{ #category : #accessing }
OPVersion >> commitDate [
	^ commitDate
]

{ #category : #accessing }
OPVersion >> commitDate: anObject [
	commitDate := anObject
]

{ #category : #downloading }
OPVersion >> downloadInfo [
	self githubWorkflowRunId ifNil: [ ^ self ].
	^ self fromRunJson: self getRun
]

{ #category : #'instance creation' }
OPVersion >> fromRunJson: aRun [
	| runCommit repository runReleaseName |
	runCommit := aRun at: #head_commit.
	repository := aRun at: #repository.
	runReleaseName := aRun at: #head_branch.
	runReleaseName = 'master'
		ifTrue: [ runReleaseName := 'nightly' ].
	self
		repositoryName: (repository at: #name);
		githubWorkflowRunId: (aRun at: #id);
		releaseName: runReleaseName;
		commit: (runCommit at: #id);
		commitDate: (runCommit at: #timestamp) asDateAndTime asLocal;
		buildDate: (aRun at: #created_at) asDateAndTime asLocal
]

{ #category : #accessing }
OPVersion >> fullVersionString [
	(repositoryName isNil or: [ githubWorkflowRunId isNil ])
		ifTrue: [ ^ 'unknown' ].
	^ String
		streamContents: [ :stream | 
			stream << self repositoryName << '-' << self releaseName.
			self isRelease
				ifFalse: [ stream << '-' << self commit ] ]
]

{ #category : #downloading }
OPVersion >> getOfLatest [
	^ self isRelease
		ifTrue: [ self getOfLatestRelease ]
		ifFalse: [ self getOfLatestNightlyBuild ]
]

{ #category : #downloading }
OPVersion >> getOfLatestNightlyBuild [
	^ self class ofLastestNightlyOf: self repositoryName
]

{ #category : #downloading }
OPVersion >> getOfLatestRelease [
	^ self class ofLastestReleaseOf: self repositoryName
]

{ #category : #downloading }
OPVersion >> getRun [
	| response client githubToken |
	client := ZnClient new.
	client
		url:
			'https://api.github.com/repos/openponk/' , self repositoryName
				, '/actions/runs/' , self githubWorkflowRunId asString.
	githubToken := OSEnvironment current
		at: 'ACTIONS_READ_ACCESS_TOKEN'
		ifAbsent: [ nil ].
	githubToken
		ifNotNil: [ :token | 
			Stdio stdout
				nextPutAll: 'Loading version info using GitHub API token';
				nextPutAll: OSPlatform current lineEnding.
			client request setAuthorization: 'Bearer ' , githubToken ].
	response := client
		get;
		response.
	response isError
		ifTrue: [ (Smalltalk image isInteractive not
				and: [ response code = 403
						and: [ response statusLine reason includesSubstring: 'rate limit' ] ])
				ifTrue: [ | reset resetIn |
					reset := DateAndTime
						fromUnixTime: (response headers at: 'X-RateLimit-Reset') asInteger.
					resetIn := reset - DateAndTime now.
					Stdio stdout
						nextPutAll:
							'Downloading OPVersion run info failed due to rate limiting. Limit resets at '.
					reset printHMSOn: Stdio stdout.
					Stdio stdout
						nextPutAll: ' (in ';
						nextPutAll: resetIn minutes asString;
						nextPutAll: ' min, ';
						nextPutAll: resetIn seconds asString;
						nextPutAll: ' sec).';
						nextPutAll: OSPlatform current lineEnding.
					resetIn < 8 minutes
						ifTrue: [ Stdio stdout nextPutAll: 'Waiting until reset...'.
							resetIn wait.
							^ self getRun ]
						ifFalse: [ (ZnHttpUnsuccessful response: response) signal ] ]
				ifFalse: [ (ZnHttpUnsuccessful response: response) signal ] ]
		ifFalse: [ ^ STONJSON fromString: response entity string ]
]

{ #category : #accessing }
OPVersion >> githubWorkflowRunId [
	^ githubWorkflowRunId
]

{ #category : #accessing }
OPVersion >> githubWorkflowRunId: anObject [
	githubWorkflowRunId := anObject
]

{ #category : #comparing }
OPVersion >> hash [
	self isRelease
		ifFalse: [ ^ self commit hash ].
	^ self releaseName hash
]

{ #category : #testing }
OPVersion >> isMostRecent [
	^ self getOfLatest = self
]

{ #category : #accessing }
OPVersion >> isRelease [
	^ self releaseName isNotNil
		and: [ self releaseName matchesRegex: self class semanticVersionRegex ]
]

{ #category : #accessing }
OPVersion >> isRepositoryNameKnown [
	^ self repositoryName ~= self class unknownRepositoryName
]

{ #category : #downloading }
OPVersion >> needsDownloadInfo [
	^ commit isNil
]

{ #category : #accessing }
OPVersion >> releaseName [
	releaseName ifNil: [ self downloadInfo ].
	^ releaseName
]

{ #category : #accessing }
OPVersion >> releaseName: aString [
	releaseName := aString
]

{ #category : #accessing }
OPVersion >> repositoryName [

	^ repositoryName ifNil: [ 
		  | activePlugins |
		  activePlugins := { 
			                   ((Smalltalk globals includesKey:
				                     #BaselineOfClassEditor) ifTrue: [ 
				                    #'class-editor' ]).
			                   ((Smalltalk globals includesKey:
				                     #BaselineOfBormEditor) ifTrue: [ 
				                    #'borm-editor' ]).
			                   ((Smalltalk globals includesKey:
				                     #BaselineOfFsmEditor) ifTrue: [ 
				                    #'fsm-editor' ]).
			                   ((Smalltalk globals includesKey:
				                     #BaselineOfPetriNets) ifTrue: [ #petrinets ]).
			                   ((Smalltalk globals includesKey: #BaselineOfBPMN) 
				                    ifTrue: [ #'OpenPonk-BPMN' ]) } reject: #isNil.
		  repositoryName := activePlugins size >= 4
			                    ifTrue: [ #plugins ]
			                    ifFalse: [ 
				                    activePlugins size = 1
					                    ifTrue: [ activePlugins first ]
					                    ifFalse: [ self class unknownRepositoryName ] ] ]
]

{ #category : #accessing }
OPVersion >> repositoryName: aString [
	repositoryName := aString
]

{ #category : #accessing }
OPVersion >> repositoryNotationName [

	| notationNames |
	notationNames := { 
		                 (#'class-editor' -> '(Onto)UML').
		                 (#'borm-editor' -> 'BORM').
		                 (#'fsm-editor' -> 'FSM').
		                 (#petrinets -> 'Petri nets').
		                 (#'OpenPonk-BPMN' -> 'BPMN').
		                 (#plugins -> 'All plugins') } asDictionary.
	^ notationNames
		  at: self repositoryName
		  ifAbsent: [ self repositoryName ]
]
