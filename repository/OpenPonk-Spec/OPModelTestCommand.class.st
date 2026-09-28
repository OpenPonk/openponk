"
A concrete test stub representing a model command used for SUnit verification of the OPModelCommand execution lifecycle.
"
Class {
	#name : 'OPModelTestCommand',
	#superclass : 'OPModelCommand',
	#instVars : [
		'executed'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'execution' }
OPModelTestCommand >> execute [
	"Executes the test command."
	executed := true
]

{ #category : 'initialization' }
OPModelTestCommand >> initialize [
	super initialize.
	executed := false
]

{ #category : 'accessing' }
OPModelTestCommand >> isExecuted [
	"Answers true if the command has been executed."
	^ executed
]
