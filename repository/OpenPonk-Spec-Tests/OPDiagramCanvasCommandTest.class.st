"
Verifies diagram canvas commands, export and inspection delegations, menu group names, and context extraction.
"
Class {
	#name : 'OPDiagramCanvasCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'tests' }
OPDiagramCanvasCommandTest >> testCanvasPresenterFromContextUnwrapsToolContext [

	| canvasPresenter toolContext |
	canvasPresenter := OPCanvasPresenter new.
	toolContext := CmdSimpleToolContext for: canvasPresenter.
	self assert: (OPDiagramCanvasCommand canvasPresenterFromContext: toolContext) identicalTo: canvasPresenter.
	self assert: (OPDiagramCanvasCommand canvasPresenterFromContext: canvasPresenter) identicalTo: canvasPresenter
]

{ #category : 'tests' }
OPDiagramCanvasCommandTest >> testDiagramMenuGroupNamesAndActivations [

	self assert: OPDiagramDevMenuGroup new name equals: 'Dev'.
	self assert: OPDiagramElementsMenuGroup new name equals: 'Elements'.
	self assert: OPExportDiagramPngCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation.
	self assert: OPExportDiagramSvgCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation.
	self assert: OPExportDiagramPdfCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation.
	self assert: OPInspectDiagramControllerCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation.
	self assert: OPShowHideElementsInDiagramCommand diagramMenuActivation class identicalTo: OPDiagramMenuActivation
]

{ #category : 'tests' }
OPDiagramCanvasCommandTest >> testExportAndInspectDiagramCommandsExecute [

	| canvasPresenterStub diagramControllerStub toolContext pngCommand svgCommand pdfCommand inspectCommand |
	diagramControllerStub := Mock new.
	diagramControllerStub stub inspect willReturn: diagramControllerStub.
	canvasPresenterStub := Mock new.
	canvasPresenterStub stub exportAsPng willReturn: nil.
	canvasPresenterStub stub exportAsSvg willReturn: nil.
	canvasPresenterStub stub exportAsPdf willReturn: nil.
	canvasPresenterStub stub diagramController willReturn: diagramControllerStub.
	toolContext := CmdSimpleToolContext for: canvasPresenterStub.

	pngCommand := OPExportDiagramPngCommand new.
	pngCommand prepareFullExecutionInContext: toolContext.
	pngCommand execute.
	canvasPresenterStub should receive exportAsPng.

	svgCommand := OPExportDiagramSvgCommand new.
	svgCommand prepareFullExecutionInContext: toolContext.
	svgCommand execute.
	canvasPresenterStub should receive exportAsSvg.

	pdfCommand := OPExportDiagramPdfCommand new.
	pdfCommand prepareFullExecutionInContext: toolContext.
	pdfCommand execute.
	canvasPresenterStub should receive exportAsPdf.

	inspectCommand := OPInspectDiagramControllerCommand new.
	inspectCommand prepareFullExecutionInContext: toolContext.
	inspectCommand execute.
	diagramControllerStub should receive inspect
]

{ #category : 'tests' }
OPDiagramCanvasCommandTest >> testShowHideElementsInDiagramCommandExecuteOpensWindow [

	| existingWindows project container diagram projectController mockWorkbench testEditor command openedWindows |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	project := OPProject named: 'Test Project'.
	container := OPTestContainerModel new
		             name: 'Container';
		             yourself.
	project addModel: container.
	diagram := (OPOpenPonkDiagram forModelElement: container)
		           name: 'Main Diagram';
		           yourself.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: projectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	mockWorkbench stub announcer willReturn: Announcer new.
	testEditor := (OPEditor on: OPTestPlugin new)
		              workbench: mockWorkbench;
		              yourself.
	testEditor openEmptyModel: container.
	testEditor diagramController diagramElement: diagram.

	command := OPShowHideElementsInDiagramCommand new.
	command prepareFullExecutionInContext: (CmdSimpleToolContext for: testEditor canvasPresenter).
	[
		command execute.
		openedWindows := self currentWorld submorphs select: [ :each |
			                 each isSystemWindow and: [ (existingWindows includes: each) not ] ].
		self denyEmpty: openedWindows ] ensure: [
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (existingWindows includes: each) not ]) ifTrue: [ each delete ] ] ]
]
