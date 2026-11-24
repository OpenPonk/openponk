"
Verifies diagram layout commands and their delegation to the active diagram layouter.
"
Class {
	#name : 'OPLayoutDiagramCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Layouting',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Layouting'
}

{ #category : 'tests' }
OPLayoutDiagramCommandTest >> testDiagramMenuActivation [

	self assert: OPLayoutDiagramCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation
]

{ #category : 'tests' }
OPLayoutDiagramCommandTest >> testLayoutCommandsDelegateToLayouter [

	| layouterStub diagramControllerStub canvasPresenterStub toolContext dominanceCommand gridCommand sugiyamaCommand treeCommand |
	layouterStub := Mock new.
	layouterStub stub dominanceTreeLayout willReturn: nil.
	layouterStub stub gridLayout willReturn: nil.
	layouterStub stub sugiyamaLayout willReturn: nil.
	layouterStub stub treeLayout willReturn: nil.

	diagramControllerStub := Mock new.
	diagramControllerStub stub layouter willReturn: layouterStub.
	canvasPresenterStub := Mock new.
	canvasPresenterStub stub diagramController willReturn: diagramControllerStub.
	toolContext := CmdSimpleToolContext for: canvasPresenterStub.

	dominanceCommand := OPDominanceTreeLayoutCommand new.
	dominanceCommand prepareFullExecutionInContext: toolContext.
	dominanceCommand execute.
	layouterStub should receive dominanceTreeLayout.

	gridCommand := OPGridLayoutCommand new.
	gridCommand prepareFullExecutionInContext: toolContext.
	gridCommand execute.
	layouterStub should receive gridLayout.

	sugiyamaCommand := OPSugiyamaLayoutCommand new.
	sugiyamaCommand prepareFullExecutionInContext: toolContext.
	sugiyamaCommand execute.
	layouterStub should receive sugiyamaLayout.

	treeCommand := OPTreeLayoutCommand new.
	treeCommand prepareFullExecutionInContext: toolContext.
	treeCommand execute.
	layouterStub should receive treeLayout
]
