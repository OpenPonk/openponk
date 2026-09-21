Class {
	#name : 'OPCommandDescriptionTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPCommandDescriptionTest >> testCompositeCommandDefaultDescriptionMultipleDifferentCommands [
	| compositeCommand firstCommand secondCommand thirdCommand |
	compositeCommand := OPCompositeCommand new.
	firstCommand := OPCommand new.
	firstCommand description: 'Primary Action'.
	secondCommand := OPCommand new.
	secondCommand description: 'Secondary Action'.
	thirdCommand := OPCommand new.
	thirdCommand description: 'Tertiary Action'.
	compositeCommand add: firstCommand.
	compositeCommand add: secondCommand.
	compositeCommand add: thirdCommand.
	self assert: compositeCommand description equals: 'Primary Action (+2)'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testCompositeCommandDefaultDescriptionMultipleSameCommands [
	| compositeCommand firstCommand secondCommand |
	compositeCommand := OPCompositeCommand new.
	firstCommand := OPCommand new.
	firstCommand description: 'Delete Element'.
	secondCommand := OPCommand new.
	secondCommand description: 'Delete Element'.
	compositeCommand add: firstCommand.
	compositeCommand add: secondCommand.
	self assert: compositeCommand description equals: 'Delete Element (2)'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testCompositeCommandDefaultDescriptionSingleCommand [
	| compositeCommand singleCommand |
	compositeCommand := OPCompositeCommand new.
	singleCommand := OPCommand new.
	singleCommand description: 'Move Element'.
	compositeCommand add: singleCommand.
	self assert: compositeCommand description equals: 'Move Element'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testCompositeCommandDefaultDescriptionWhenEmpty [
	| compositeCommand |
	compositeCommand := OPCompositeCommand new.
	self assert: compositeCommand description equals: 'Empty'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testCompositeCommandExplicitDescriptionOverridesDefault [
	| compositeCommand singleCommand |
	compositeCommand := OPCompositeCommand new.
	singleCommand := OPCommand new.
	singleCommand description: 'Single Action'.
	compositeCommand add: singleCommand.
	compositeCommand description: 'Custom Batch'.
	self assert: compositeCommand description equals: 'Custom Batch'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testCustomDescriptionWhenExplicitlySet [
	| command |
	command := OPCompositeCommand new.
	command description: 'Move 3 elements'.
	self assert: command description equals: 'Move 3 elements'
]

{ #category : 'tests' }
OPCommandDescriptionTest >> testDefaultDescriptionDerivedFromClassName [
	| command |
	command := OPRenameDiagramCommand new.
	self assert: command description equals: 'Rename Diagram'
]
