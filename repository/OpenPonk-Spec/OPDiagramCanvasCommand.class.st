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

{ #category : 'testing' }
OPDiagramCanvasCommand class >> isAbstract [
	^ self = OPDiagramCanvasCommand
]

{ #category : 'execution' }
OPDiagramCanvasCommand >> prepareFullExecutionInContext: aCanvasPresenter [
	"Initializes diagramPresenter with the canvas presenter wrapped in the tool context."
	super prepareFullExecutionInContext: aCanvasPresenter.
	diagramPresenter := aCanvasPresenter
]
