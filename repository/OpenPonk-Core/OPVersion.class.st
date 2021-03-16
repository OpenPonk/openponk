"
I hold the current version of OpenPonk.
"
Class {
	#name : #OPVersion,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'version',
		'commit',
		'projectName',
		'buildDate',
		'commitDate',
		'runId'
	],
	#classInstVars : [
		'current',
		'latest'
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
	latest := nil
]

{ #category : #'instance creation' }
OPVersion class >> currentWithRunId: anId projectName: aProjectName [
	self
		current:
			(self new
				runId: anId;
				projectName: aProjectName;
				yourself)
]

{ #category : #'instance creation' }
OPVersion class >> fromRunJson: aRun [
	^ self new fromRunJson: aRun
]

{ #category : #accessing }
OPVersion class >> latest [
	current ifNil: [ ^ nil ].
	^ latest ifNil: [ latest := self current getOfLatest ]
]

{ #category : #accessing }
OPVersion class >> resetCurrent [
	<script>
	^ current := self new
]

{ #category : #constants }
OPVersion class >> semanticVersionRegex [
	^ 'v(\d+)\.(\d+)\.(\d+)'
]

{ #category : #comparing }
OPVersion >> < aComparable [
	(self isRelease xor: [ aComparable isRelease ])
		ifTrue: [ ^ false ].
	self version = aComparable version
		ifTrue: [ ^ self buildDate < aComparable buildDate ].
	^ self version < aComparable version
]

{ #category : #comparing }
OPVersion >> = aComparable [
	^ self isRelease = aComparable isRelease
		and: [ self version = aComparable version
				and:
					[ self isRelease or: [ self commit = aComparable commit ] ] ]
]

{ #category : #accessing }
OPVersion >> buildDate [
	buildDate ifNil: [ self updateInfo ].
	^ buildDate
]

{ #category : #accessing }
OPVersion >> buildDate: aDateAndTime [
	buildDate := aDateAndTime
]

{ #category : #accessing }
OPVersion >> commit [
	commit ifNil: [ self updateInfo ].
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

{ #category : #'instance creation' }
OPVersion >> fromRunJson: aRun [
	| runCommit repository runVersion |
	runCommit := aRun at: #head_commit.
	repository := aRun at: #repository.
	runVersion := aRun at: #head_branch.
	runVersion = 'master'
		ifTrue: [ runVersion := 'nightly' ].
	self
		projectName: (repository at: #name);
		runId: (aRun at: #id);
		version: runVersion;
		commit: (runCommit at: #id);
		commitDate: (runCommit at: #timestamp) asDateAndTime asLocal;
		buildDate: (aRun at: #updated_at) asDateAndTime asLocal
]

{ #category : #accessing }
OPVersion >> fullVersion [
	^ String
		streamContents: [ :stream | 
			stream << self projectName << '-' << self version.
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
	| runs run |
	runs := self class getRuns.
	run := runs
		detect: [ :any | 
			(any at: #name) = 'Nightly'
				and: [ (any at: #status) = 'completed'
						and: [ (any at: #conclusion) = 'success' ] ] ].
	^ self class fromRunJson: run
]

{ #category : #downloading }
OPVersion >> getOfLatestRelease [
	| runs run |
	runs := self class getRuns.
	run := runs
		detect: [ :any | 
			(any at: #name) = 'Release'
				and: [ (any at: #status) = 'completed'
						and: [ (any at: #conclusion) = 'success'
								and:
									[ (any at: #head_branch) matchesRegex: self class semanticVersionRegex ] ] ] ].
	^ self class fromRunJson: run
]

{ #category : #downloading }
OPVersion >> getRun [
	^ STONJSON
		fromString: (ZnEasy get: self runsUrl , '/' , self runId asString)
]

{ #category : #downloading }
OPVersion >> getRuns [
	^ (STONJSON fromString: (ZnEasy get: self runsUrl))
		at: #workflow_runs
]

{ #category : #comparing }
OPVersion >> hash [
	self isRelease
		ifFalse: [ ^ self commit hash ].
	^ self version hash
]

{ #category : #testing }
OPVersion >> isMostRecent [
	^ self getOfLatest = self
]

{ #category : #accessing }
OPVersion >> isRelease [
	^ self version matchesRegex: self class semanticVersionRegex
]

{ #category : #accessing }
OPVersion >> projectName [
	^ projectName ifNil: [ 'all-in-one' ]
]

{ #category : #accessing }
OPVersion >> projectName: aString [
	projectName := aString
]

{ #category : #accessing }
OPVersion >> runId [
	^ runId
]

{ #category : #accessing }
OPVersion >> runId: anObject [
	runId := anObject
]

{ #category : #downloading }
OPVersion >> runsUrl [
	^ 'https://api.github.com/repos/openponk/' , self projectName
		, '/actions/runs'
]

{ #category : #downloading }
OPVersion >> updateInfo [
	self runId ifNil: [ ^ self ].
	^ self fromRunJson: self getRun
]

{ #category : #accessing }
OPVersion >> version [
	version ifNil: [ self updateInfo ].
	^ version
]

{ #category : #accessing }
OPVersion >> version: aVersionString [
	version := aVersionString
]
