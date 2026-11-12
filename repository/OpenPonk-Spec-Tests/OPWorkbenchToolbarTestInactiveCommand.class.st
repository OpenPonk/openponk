Class {
	#name : 'OPWorkbenchToolbarTestInactiveCommand',
	#superclass : 'OPModelCommand',
	#category : 'OpenPonk-Spec-Tests-Commands-Workbench',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPWorkbenchToolbarTestInactiveCommand class >> canBeExecutedInEditor: anEditor [
	"Never executable to test omission of inactive groups."
	^ false
]

{ #category : 'activation' }
OPWorkbenchToolbarTestInactiveCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPWorkbenchToolbarTestNonInlinedMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPWorkbenchToolbarTestInactiveCommand >> defaultMenuItemName [
	"Answers the command item name."
	^ 'Inactive Action'
]

{ #category : 'execution' }
OPWorkbenchToolbarTestInactiveCommand >> execute [
	"Does nothing for testing."
]
