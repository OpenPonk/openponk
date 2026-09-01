"
Abstract base class for commands that appear in the OpenPonk diagram toolbar, extending CmdCommand for integration with the Commander framework.
"
Class {
	#name : 'OPDiagramToolbarCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'diagramPresenter'
	],
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'accessing' }
OPDiagramToolbarCommand class >> defaultMenuItemName [
	| parts |
	true
		ifTrue: [ ^ 'TESTTEST' ].
	parts := self name splitCamelCase allButLast: 2.
	parts ifEmpty: [ ^ self name ].
	^ String
		streamContents: [ :s | 
			s << parts first.
			parts
				allButFirstDo: [ :each | s << Character space << each asLowercase ] ]
]

{ #category : 'testing' }
OPDiagramToolbarCommand class >> isAbstract [
	^ self = OPDiagramToolbarCommand
]

{ #category : 'activation' }
OPDiagramToolbarCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byRootGroupItemOrder: 100
		for: OPCanvasPresenter
]

{ #category : 'execution' }
OPDiagramToolbarCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	diagramPresenter := aToolContext
]
