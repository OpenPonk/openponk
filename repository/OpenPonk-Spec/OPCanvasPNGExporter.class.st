Class {
	#name : 'OPCanvasPNGExporter',
	#superclass : 'OPCanvasExporter',
	#instVars : [
		'zoom'
	],
	#category : 'OpenPonk-Spec-Export',
	#package : 'OpenPonk-Spec',
	#tag : 'Export'
}

{ #category : 'as yet unclassified' }
OPCanvasPNGExporter class >> exportDiagramController: aDiagramController to: aFileReference zoom: aZoom [

	self new
		diagramController: aDiagramController to: aFileReference zoom: aZoom;
		export
]

{ #category : 'as yet unclassified' }
OPCanvasPNGExporter class >> exportSilentlyDiagramController: aDiagramController to: aFileReference zoom: aZoom [

	self silent
		diagramController: aDiagramController
		to: aFileReference
		zoom: aZoom;
		export
]

{ #category : 'as yet unclassified' }
OPCanvasPNGExporter >> diagramController: aDiagramController to: aFileReference [

	super diagramController: aDiagramController to: aFileReference.
	zoom := 1.0
]

{ #category : 'as yet unclassified' }
OPCanvasPNGExporter >> diagramController: aDiagramController to: aFileReference zoom: aZoom [

	self diagramController: aDiagramController to: aFileReference.
	zoom := aZoom
]

{ #category : 'hooks' }
OPCanvasPNGExporter >> roassalExporter [

	^ self canvas pngExporter
]

{ #category : 'as yet unclassified' }
OPCanvasPNGExporter >> setupExporter [

	^ super setupExporter
		  cameraSetter: (OPRSCustomScaleCamSetter scale: zoom);
		  yourself
]
