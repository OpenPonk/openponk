"
I am a base class for workbench toolbar commands.
"
Class {
	#name : #OPWorkbenchCommand,
	#superclass : #CmdCommand,
	#instVars : [
		'workbenchToolbar',
		'projectController',
		'workbench'
	],
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #testing }
OPWorkbenchCommand class >> isAbstract [
	^ self = OPWorkbenchCommand
]

{ #category : #activation }
OPWorkbenchCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byRootGroupItemOrder: 1
		for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPWorkbenchCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	workbenchToolbar := aToolContext.
	projectController := workbenchToolbar projectController.
	workbench := workbenchToolbar workbench
]
