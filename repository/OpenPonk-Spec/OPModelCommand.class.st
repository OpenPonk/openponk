"
An abstract root command for model-level operations executed within an OpenPonk editor under the Commander 1 architecture. Provides unified extraction of the active OPEditor from Commander tool contexts.
"
Class {
	#name : 'OPModelCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'editor'
	],
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPModelCommand class >> canBeExecutedInContext: aToolContext [
	"Answers true if the command can be executed in the active tool context."
	| activeEditor |
	self isAbstract ifTrue: [ ^ false ].
	activeEditor := self editorFromContext: aToolContext.
	activeEditor ifNil: [ ^ false ].
	^ self canBeExecutedInEditor: activeEditor
]

{ #category : 'testing' }
OPModelCommand class >> canBeExecutedInEditor: anEditor [
	"Subclasses override this hook to specify activation constraints on the concrete editor or its plugin."
	^ self isAbstract not
]

{ #category : 'accessing' }
OPModelCommand class >> editorFromContext: aToolContextOrEditor [
	"Answers the active OPEditor extracted from a tool context or returns the editor directly."
	(aToolContextOrEditor isKindOf: CmdToolContext)
		ifTrue: [ ^ aToolContextOrEditor tool ].
	^ aToolContextOrEditor
]

{ #category : 'testing' }
OPModelCommand class >> isAbstract [
	"Answers true if this class is the abstract root of model commands."
	^ self = OPModelCommand
]

{ #category : 'accessing' }
OPModelCommand >> diagramController [
	"Answers the diagram controller of the active editor."
	^ self editor diagramController
]

{ #category : 'accessing' }
OPModelCommand >> editor [
	"Answers the focused editor instance."
	^ editor
]

{ #category : 'accessing' }
OPModelCommand >> model [
	"Answers the domain model of the active diagram controller."
	^ self diagramController model
]

{ #category : 'execution' }
OPModelCommand >> prepareFullExecutionInContext: aToolContext [
	"Initializes the command with the concrete editor unwrapped from the tool context."
	super prepareFullExecutionInContext: aToolContext.
	editor := self class editorFromContext: aToolContext
]

{ #category : 'accessing' }
OPModelCommand >> projectController [
	"Answers the project controller managing the active project."
	^ self workbench projectController
]

{ #category : 'accessing' }
OPModelCommand >> workbench [
	"Answers the parent workbench instance from the active editor."
	^ self editor workbench
]
