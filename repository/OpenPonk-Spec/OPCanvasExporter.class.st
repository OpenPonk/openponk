Class {
	#name : 'OPCanvasExporter',
	#superclass : 'Object',
	#instVars : [
		'silently',
		'diagramController',
		'file'
	],
	#category : 'OpenPonk-Spec-Export',
	#package : 'OpenPonk-Spec',
	#tag : 'Export'
}

{ #category : 'as yet unclassified' }
OPCanvasExporter class >> exportDiagramController: aDiagramController to: aFileReference [

	self new
		diagramController: aDiagramController to: aFileReference;
		export
]

{ #category : 'as yet unclassified' }
OPCanvasExporter class >> exportSilentlyDiagramController: aDiagramController to: aFileReference [

	self silent
		diagramController: aDiagramController to: aFileReference;
		export
]

{ #category : 'as yet unclassified' }
OPCanvasExporter class >> silent [

	^ self new
		  silent;
		  yourself
]

{ #category : 'accessing' }
OPCanvasExporter >> canvas [

	^ self diagramController canvas
]

{ #category : 'accessing' }
OPCanvasExporter >> diagramController [

	^ diagramController
]

{ #category : 'accessing' }
OPCanvasExporter >> diagramController: aDiagramController to: aFileReference [

	diagramController := aDiagramController.
	file := aFileReference
]

{ #category : 'actions' }
OPCanvasExporter >> export [

	| jobBlock |
	self diagramController deselectAll.

	jobBlock := [ :job |
	            job title: 'Exporting diagram'.
	            [ self exportInJob: job ] ensure: [
		            job progress: 0.8.
		            self canvas signalUpdate ] ].

	silently ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	self showFinishedPopup
]

{ #category : 'private - actions' }
OPCanvasExporter >> exportInJob: job [

	self setupExporter export
]

{ #category : 'initialization' }
OPCanvasExporter >> initialize [

	super initialize.
	silently := false
]

{ #category : 'hooks' }
OPCanvasExporter >> roassalExporter [

	^ self subclassResponsibility
]

{ #category : 'hooks' }
OPCanvasExporter >> setupExporter [

	^ self roassalExporter
		  fileName: file pathString;
		  zoomToShapes;
		  yourself
]

{ #category : 'actions' }
OPCanvasExporter >> showFinishedPopup [

	UIManager default
		inform: (String streamContents: [ :s |
				 s << 'Diagram saved to ' << file pathString.
				 s
					 cr;
					 cr.
					 "s << 'Click to open location' commented as it does not work" ])
		actionOnClick: [ file openInOSFileBrowser ]
]

{ #category : 'accessing' }
OPCanvasExporter >> silent [

	silently := true
]
