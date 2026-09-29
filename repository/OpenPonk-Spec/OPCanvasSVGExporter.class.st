"
Concrete exporter responsible for rendering and saving an OpenPonk diagram canvas into an SVG (Scalable Vector Graphics) file via Roassal.
"
Class {
	#name : 'OPCanvasSVGExporter',
	#superclass : 'OPCanvasExporter',
	#category : 'OpenPonk-Spec-Export',
	#package : 'OpenPonk-Spec',
	#tag : 'Export'
}

{ #category : 'hooks' }
OPCanvasSVGExporter >> roassalExporter [

	^ self canvas svgCairoExporter
]
