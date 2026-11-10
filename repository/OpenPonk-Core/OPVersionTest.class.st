"
Tests semantic version parsing, comparison operators, and string serialization for OpenPonk version descriptors.
"
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
	| v1 v2 v3 |
	v1 := OPVersion new buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	v2 := OPVersion new buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	v3 := OPVersion new buildDate: (DateAndTime fromString: '2019-03-02T15:00:00.000000+01:00').
	self assert: v1 equals: v2.
	self assert: v1 < v3 description: 'Earlier build date should be ordered before later build date'
]

{ #category : 'tests' }
OPVersionTest >> testComparisonsEqualityPrintingAndRepositoryInference [
	| relA relB relSameTagLater nonRelA nonRelB emptyVer |
	relA := OPVersion new
		repositoryName: 'fsm-editor';
		githubWorkflowRunId: 10;
		releaseName: 'v1.2.0';
		buildDate: (DateAndTime fromString: '2026-01-01T10:00:00Z').
	relSameTagLater := OPVersion new
		repositoryName: 'fsm-editor';
		githubWorkflowRunId: 11;
		releaseName: 'v1.2.0';
		buildDate: (DateAndTime fromString: '2026-01-02T10:00:00Z').
	relB := OPVersion new
		repositoryName: 'fsm-editor';
		githubWorkflowRunId: 12;
		releaseName: 'v1.3.0';
		buildDate: (DateAndTime fromString: '2026-01-03T10:00:00Z').
	nonRelA := OPVersion new
		releaseName: 'alpha';
		buildDate: (DateAndTime fromString: '2026-01-01T10:00:00Z').
	nonRelB := OPVersion new
		releaseName: 'beta';
		buildDate: (DateAndTime fromString: '2026-01-02T10:00:00Z').

	self deny: (relA = 'not-a-version') description: 'Version should not equal an object of different species'.
	self assert: relA equals: relSameTagLater.
	self assert: relA hash equals: relSameTagLater hash.
	self deny: (nonRelA = nonRelB) description: 'Non-release versions with different names should not be equal'.
	self assert: (relA < relSameTagLater) description: 'Same release tag should compare by buildDate'.
	self deny: (relA < nonRelA) description: 'Comparing release with non-release via < should return false'.
	self assert: (nonRelA < nonRelB) description: 'Two non-releases with different names should compare lexicographically'.
	self assert: (relB min: relA max: relSameTagLater) equals: relSameTagLater.
	self assert: (OPVersion isVersionTag: 'v1.2.0' greaterThanOrEqualTo: '1.2') description: 'v1.2.0 should be >= 1.2'.
	self deny: (OPVersion isVersionTag: 'v1.2' greaterThanOrEqualTo: 'v1.2.1') description: 'v1.2 should not be >= v1.2.1'.
	self assert: (relA printString includesSubstring: '(fsm-editor-v1.2.0)') description: 'printString should include fullVersionString in parentheses'.

	emptyVer := OPVersion new.
	self assert: emptyVer downloadInfo identicalTo: emptyVer.
	self assert: emptyVer buildDate isNil description: 'buildDate should remain nil when downloadInfo cannot run'.
	self assert: emptyVer releaseName equals: 'unknown'.
	self assert: emptyVer repositoryName isNotEmpty description: 'repositoryName should infer a non-empty name from loaded plugins'
]

{ #category : 'tests' }
OPVersionTest >> testCurrentLatestAndRunsCacheOfflineQueries [
	| release1 release2 nightly prereleaseFallback currentRelease currentNightly latestRelease latestNightly fallbackVersion |
	[
		OPVersion reset.
		self assert: OPVersion latest isNil description: 'Latest should be nil when current is not initialized'.
		self assert: OPVersion current isNotNil description: 'OPVersion current should lazily create an instance'.
		release1 := Dictionary newFrom: {
			#id -> 10.
			#tag_name -> 'v1.2.0'.
			#name -> 'Release 1.2.0'.
			#prerelease -> false.
			#draft -> false.
			#published_at -> '2026-08-01T10:00:00Z' }.
		release2 := Dictionary newFrom: {
			#id -> 20.
			#tag_name -> 'v1.10.0'.
			#name -> 'Release 1.10.0'.
			#prerelease -> false.
			#draft -> false.
			#published_at -> '2026-09-01T10:00:00Z' }.
		nightly := Dictionary newFrom: {
			#id -> 30.
			#tag_name -> 'nightly'.
			#name -> 'nightly-2026-09-05T12:30:00Z'.
			#prerelease -> true.
			#draft -> false.
			#published_at -> '2026-09-04T00:00:00Z' }.
		prereleaseFallback := Dictionary newFrom: {
			#id -> 40.
			#tag_name -> 'rc1'.
			#name -> 'nightly-not-a-date'.
			#prerelease -> true.
			#draft -> false.
			#published_at -> '2026-09-06T08:00:00Z' }.
		OPVersion runsCache at: 'mock-repo-releases' put: { release1 . release2 . nightly }.
		OPVersion runsCache at: 'empty-repo-releases' put: #().
		OPVersion runsCache at: 'fallback-repo-releases' put: { prereleaseFallback }.

		self assert: (OPVersion ofLastestReleaseOf: 'empty-repo') isNil description: 'Empty releases should return nil for latest release'.
		self assert: (OPVersion ofLastestNightlyOf: 'empty-repo') isNil description: 'Empty releases should return nil for latest nightly'.

		fallbackVersion := OPVersion ofLastestNightlyOf: 'fallback-repo'.
		self assert: fallbackVersion releaseName equals: 'rc1'.
		self assert: fallbackVersion buildDate equals: (DateAndTime fromString: '2026-09-06T08:00:00Z') asLocal.

		currentRelease := OPVersion new
			repositoryName: 'mock-repo';
			releaseName: 'v1.0.0';
			githubWorkflowRunId: 1;
			buildDate: (DateAndTime fromString: '2026-01-01T00:00:00Z');
			yourself.
		OPVersion current: currentRelease.
		self assert: OPVersion current identicalTo: currentRelease.
		latestRelease := OPVersion latest.
		self assert: latestRelease releaseName equals: 'v1.10.0'.
		self assert: latestRelease repositoryName equals: 'mock-repo'.

		currentNightly := OPVersion new
			repositoryName: 'mock-repo';
			releaseName: 'nightly';
			githubWorkflowRunId: 2;
			buildDate: (DateAndTime fromString: '2026-01-01T00:00:00Z');
			yourself.
		OPVersion current: currentNightly.
		latestNightly := OPVersion latest.
		self assert: latestNightly releaseName equals: 'nightly'.
		self assert: latestNightly buildDate equals: (DateAndTime fromString: '2026-09-05T12:30:00Z')
	] ensure: [ OPVersion reset ]
]

{ #category : 'tests' }
OPVersionTest >> testEqualityAndHash [

	| v1 v2 |
	v1 := OPVersion new buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	v2 := OPVersion new buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	self assert: v1 equals: v2.
	self assert: v1 hash equals: v2 hash
]

{ #category : 'tests' }
OPVersionTest >> testFromReleaseJson [
	| v |
	v := OPVersion fromReleaseJson: self sampleReleaseJson repositoryName: 'borm-editor'.
	self assert: v repositoryName equals: 'borm-editor'.
	self assert: v releaseName equals: 'v2.1.0'.
	self assert: v isRelease description: 'Semantic version tag v2.1.0 should be recognized as release'.
	self deny: v needsDownloadInfo description: 'Version created from release JSON with published_at should not need download info'.
	self assert: v buildDate equals: (DateAndTime fromString: '2026-09-01T10:05:00Z') asLocal.
	self assert: v fullVersionString equals: 'borm-editor-v2.1.0'
]

{ #category : 'tests' }
OPVersionTest >> testFromRunJsonMasterBranchMapsToNightly [
	| json version |
	json := self sampleRunJson.
	json at: #head_branch put: 'master'.
	version := OPVersion fromRunJson: json.
	self assert: version releaseName equals: 'nightly'.
	self deny: version isRelease description: 'Nightly build should not be marked as release'
]

{ #category : 'tests' }
OPVersionTest >> testFromRunJsonRelease [
	| version |
	version := OPVersion fromRunJson: self sampleRunJson.
	self assert: version repositoryName equals: 'borm-editor'.
	self assert: version releaseName equals: 'v2.1.0'.
	self assert: version githubWorkflowRunId equals: 987654.
	self assert: version isRelease description: 'Run JSON on v2.1.0 branch should be recognized as release'.
	self deny: version needsDownloadInfo description: 'Run JSON with created_at should not need download info'.
	self assert: version buildDate equals: (DateAndTime fromString: '2026-09-01T10:05:00Z') asLocal
]

{ #category : 'tests' }
OPVersionTest >> testFullVersionString [

	| version |
	version := OPVersion new.
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
	version := OPVersion new.
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
	version := OPVersion new.
	version releaseName: 'v1.0.0'.
	self assert: version isRelease description: 'v1.0.0 should be a release'.
	version releaseName: 'v0.12.3'.
	self assert: version isRelease description: 'v0.12.3 should be a release'.
	version releaseName: '1.0.0'.
	self deny: version isRelease description: 'Tag without leading v should not be a release'.
	version releaseName: 'nightly'.
	self deny: version isRelease description: 'nightly should not be a release'.
	version releaseName: nil.
	self deny: version isRelease description: 'nil releaseName should not be a release'
]

{ #category : 'tests' }
OPVersionTest >> testNeedsAndCanDownloadInfo [
	| version |
	version := OPVersion new.
	self assert: version needsDownloadInfo description: 'Fresh version without buildDate needs download info'.
	self deny: version canDownloadInfo description: 'Version without workflow run ID cannot download info'.
	version githubWorkflowRunId: 123.
	version repositoryName: 'borm-editor'.
	self assert: version canDownloadInfo description: 'Version with workflow run ID and repository name can download info'.
	version buildDate: DateAndTime now.
	self deny: version needsDownloadInfo description: 'Version with buildDate no longer needs download info'
]

{ #category : 'tests' }
OPVersionTest >> testRepositoryLinkAndKnownStatus [
	| version |
	version := OPVersion new.
	version repositoryName: 'class-editor'.
	self assert: version isRepositoryNameKnown description: 'Explicit repository name should be known'.
	self assert: version repositoryLink equals: 'https://github.com/OpenPonk/class-editor'.
	version repositoryName: OPVersion unknownRepositoryName.
	self deny: version isRepositoryNameKnown description: 'Unknown repository constant should not be reported as known'.
	self assert: version repositoryLink equals: 'https://openponk.org'
]

{ #category : 'tests' }
OPVersionTest >> testSemverComparison [
	| v1 v2 |
	v1 := OPVersion new
		releaseName: 'v1.2.3';
		buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	v2 := OPVersion new
		releaseName: 'v1.2.4';
		buildDate: (DateAndTime fromString: '2019-03-01T15:00:00.000000+01:00').
	self assert: v1 < v2 description: 'v1.2.3 should be ordered before v1.2.4'
]
