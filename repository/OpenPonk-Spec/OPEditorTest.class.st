Class {
	#name : 'OPEditorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPEditorTest >> testTabClosedWhileClosingWorkbenchUpdatesDiagram [
	| testProject testContainerModel testDiagram workbench activeEditor canvas initialCamera |
	testProject := OPProject named: 'CoreEditorCloseUnitTest'.
	testContainerModel := OPTestContainerModel new.
	testDiagram := OPOpenPonkDiagram forModelElement: testContainerModel.
	testProject addModel: testContainerModel.
	testProject addDiagram: testDiagram.

	[
		workbench := OPWorkbench new.
		workbench pluginRegistry: OPPluginRegistry withAllForTesting.
		workbench openProject: testProject.
		workbench openEditorOnDiagram: testDiagram.
		activeEditor := workbench focusedEditor.
		canvas := activeEditor canvasPresenter canvas.
		canvas camera scale: 2.75.

		activeEditor tabClosedWhileClosingWorkbench: true.

		initialCamera := testDiagram camera.
		self assert: initialCamera isNotNil.
		self assert: (initialCamera scale - 2.75) abs < 0.001.
	] ensure: [
		workbench ifNotNil: [ :currentWorkbench | currentWorkbench close ] ]
]
