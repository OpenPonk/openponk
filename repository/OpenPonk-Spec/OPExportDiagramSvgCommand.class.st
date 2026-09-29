"
A canvas presenter command that serializes the current diagram view into a scalable SVG vector document.
"
Class {
	#name : 'OPExportDiagramSvgCommand',
	#superclass : 'OPDiagramCanvasCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPExportDiagramSvgCommand class >> diagramMenuActivation [
	<classAnnotation>
	^ OPDiagramMenuActivation
		byItemOf: OPDiagramExportMenuGroup
		order: 20
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPExportDiagramSvgCommand >> defaultMenuItemName [
	"Answers the label for the diagram export menu item."
	^ 'Export as SVG...'
]

{ #category : 'execution' }
OPExportDiagramSvgCommand >> execute [
	"Executes the SVG export dialog on the canvas presenter."
	diagramPresenter exportAsSvg
]
