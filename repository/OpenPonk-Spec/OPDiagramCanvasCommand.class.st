"
Abstract base class for commands that appear in the OpenPonk diagram toolbar, extending CmdCommand for integration with the Commander framework.
"
Class {
	#name : 'OPDiagramCanvasCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'diagramPresenter'
	],
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'accessing' }
OPDiagramCanvasCommand class >> canvasPresenterFromContext: aToolContextOrCanvasPresenter [
	"Answers the OPCanvasPresenter extracted from the given tool context or returns the canvas presenter directly."
	(aToolContextOrCanvasPresenter isKindOf: CmdToolContext)
		ifTrue: [ ^ aToolContextOrCanvasPresenter tool ].
	^ aToolContextOrCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramCanvasCommand class >> editorFromContext: aToolContextOrCanvasPresenter [
	"Answers the OPEditor owning the canvas presenter extracted from context."
	| canvasPresenter |
	canvasPresenter := self canvasPresenterFromContext: aToolContextOrCanvasPresenter.
	^ canvasPresenter ifNotNil: [ :activeCanvasPresenter | activeCanvasPresenter editor ]
]

{ #category : 'testing' }
OPDiagramCanvasCommand class >> isAbstract [
	^ self = OPDiagramCanvasCommand
]

{ #category : 'execution' }
OPDiagramCanvasCommand >> prepareFullExecutionInContext: aToolContextOrCanvasPresenter [
	"Initializes diagramPresenter with the canvas presenter extracted from the tool context or passed directly."
	super prepareFullExecutionInContext: aToolContextOrCanvasPresenter.
	diagramPresenter := self class canvasPresenterFromContext: aToolContextOrCanvasPresenter
]
