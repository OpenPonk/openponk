"
I am a base class for workbench toolbar commands.
"
Class {
	#name : #OPProjectCommand,
	#superclass : #CmdCommand,
	#instVars : [
		'workbenchToolbar',
		'projectController',
		'workbench'
	],
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #testing }
OPProjectCommand class >> isAbstract [
	^ self = OPProjectCommand
]

{ #category : #activation }
OPProjectCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byRootGroupItemOrder: 1
		for: OPWorkbenchToolbar
]

{ #category : #accessing }
OPProjectCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	workbenchToolbar := aToolContext.
	projectController := workbenchToolbar projectController.
	workbench := workbenchToolbar workbench
]
