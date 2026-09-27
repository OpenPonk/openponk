Class {
	#name : 'OPProjectStorageTest',
	#superclass : 'TestCase',
	#instVars : [
		'storage'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPProjectStorageTest >> setUp [
	super setUp.
	storage := OPProjectStorage new
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
