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

{ #category : 'testing' }
OPModelTestCommand class >> canBeExecutedInEditor: anEditor [
	"Answers true if the active editor plugin is exactly OPTestPlugin."
	^ anEditor plugin class = OPTestPlugin
]

{ #category : 'activation' }
OPModelTestCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPModelTestCommand >> defaultMenuItemName [
	"Answers the default display name in the menu."
	^ 'Test Model Action'
]

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

{ #category : 'testing' }
OPModelTestCommand >> isExecuted [
	"Answers true if the command has been executed."
	^ executed
]
