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
