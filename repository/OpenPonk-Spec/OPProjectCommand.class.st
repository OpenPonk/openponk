"
Abstract base class for Commander framework commands that operate on the workbench toolbar, managing project-level actions such as saving, opening, or merging projects.
"
Class {
	#name : 'OPProjectCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'workbenchToolbar',
		'projectController',
		'workbench'
	],
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPProjectCommand class >> isAbstract [
	^ self = OPProjectCommand
]

{ #category : 'activation' }
OPProjectCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPWorkbenchActivation
		byRootGroupItemOrder: 1
		for: OPWorkbenchToolbar
]

{ #category : 'execution' }
OPProjectCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	workbenchToolbar := aToolContext.
	projectController := workbenchToolbar projectController.
	workbench := workbenchToolbar workbench
]
