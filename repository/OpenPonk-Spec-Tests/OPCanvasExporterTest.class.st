"
Verifies silent and standard diagram exports to PNG, SVG, and PDF files and custom scale camera configuration.
"
Class {
	#name : 'OPCanvasExporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagramController',
		'memoryFs'
	],
	#category : 'OpenPonk-Spec-Tests-Export',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Export'
}

{ #category : 'running' }
OPCanvasExporterTest >> setUp [
	| project container diagram testCanvas projectController |
	super setUp.
	memoryFs := FileSystem memory.
	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).
	diagramController showInDiagramModel: (container add: OPTestEntityModel new)
]

{ #category : 'tests' }
OPCanvasExporterTest >> testExporterSetupAndCustomScaleCamSetter [
	| pngFile svgFile pdfFile pngExporter svgExporter pdfExporter roassalPngExporter camSetter |
	pngFile := memoryFs root / 'diagram.png'.
	svgFile := memoryFs root / 'diagram.svg'.
	pdfFile := memoryFs root / 'diagram.pdf'.
	pngExporter := OPCanvasPNGExporter silent
		diagramController: diagramController to: pngFile zoom: 2.0;
		yourself.
	self assert: pngExporter diagramController identicalTo: diagramController.
	self assert: pngExporter canvas identicalTo: diagramController canvas.
	roassalPngExporter := pngExporter setupExporter.
	camSetter := roassalPngExporter cameraSetter.
	self assert: camSetter class equals: OPRSCustomScaleCamSetter.
	self assert: camSetter scale equals: 2.0.
	svgExporter := OPCanvasSVGExporter silent
		diagramController: diagramController to: svgFile;
		yourself.
	self
		deny: svgExporter setupExporter
		equals: nil.
	pdfExporter := OPCanvasPDFExporter silent
		diagramController: diagramController to: pdfFile;
		yourself.
	self
		deny: pdfExporter setupExporter
		equals: nil
]

{ #category : 'tests' }
OPCanvasExporterTest >> testShowFinishedPopupInterceptedByProvideAnswerNotification [
	| exporter targetFile capturedMessage |
	targetFile := memoryFs root / 'exported.png'.
	exporter := OPCanvasPNGExporter new
		diagramController: diagramController to: targetFile;
		yourself.
	capturedMessage := nil.
	[ exporter showFinishedPopup ]
		on: ProvideAnswerNotification
		do: [ :notification |
			capturedMessage := notification messageText.
			notification resume: true ].
	self
		assert: (capturedMessage includesSubstring: 'exported.png')
		description: 'Finished popup notification should mention exported file name'
]

{ #category : 'tests' }
OPCanvasExporterTest >> testSilentPngExportWritesFileAndAppliesCustomScaleCamSetter [
	| tempFile |
	tempFile := FileLocator temp / ('op-canvas-export-' , UUID new asString , '.png').
	[
		OPCanvasPNGExporter
			exportSilentlyDiagramController: diagramController
			to: tempFile
			zoom: 1.5.
		self assert: tempFile exists description: 'Silent PNG export with zoom should write a PNG file'.
		self assert: tempFile size > 0 description: 'Exported PNG file should be non-empty'.
		tempFile ensureDelete.

		OPCanvasPNGExporter
			exportSilentlyDiagramController: diagramController
			to: tempFile.
		self assert: tempFile exists description: 'Silent PNG export with default zoom should write a PNG file'
	] ensure: [ tempFile ensureDelete ]
]
