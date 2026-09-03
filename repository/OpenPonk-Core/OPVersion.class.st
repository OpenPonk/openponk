"
Represents a version specification for OpenPonk artifacts or plugins. 
Holds metadata such as build date, commit hash, workflow run IDs, and semantic version identifiers.
"
Class {
	#name : 'OPVersion',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'buildDate',
		'githubWorkflowRunId',
		'repositoryName',
		'releaseName'
	],
	#classInstVars : [
		'current',
		'latest',
		'runsCache'
	],
	#category : 'OpenPonk-Core-Version',
	#package : 'OpenPonk-Core',
	#tag : 'Version'
}

{ #category : 'accessing' }
OPVersion class >> current [

	^ current ifNil: [ current := self new ]
]

{ #category : 'instance creation' }
OPVersion class >> current: aVersion [

	current := aVersion.
	latest := nil.
	^ current
]

{ #category : 'instance creation' }
OPVersion class >> currentWithRunId: anId projectName: aProjectName [
	^ self
		current:
			(self new
				githubWorkflowRunId: anId;
				repositoryName: aProjectName;
				downloadInfo;
				yourself)
]

{ #category : 'instance creation' }
OPVersion class >> currentWithRunId: anId repositoryName: aRepositoryName [
	^ self currentWithRunId: anId projectName: aRepositoryName
]

{ #category : 'instance creation' }
OPVersion class >> fromReleaseJson: aRelease repositoryName: aRepositoryName [
	^ self new fromReleaseJson: aRelease repositoryName: aRepositoryName
]

{ #category : 'instance creation' }
OPVersion class >> fromRunJson: aRun [
	^ self new fromRunJson: aRun
]

{ #category : 'fetching' }
OPVersion class >> getReleasesOf: aRepositoryName [

	^ self runsCache at: aRepositoryName , '-releases' ifAbsentPut: [
			  | client response githubToken |
			  client := ZnClient new.
			  client url:
				  'https://api.github.com/repos/openponk/' , aRepositoryName
				  , '/releases?per_page=30'.
			  githubToken := OSEnvironment current
				                 at: 'ACTIONS_READ_ACCESS_TOKEN'
				                 ifAbsent: [ nil ].
			  githubToken ifNotNil: [ :token |
				  client request setAuthorization: 'Bearer ' , token ].
			  response := client
				              get;
				              response.
			  response code = 404
				  ifTrue: [ #(  ) ]
				  ifFalse: [
						  response isError ifTrue: [
							  (ZnHttpUnsuccessful response: response) signal ].
						  STONJSON fromString: response entity string ] ]
]

{ #category : 'private' }
OPVersion class >> isVersionTag: tagA greaterThanOrEqualTo: tagB [
	| numsA numsB |
	numsA := self versionNumbersFromTag: tagA.
	numsB := self versionNumbersFromTag: tagB.
	1 to: (numsA size min: numsB size) do: [ :i | 
		(numsA at: i) = (numsB at: i) ifFalse: [ 
			^ (numsA at: i) > (numsB at: i) ] ].
	^ numsA size >= numsB size
]

{ #category : 'accessing' }
OPVersion class >> latest [
	current ifNil: [ ^ nil ].
	^ latest ifNil: [ latest := self current getOfLatest ]
]

{ #category : 'accessing' }
OPVersion class >> ofLastestNightlyOf: aRepositoryName [

	| releases nightlyJson title date version |
	releases := self getReleasesOf: aRepositoryName.
	nightlyJson := releases
		               detect: [ :each |
		               (each at: #tag_name ifAbsent: [ '' ]) = 'nightly' ]
		               ifNone: [
				               releases
					               detect: [ :each |
					               each at: #prerelease ifAbsent: [ false ] ]
					               ifNone: [ nil ] ].
	nightlyJson ifNil: [ ^ nil ].
	version := self
		           fromReleaseJson: nightlyJson
		           repositoryName: aRepositoryName.
	title := nightlyJson at: #name ifAbsent: [ '' ].
	(title beginsWith: 'nightly-') ifTrue: [
			[
				date := (title allButFirst: 8) asDateAndTime.
				version buildDate: date ]
				on: Error
				do: [ :e | "fallback on published_at" ] ].
	^ version
]

{ #category : 'accessing' }
OPVersion class >> ofLastestReleaseOf: aRepositoryName [

	| releases stable |
	releases := self getReleasesOf: aRepositoryName.
	stable := releases select: [ :each |
			          (each at: #prerelease ifAbsent: [ false ]) not and: [
					          (each at: #draft ifAbsent: [ false ]) not and: [
							          (each at: #tag_name ifAbsent: [ '' ]) matchesRegex:
								          self semanticVersionRegex ] ] ].
	stable ifEmpty: [ ^ nil ].
	^ self
		  fromReleaseJson: (stable detectMax: [ :each |
					   | parts |
					   parts := ((each at: #tag_name) copyWithout: $v) splitOn: '.'.
					   parts
						   inject: 0
						   into: [ :acc :n | acc * 1000 + (n asInteger ifNil: [ 0 ]) ] ])
		  repositoryName: aRepositoryName
]

{ #category : 'class initialization' }
OPVersion class >> reset [

	<script>
	current := nil.
	latest := nil.
	runsCache := nil
]

{ #category : 'private' }
OPVersion class >> runsCache [
	^ runsCache
		ifNil: [ runsCache := TTLCache new timeToLive: 30 minutes ]
]

{ #category : 'constants' }
OPVersion class >> semanticVersionRegex [
	^ 'v(\d+)\.(\d+)\.(\d+)'
]

{ #category : 'constants' }
OPVersion class >> unknownRepositoryName [
	^ 'Unknown / custom'
]

{ #category : 'private' }
OPVersion class >> versionNumbersFromTag: aTag [
	| raw |
	raw := (aTag beginsWith: 'v')
		       ifTrue: [ aTag allButFirst ]
		       ifFalse: [ aTag ].
	^ (raw splitOn: '.') collect: [ :each | 
		  each asInteger ifNil: [ 0 ] ]
]

{ #category : 'comparing' }
OPVersion >> < aComparable [

	(self isRelease xor: [ aComparable isRelease ]) ifTrue: [ ^ false ].
	self releaseName = aComparable releaseName ifTrue: [
		^ self buildDate < aComparable buildDate ].
	self isRelease ifTrue: [
			^ (self class
				   isVersionTag: self releaseName
				   greaterThanOrEqualTo: aComparable releaseName) not ].
	^ self releaseName < aComparable releaseName
]

{ #category : 'comparing' }
OPVersion >> = aComparable [
	self species = aComparable species ifFalse: [ ^ false ].
	^ self releaseName = aComparable releaseName and: [
		  self isRelease or: [ self buildDate = aComparable buildDate ] ]
]

{ #category : 'accessing' }
OPVersion >> buildDate [

	buildDate ifNil: [ self downloadInfo ].
	^ buildDate
]

{ #category : 'accessing' }
OPVersion >> buildDate: aDateAndTime [

	buildDate := aDateAndTime
]

{ #category : 'downloading' }
OPVersion >> canDownloadInfo [
	^ githubWorkflowRunId isNotNil and: [ self repositoryName isNotNil ]
]

{ #category : 'downloading' }
OPVersion >> downloadInfo [
	self githubWorkflowRunId ifNil: [ ^ self ].
	^ self fromRunJson: self getRun
]

{ #category : 'instance creation' }
OPVersion >> fromReleaseJson: aRelease repositoryName: aRepositoryName [

	| date |
	date := ((aRelease at: #published_at ifAbsent: [ nil ]) ifNil: [
		         aRelease at: #created_at ]) asDateAndTime.
	self
		repositoryName: aRepositoryName;
		githubWorkflowRunId: (aRelease at: #id);
		releaseName: (aRelease at: #tag_name);
		buildDate: date
]

{ #category : 'instance creation' }
OPVersion >> fromRunJson: aRun [

	| repository runReleaseName |
	repository := aRun at: #repository.
	runReleaseName := aRun at: #head_branch.
	runReleaseName = 'master' ifTrue: [ runReleaseName := 'nightly' ].
	self
		repositoryName: (repository at: #name);
		githubWorkflowRunId: (aRun at: #id);
		releaseName: runReleaseName;
		buildDate: (aRun at: #created_at) asDateAndTime
]

{ #category : 'accessing' }
OPVersion >> fullVersionString [
	(repositoryName isNil or: [ githubWorkflowRunId isNil ])
		ifTrue: [ ^ 'unknown' ].
	^ self repositoryName , '-' , self releaseName
]

{ #category : 'downloading' }
OPVersion >> getOfLatest [

	^ self isRelease
		  ifTrue: [ self getOfLatestRelease ]
		  ifFalse: [ self getOfLatestNightlyBuild ]
]

{ #category : 'downloading' }
OPVersion >> getOfLatestNightlyBuild [
	^ self class ofLastestNightlyOf: self repositoryName
]

{ #category : 'downloading' }
OPVersion >> getOfLatestRelease [
	^ self class ofLastestReleaseOf: self repositoryName
]

{ #category : 'downloading' }
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

{ #category : 'accessing' }
OPVersion >> githubWorkflowRunId [
	^ githubWorkflowRunId
]

{ #category : 'accessing' }
OPVersion >> githubWorkflowRunId: anObject [
	githubWorkflowRunId := anObject
]

{ #category : 'comparing' }
OPVersion >> hash [
	self isRelease ifTrue: [ ^ self releaseName hash ].
	^ self buildDate hash
]

{ #category : 'testing' }
OPVersion >> isMostRecent [
	^ self getOfLatest = self
]

{ #category : 'accessing' }
OPVersion >> isRelease [
	^ self releaseName isNotNil
		and: [ self releaseName matchesRegex: self class semanticVersionRegex ]
]

{ #category : 'accessing' }
OPVersion >> isRepositoryNameKnown [
	^ self repositoryName ~= self class unknownRepositoryName
]

{ #category : 'downloading' }
OPVersion >> needsDownloadInfo [
	^ buildDate isNil
]

{ #category : 'printing' }
OPVersion >> printOn: aStream [

	super printOn: aStream.
	aStream << ' (' << self fullVersionString << ')'
]

{ #category : 'accessing' }
OPVersion >> releaseName [

	releaseName ifNil: [
		self canDownloadInfo ifTrue: [ self downloadInfo ] ].
	^ releaseName ifNil: [ 'unknown' ]
]

{ #category : 'accessing' }
OPVersion >> releaseName: aString [

	releaseName := aString
]

{ #category : 'accessing' }
OPVersion >> repositoryLink [

	^ self isRepositoryNameKnown
		  ifTrue: [ 'https://github.com/OpenPonk/' , self repositoryName ]
		  ifFalse: [ 'https://openponk.org' ]
]

{ #category : 'accessing' }
OPVersion >> repositoryName [

	| activePlugins repositoriesOfBaselines |
	repositoryName ifNotNil: [ ^ repositoryName ].
	repositoriesOfBaselines := {
		                           (#BaselineOfOpenPonkClassEditor
		                            -> #'class-editor').
		                           (#BaselineOfOpenPonkBormEditor
		                            -> #'borm-editor').
		                           (#BaselineOfOpenPonkFsmEditor
		                            -> #'fsm-editor').
		                           (#BaselineOfOpenPonkPetriNets
		                            -> #petrinets).
		                           (#BaselineOfOpenPonkBPMN -> #BPMN).
		                           (#BaselineOfOpenPonkMarkovChains
		                            -> #'markov-chains') }.

	activePlugins := repositoriesOfBaselines
		                 select: [ :each |
		                 Smalltalk hasClassNamed: each key ]
		                 thenCollect: [ :each | each value ].
	^ repositoryName := activePlugins size
	                    >= repositoriesOfBaselines size
		                    ifTrue: [ #plugins ]
		                    ifFalse: [
			                    activePlugins size = 1
				                    ifTrue: [ activePlugins anyOne ]
				                    ifFalse: [ self class unknownRepositoryName ] ]
]

{ #category : 'accessing' }
OPVersion >> repositoryName: aString [
	repositoryName := aString
]

{ #category : 'accessing' }
OPVersion >> repositoryNotationName [

	| notationNames |
	notationNames := { 
		                 (#'class-editor' -> '(Onto)UML').
		                 (#'borm-editor' -> 'BORM').
		                 (#'fsm-editor' -> 'FSM').
		                 (#petrinets -> 'Petri nets').
		                 (#'BPMN' -> 'BPMN').
		                 (#plugins -> 'All plugins') } asDictionary.
	^ notationNames
		  at: self repositoryName
		  ifAbsent: [ self repositoryName ]
]
