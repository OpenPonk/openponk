Class {
	#name : 'OPRenameProjectTreeCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPRenameProjectTreeCommandTest >> testCanBeExecutedOnlyOnProjectViewModel [
	| command projectTreeStub |
	command := OPRenameProjectTreeCommand new.
	projectTreeStub := Mock new.
	command context: projectTreeStub.

	projectTreeStub stub selectedItem willReturn: OPProjectViewModel new.
	self assert: command canBeExecuted.

	projectTreeStub stub selectedItem willReturn: OPViewModel new.
	self deny: command canBeExecuted.

	projectTreeStub stub selectedItem willReturn: nil.
	self deny: command canBeExecuted
]
