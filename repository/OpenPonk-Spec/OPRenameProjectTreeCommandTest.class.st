"
Verifies the execution and model updating of the project tree rename command.
"
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
	self
		assert: command canBeExecuted
		description: 'OPRenameProjectTreeCommand should be executable when OPProjectViewModel is selected'.

	projectTreeStub stub selectedItem willReturn: OPViewModel new.
	self
		deny: command canBeExecuted
		description: 'OPRenameProjectTreeCommand must not be executable on non-project view models'.

	projectTreeStub stub selectedItem willReturn: nil.
	self
		deny: command canBeExecuted
		description: 'OPRenameProjectTreeCommand must not be executable when selection is nil'
]
