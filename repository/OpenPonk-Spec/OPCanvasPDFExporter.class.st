"
Concrete exporter responsible for rendering and saving an OpenPonk diagram canvas into a PDF (Portable Document Format) file via Roassal.
"
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
