"
Tests project serialization to disk archives (.opp), folder unpacking, and resource extraction.
"
Class {
	#name : 'OPProjectStorageTest',
	#superclass : 'TestCase',
	#instVars : [
		'storage'
	],
	#category : 'OpenPonk-Core-Tests-Models',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Models'
}

{ #category : 'running' }
OPProjectStorageTest >> setUp [
	super setUp.
	storage := OPProjectStorage new
]

{ #category : 'tests' }
OPProjectStorageTest >> testDefaultAndReset [

	| savedDefault freshDefault |
	savedDefault := OPProjectStorage default.
	[
		OPProjectStorage reset.
		freshDefault := OPProjectStorage default.
		self deny: freshDefault identicalTo: savedDefault.
		self assert: freshDefault class identicalTo: OPProjectStorage ] ensure: [
		OPProjectStorage classPool at: #Default put: savedDefault ]
]

{ #category : 'tests' }
OPProjectStorageTest >> testEnsureRemoveDoesNotPurgeOtherUnsavedProjects [
	| projectOne projectTwo |
	projectOne := OPProject named: 'Unsaved Project One'.
	projectTwo := OPProject named: 'Unsaved Project Two'.
	storage add: projectOne.
	storage add: projectTwo.
	self
		assert: (storage projects includes: projectOne)
		description: 'Project One was unexpectedly purged when adding Project Two'
]
