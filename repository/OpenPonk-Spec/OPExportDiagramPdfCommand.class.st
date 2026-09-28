"
A canvas presenter command that renders and exports the active diagram layout into a PDF vector file.
"
Class {
	#name : 'OPExportDiagramPdfCommand',
	#superclass : 'OPDiagramCanvasCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPExportDiagramPdfCommand class >> diagramMenuActivation [
	<classAnnotation>
	^ OPDiagramMenuActivation
		byItemOf: OPDiagramExportMenuGroup
		order: 30
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPExportDiagramPdfCommand >> defaultMenuItemName [
	"Answers the label for the diagram export menu item."
	^ 'Export as PDF...'
]

{ #category : 'execution' }
OPExportDiagramPdfCommand >> execute [
	"Executes the PDF export dialog on the canvas presenter."
	diagramPresenter exportAsPdf
]
