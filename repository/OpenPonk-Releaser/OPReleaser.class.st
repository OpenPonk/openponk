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
		'majorTag',
		'job'
	],
	#category : 'OpenPonk-Releaser',
	#package : 'OpenPonk-Releaser'
}

{ #category : 'as yet unclassified' }
OPReleaser class >> defaultBranch [

	^ 'master'
]

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepositories: aCollectionOfString asVersion: anArrayOfNumbers [

	[
	aCollectionOfString do: [ :each |
		self new
			repositoryName: each;
			version: anArrayOfNumbers;
			createGitCommands ] ]
		forkAt: Processor userBackgroundPriority
		named: 'OPReleaser'
]

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepository: aName asVersion: anArrayOfNumbers [

	self
		releaseRepository: aName
		branch: self defaultBranch
		asVersion: anArrayOfNumbers
]

{ #category : 'as yet unclassified' }
OPReleaser class >> releaseRepository: aName branch: aString asVersion: anArrayOfNumbers [

	[
	self new
		repositoryName: aName;
		branch: aString;
		version: anArrayOfNumbers;
		createGitCommands ]
		forkAt: Processor userBackgroundPriority
		named: 'OPReleaser'
]

{ #category : 'instance creation' }
OPReleaser >> branch: aBranchName [

	nightlyBranchName := aBranchName
]

{ #category : 'actions' }
OPReleaser >> checkoutLocalReleaseBranch [

	| releaseBranchModel checkoutBrowser |
	"grab local release_base"
	job title: 'Looking for release_base'.
	releaseBranch := repo allBranches detect: [ :b |
		                 b name = 'release_base' ].
	releaseBranchModel := IceTipBranchModel
		                      repositoryModel: repoModel
		                      on: releaseBranch.

	"perform checkout via GUI"
	checkoutBrowser := (IceTipCheckoutPreviewBrowser onBranch: releaseBranchModel).	
	checkoutBrowser diffPanel model diff isEmpty ifTrue: [ ^ self ].
	checkoutBrowser open.

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	job title: 'Waiting: Confirm checkout release_base'.
	self waitForWindows: [
		IceTipCheckoutPreviewBrowser allInstances select: [ :each |
			each hasWindow and: [ each window isOpen ] ] ]
]

{ #category : 'actions' }
OPReleaser >> checkoutRemoteReleaseBranch [
	"grab remote branch"

	| remoteBranchModel checkoutBrowser |
	job title: 'Looking for origin/release_base'.
	remoteBranch := repo allBranches detect: [ :b |
		                b name = 'origin/release_base' ].
	remoteBranchModel := IceTipBranchModel
		                     repositoryModel: repoModel
		                     on: remoteBranch.

	"if not available locally, yet, checkout remote"
	repo allBranches
		detect: [ :b | b name = 'release_base' ]
		ifFound: [ ^ self ].

	checkoutBrowser := IceTipCheckoutPreviewBrowser onBranch:
		                   remoteBranchModel.
	checkoutBrowser diffPanel model diff isEmpty ifTrue: [ ^ self ].
	checkoutBrowser open.

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	job title: 'Waiting: Confirm checkout release_base'.
	self waitForWindows: [
		IceTipCheckoutPreviewBrowser allInstances select: [ :each |
			each hasWindow and: [ each window isOpen ] ] ]
]

{ #category : 'actions' }
OPReleaser >> commit [

	| commitBrowser |
	job title:
		'Waiting: Change baseline if neccessary, then confirm dialog'.
	self confirmToContinue:
		'Change baseline if neccessary, then click OK'.

	"commit via GUI"

	job title: 'Preparing commit'.
	commitBrowser := IceTipCommitBrowser onRepository: repo.
	commitBrowser diffPanel model isEmpty ifTrue: [ ^ self ].
	commitBrowser commentPanel commentText text: 'Updated baseline'.
	commitBrowser open.

	"------------- HANDLE OPEN WINDOWS IF ANY ----------------"
	job title: 'Waiting: Confirm commit'.
	self waitForWindows: [
		IceTipCommitBrowser allInstances select: [ :each |
			each hasWindow and: [ each window isOpen ] ] ]
]

{ #category : 'utilities' }
OPReleaser >> confirmToContinue: aText [

	(UIManager default proceed: aText) ifFalse: [
		self notify: 'Release script cancelled' ]
]

{ #category : 'actions' }
OPReleaser >> createGitCommands [

	[
	job := [ self createGitCommandsInJob ] asJob.
	job run ] asJob
		title: 'Creating release of ' , repositoryName asString;
		run
]

{ #category : 'actions' }
OPReleaser >> createGitCommandsInJob [

	job title: 'Creating release'.
	gitCommands ifNil: [ self createRelease ].
	job title: 'Copying git commands to clipboard'.
	Clipboard
		clipboardText: gitCommands
		informing: 'Git commands copied to clipboard - run them in terminal'.
	gitCommands inspect.
	job title: 'Waiting: Run git commands and close the inspector'.
	self waitForWindows: [
		StInspectorPresenter allInstances select: [ :each |
			each hasWindow and: [
				each window isOpen and: [
					each model inspectedObject isString and: [
						each model inspectedObject beginsWith: 'pushd "' ] ] ] ] ]
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
	job title: 'Creating tags'.
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

	job title: 'Generating tag git push commands'.
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

	job title: 'Finding local repository'.
	repo := IceRepository registry detect: [ :each |
		        each name = repositoryName ].
	repoModel := IceTipRepositoryModel on: repo
]

{ #category : 'initialization' }
OPReleaser >> initialize [

	super initialize.
	nightlyBranchName := self class defaultBranch.
	job := Job new
]

{ #category : 'actions' }
OPReleaser >> pullReleaseBranchAndMerge [

	| masterBranch masterBranchModel mergeBrowser |
	"pull to ensure it is up to date"
	job title: 'Pulling release_base'.
	releaseBranch pullFrom: remoteBranch remote.

	"get master branch"
	job title: 'Looking for ' , nightlyBranchName.
	masterBranch := repo allBranches detect: [ :b |
		                b name = nightlyBranchName ].
	masterBranchModel := IceTipBranchModel
		                     repositoryModel: repoModel
		                     on: masterBranch.

	"merge master branch into the currently checked-out (which is the release branch)"
	job title:
		'Preparing merge of ' , nightlyBranchName , ' into release_base'.
	mergeBrowser := IceTipMergePreviewBrowser onBranch: masterBranchModel.
	mergeBrowser mergeType: IceTipMergeType direct.
	mergeBrowser diffPanel model diff isEmpty ifTrue: [ ^ self ].
	mergeBrowser open.

	job title: 'Waiting: Confirm merge of ' , nightlyBranchName
		, ' into release_base'.
	self waitForWindows: [
		IceTipMergePreviewBrowser allInstances select: [ :each |
			each hasWindow and: [ each window isOpen ] ] ]
]

{ #category : 'actions' }
OPReleaser >> push [
	"push the changes to GitHub"

	job title: 'Pushing'.
	releaseBranch pushTo: remoteBranch remote
]

{ #category : 'accessing' }
OPReleaser >> repositoryName: aString [

	repositoryName := aString
]

{ #category : 'versions' }
OPReleaser >> version: aCollection [

	aCollection isString ifTrue: [
		^ self versionArrayFromString: aCollection ].
	self versionArrayFromCollection: aCollection
]

{ #category : 'versions' }
OPReleaser >> versionArrayFromCollection: aCollection [

	self
		assert: aCollection size = 3
		description: [ aCollection , ' should be of size 3' ].
	versionArray := aCollection collect: [ :each | each asInteger ].
	self assert: (versionArray allSatisfy: [ :each |
			 each isInteger and: [ each positive ] ])
]

{ #category : 'versions' }
OPReleaser >> versionArrayFromString: aString [

	self versionArrayFromCollection: (aString splitOn: $.)
]

{ #category : 'as yet unclassified' }
OPReleaser >> waitForWindows: aBlock [

	250 milliseconds wait.
	[ aBlock value isNotEmpty ] whileTrue: [ 250 milliseconds wait ]
]
