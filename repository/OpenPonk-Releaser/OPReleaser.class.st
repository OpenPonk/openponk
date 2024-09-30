Class {
	#name : 'OPReleaser',
	#superclass : 'Object',
	#instVars : [
		'repositoryName',
		'versionArray',
		'nightlyBranchName',
		'gitCommands',
		'repo',
		'repoModel',
		'remoteBranch',
		'releaseBranch',
		'minorTag',
		'majorTag'
	],
	#category : 'OpenPonk-Releaser',
	#package : 'OpenPonk-Releaser'
}

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepositories: aCollectionOfString asVersion: anArrayOfNumbers [

	aCollectionOfString do: [ :each |
		self releaseRepository: each asVersion: anArrayOfNumbers ]
]

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepository: aName asVersion: anArrayOfNumbers [

	^ self new
		  repositoryName: aName;
		  versionArray: anArrayOfNumbers;
		  inspectGitCommands
]

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepository: aName branch: aString asVersion: anArrayOfNumbers [

	^ self new
		  repositoryName: aName;
		  branch: aString;
		  versionArray: anArrayOfNumbers;
		  inspectGitCommands
]

{ #category : 'instance creation' }
OPReleaser >> branch: aBranchName [

	nightlyBranchName := aBranchName
]

{ #category : 'actions' }
OPReleaser >> checkoutLocalReleaseBranch [

	| releaseBranchModel |
	"grab local release_base"
	releaseBranch := repo allBranches detect: [ :b |
		                 b name = 'release_base' ].
	releaseBranchModel := IceTipBranchModel
		                      repositoryModel: repoModel
		                      on: releaseBranch.

	"perform checkout via GUI"
	releaseBranchModel previewCheckout.

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	self confirmToContinue:
		'If any window opened, handle checkout release_base, then proceed'
]

{ #category : 'actions' }
OPReleaser >> checkoutRemoteReleaseBranch [
	"grab remote branch"

	| remoteBranchModel |
	remoteBranch := repo allBranches detect: [ :b |
		                b name = 'origin/release_base' ].
	remoteBranchModel := IceTipBranchModel
		                     repositoryModel: repoModel
		                     on: remoteBranch.

	"if not available locally, yet, checkout remote"
	repo allBranches
		detect: [ :b | b name = 'release_base' ]
		ifNone: [ "perform checkout via GUI"
		remoteBranchModel previewCheckout ].

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	self confirmToContinue:
		'If any window opened, handle checkout release_base, then proceed'
]

{ #category : 'actions' }
OPReleaser >> commit [

	| commitBrowser |
	
	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	"------- MAKE NECESSARY CHANGES BY HAND IN THE BASELINE/CODE -------"
	
	self confirmToContinue:
		'Handle open merge window, make neccessary changes in the baseline, then proceed'.

	"commit via GUI"
	commitBrowser := IceTipCommitBrowser onRepository: repo.
	commitBrowser commentPanel commentText text: 'Updated baseline'.
	commitBrowser open.

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	self confirmToContinue: 'Handle commit window, then proceed'
]

{ #category : 'utilities' }
OPReleaser >> confirmToContinue: aText [

	(UIManager default proceed: aText) ifFalse: [
		self notify: 'Release script cancelled' ]
]

{ #category : 'actions' }
OPReleaser >> createRelease [

	self getRepo.
	self checkoutRemoteReleaseBranch.
	self checkoutLocalReleaseBranch.
	self pullReleaseBranchAndMerge.
	self commit.
	self push.
	self createTags.
	^ self getGitCommands
]

{ #category : 'actions' }
OPReleaser >> createTags [
	"preparing tags"

	| commitToTag tags verToTag patchTag |
	commitToTag := releaseBranch commit.

	tags := repo tags.

	"conversion util"
	verToTag := [ :t | 'v' , (t joinUsing: '.') ].

	"create patch tag v1.2.3"
	patchTag := verToTag value: versionArray.
	tags
		detect: [ :t | t name = patchTag ]
		ifFound: [ :t |
		self error: 'Patch tag ' , patchTag , ' already exists' ].
	commitToTag createTag: patchTag.

	"create minor tag v1.2.x"
	minorTag := verToTag value: (versionArray first: 2) , { 'x' }.
	tags
		detect: [ :t | t name = minorTag ]
		ifFound: [ :t | repo removeTag: t ].
	commitToTag createTag: minorTag.

	"create major tag v1.x"
	majorTag := verToTag value: {
			            versionArray first.
			            'x' }.
	tags
		detect: [ :t | t name = majorTag ]
		ifFound: [ :t | repo removeTag: t ].
	commitToTag createTag: majorTag
]

{ #category : 'actions' }
OPReleaser >> getGitCommands [

	^ gitCommands := String streamContents: [ :s |
		                 s << 'pushd "' << repo location fullName << '"'.
		                 s lf.
		                 s << 'git push --delete origin ' << minorTag.
		                 s lf.
		                 s << 'git push --delete origin ' << majorTag.
		                 s lf.
		                 s << 'git push --tags'.
		                 s lf ]
]

{ #category : 'actions' }
OPReleaser >> getRepo [

	repo := IceRepository registry detect: [ :each |
		        each name = repositoryName ].
	repoModel := IceTipRepositoryModel on: repo
]

{ #category : 'initialization' }
OPReleaser >> initialize [

	super initialize.
	nightlyBranchName := 'master'
]

{ #category : 'actions' }
OPReleaser >> inspectGitCommands [

	^ (gitCommands ifNil: [ self createRelease ])
		  inspect;
		  yourself
]

{ #category : 'actions' }
OPReleaser >> pullReleaseBranchAndMerge [

	| masterBranch masterBranchModel |
	
	"pull to ensure it is up to date"
	releaseBranch pullFrom: remoteBranch remote.

	"get master branch"
	masterBranch := repo allBranches detect: [ :b | b name = nightlyBranchName ].
	masterBranchModel := IceTipBranchModel
		                     repositoryModel: repoModel
		                     on: masterBranch.

	"merge master branch into the currently checked-out (which is the release branch)"
	masterBranchModel previewMerge: IceTipMergeType direct
]

{ #category : 'actions' }
OPReleaser >> push [
	"push the changes to GitHub"

	releaseBranch pushTo: remoteBranch remote
]

{ #category : 'accessing' }
OPReleaser >> repositoryName: aString [

	repositoryName := aString
]

{ #category : 'versions' }
OPReleaser >> versionArray: aCollection [

	versionArray := aCollection
]
