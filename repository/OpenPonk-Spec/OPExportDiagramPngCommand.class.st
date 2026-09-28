"
A canvas presenter command that rasterizes and saves the active diagram as a PNG bitmap graphic.
"
Class {
	#name : 'OPExportDiagramPngCommand',
	#superclass : 'OPDiagramCanvasCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPExportDiagramPngCommand class >> diagramMenuActivation [
	<classAnnotation>
	^ OPDiagramMenuActivation
		byItemOf: OPDiagramExportMenuGroup
		order: 10
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPExportDiagramPngCommand >> defaultMenuItemName [
	"Answers the label for the diagram export menu item."
	^ 'Export as PNG...'
]

{ #category : 'execution' }
OPExportDiagramPngCommand >> execute [
	"Executes the PNG export dialog on the canvas presenter."
	diagramPresenter exportAsPng
]
