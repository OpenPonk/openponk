Class {
	#name : 'OPCanvasPDFExporter',
	#superclass : 'OPCanvasExporter',
	#category : 'OpenPonk-Spec-Export',
	#package : 'OpenPonk-Spec',
	#tag : 'Export'
}

{ #category : 'hooks' }
OPCanvasPDFExporter >> roassalExporter [

	^ self canvas pdfExporter
]
