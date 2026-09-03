Class {
	#name : 'OPVersionTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'fixtures' }
OPVersionTest >> sampleReleaseJson [
	| release |
	release := Dictionary new.
	release at: #id put: 123456.
	release at: #tag_name put: 'v2.1.0'.
	release at: #published_at put: '2026-09-01T10:05:00Z'.
	release at: #created_at put: '2026-09-01T10:00:00Z'.
	^ release
]

{ #category : 'fixtures' }
OPVersionTest >> sampleRunJson [
	| commit repo run |
	commit := Dictionary new.
	commit at: #id put: 'abc123456789'.
	commit at: #timestamp put: '2026-09-01T10:00:00Z'.
	repo := Dictionary new.
	repo at: #name put: 'borm-editor'.
	run := Dictionary new.
	run at: #id put: 987654.
	run at: #head_branch put: 'v2.1.0'.
	run at: #created_at put: '2026-09-01T10:05:00Z'.
	run at: #repository put: repo.
	run at: #head_commit put: commit.
	^ run
]

{ #category : 'tests' }
OPVersionTest >> testComparison [
	| v1 v2 n1 n2 |
	v1 := (Smalltalk classNamed: #OPVersion) new
		releaseName: 'v1.0.0';
		buildDate: '2026-01-01' asDateAndTime.
	v2 := (Smalltalk classNamed: #OPVersion) new
		releaseName: 'v2.0.0';
		buildDate: '2026-02-01' asDateAndTime.
	self assert: v1 < v2.
	self deny: v2 < v1.
	n1 := (Smalltalk classNamed: #OPVersion) new
		releaseName: 'nightly';
		buildDate: '2026-01-01' asDateAndTime.
	n2 := (Smalltalk classNamed: #OPVersion) new
		releaseName: 'nightly';
		buildDate: '2026-01-02' asDateAndTime.
	self assert: n1 < n2.
	self deny: n2 < n1.
	self deny: v1 < n1.
	self deny: n1 < v1
]

{ #category : 'tests' }
OPVersionTest >> testEqualityAndHash [

	| v1 v2 v3 n1 n2 n3 |
	v1 := (Smalltalk classNamed: #OPVersion) new releaseName: 'v1.0.0'.
	v2 := (Smalltalk classNamed: #OPVersion) new releaseName: 'v1.0.0'.
	v3 := (Smalltalk classNamed: #OPVersion) new releaseName: 'v2.0.0'.
	self assert: v1 equals: v2.
	self assert: v1 hash equals: v2 hash.
	self deny: v1 equals: v3.
	n1 := (Smalltalk classNamed: #OPVersion) new
		      releaseName: 'nightly';
		      buildDate: '2026-01-01T10:00:00' asDateAndTime.
	n2 := (Smalltalk classNamed: #OPVersion) new
		      releaseName: 'nightly';
		      buildDate: '2026-01-01T10:00:00' asDateAndTime.
	n3 := (Smalltalk classNamed: #OPVersion) new
		      releaseName: 'nightly';
		      buildDate: '2026-01-02T10:00:00' asDateAndTime.
	self assert: n1 equals: n2.
	self assert: n1 hash equals: n2 hash.
	self deny: n1 equals: n3
]

{ #category : 'tests' }
OPVersionTest >> testFromReleaseJson [
	| v |
	v := (Smalltalk classNamed: #OPVersion)
		     fromReleaseJson: self sampleReleaseJson
		     repositoryName: 'borm-editor'.
	self assert: v repositoryName equals: 'borm-editor'.
	self assert: v releaseName equals: 'v2.1.0'.
	self assert: v isRelease.
	self deny: v needsDownloadInfo.
	self assert: v buildDate equals: '2026-09-01T10:05:00Z' asDateAndTime asLocal.
	self assert: v fullVersionString equals: 'borm-editor-v2.1.0'
]

{ #category : 'tests' }
OPVersionTest >> testFromRunJsonMasterBranchMapsToNightly [
	| json version |
	json := self sampleRunJson.
	json at: #head_branch put: 'master'.
	version := (Smalltalk classNamed: #OPVersion) fromRunJson: json.

	self assert: version releaseName equals: 'nightly'.
	self deny: version isRelease
]

{ #category : 'tests' }
OPVersionTest >> testFromRunJsonRelease [
	| version |
	version := (Smalltalk classNamed: #OPVersion) fromRunJson: self sampleRunJson.
	self assert: version repositoryName equals: 'borm-editor'.
	self assert: version releaseName equals: 'v2.1.0'.
	self assert: version githubWorkflowRunId equals: 987654.
	self assert: version isRelease.
	self deny: version needsDownloadInfo.
	self assert: version buildDate equals: '2026-09-01T10:05:00Z' asDateAndTime asLocal
]

{ #category : 'tests' }
OPVersionTest >> testFullVersionString [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.
	version repositoryName: 'fsm-editor'.
	version githubWorkflowRunId: 100.
	version releaseName: 'v1.0.0'.
	self assert: version fullVersionString equals: 'fsm-editor-v1.0.0'.
	version releaseName: 'nightly'.
	self assert: version fullVersionString equals: 'fsm-editor-nightly'
]

{ #category : 'tests' }
OPVersionTest >> testFullVersionStringUnknownWhenIncomplete [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.
	self assert: version fullVersionString equals: 'unknown'.

	version repositoryName: 'fsm-editor'.
	self assert: version fullVersionString equals: 'unknown'.

	version githubWorkflowRunId: 100.
	version releaseName: 'v1.0.0'.
	self assert: version fullVersionString equals: 'fsm-editor-v1.0.0'
]

{ #category : 'tests' }
OPVersionTest >> testIsRelease [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.

	version releaseName: 'v1.0.0'.
	self assert: version isRelease.

	version releaseName: 'v0.12.3'.
	self assert: version isRelease.

	version releaseName: '1.0.0'.
	self deny: version isRelease.

	version releaseName: 'nightly'.
	self deny: version isRelease.

	version releaseName: nil.
	self deny: version isRelease
]

{ #category : 'tests' }
OPVersionTest >> testNeedsAndCanDownloadInfo [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.
	self assert: version needsDownloadInfo.
	self deny: version canDownloadInfo.
	version githubWorkflowRunId: 123.
	version repositoryName: 'borm-editor'.
	self assert: version canDownloadInfo.
	version buildDate: DateAndTime now.
	self deny: version needsDownloadInfo
]

{ #category : 'tests' }
OPVersionTest >> testRepositoryLinkAndKnownStatus [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.

	version repositoryName: 'class-editor'.
	self assert: version isRepositoryNameKnown.
	self assert: version repositoryLink equals: 'https://github.com/OpenPonk/class-editor'.

	version repositoryName: (Smalltalk classNamed: #OPVersion) unknownRepositoryName.
	self deny: version isRepositoryNameKnown.
	self assert: version repositoryLink equals: 'https://openponk.org'
]

{ #category : 'tests' }
OPVersionTest >> testRepositoryNotationName [
	| version |
	version := (Smalltalk classNamed: #OPVersion) new.

	version repositoryName: 'class-editor' asSymbol.
	self assert: version repositoryNotationName equals: '(Onto)UML'.

	version repositoryName: 'borm-editor' asSymbol.
	self assert: version repositoryNotationName equals: 'BORM'.

	version repositoryName: 'fsm-editor' asSymbol.
	self assert: version repositoryNotationName equals: 'FSM'.

	version repositoryName: 'petrinets' asSymbol.
	self assert: version repositoryNotationName equals: 'Petri nets'.

	version repositoryName: 'BPMN' asSymbol.
	self assert: version repositoryNotationName equals: 'BPMN'.

	version repositoryName: 'plugins' asSymbol.
	self assert: version repositoryNotationName equals: 'All plugins'.

	version repositoryName: 'unknown-notation'.
	self assert: version repositoryNotationName equals: 'unknown-notation'
]

{ #category : 'tests' }
OPVersionTest >> testSemverComparison [
	| v1 v2 |
	v1 := (Smalltalk classNamed: #OPVersion) new
		      releaseName: 'v1.2.0';
		      buildDate: '2026-01-01' asDateAndTime.
	v2 := (Smalltalk classNamed: #OPVersion) new
		      releaseName: 'v1.10.0';
		      buildDate: '2026-01-01' asDateAndTime.
	self assert: v1 < v2.
	self deny: v2 < v1
]
