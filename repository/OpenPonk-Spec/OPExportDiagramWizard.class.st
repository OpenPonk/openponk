"
I am a wizard for exporting the diagram (Roassal canvas) to an image file.
"
Class {
	#name : #OPExportDiagramWizard,
	#superclass : #WizardControl,
	#instVars : [
		'modelName',
		'view'
	],
	#category : #'OpenPonk-Spec-Wizards'
}

{ #category : #adding }
OPExportDiagramWizard >> addExportPane [
	| pane |
	pane := WizardSinglePane new.
	pane name: 'Save diagram to a *.png file'.
	pane
		addPart:
			(SaveChooseFilePart new
				validExtensions: #(png);
				yourself)
		associatedTo: #targetFile.
	"pane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Heading';
				defaultValue: [ :args | modelName ];
				suffix: 'Added heading to the top left corner')
		associatedTo: #diagramName."
	self addPane: pane
]

{ #category : #exporting }
OPExportDiagramWizard >> exportWith: aDictionary [
	| gridShape gridColor |
	(aDictionary at: #targetFile) ifNil: [ ^ self inform: 'Export canceled.' ].
	gridShape := view canvas shapes detect: [ :each | each isKindOf: TRCanvasGridShape ].
	gridColor := gridShape color.
	[ gridShape color: Color transparent.
	OPTRCanvasExporter new
		asPNG;
		canvas: view canvas;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: (aDictionary at: #targetFile);
		export ]
		ensure: [ gridShape color: gridColor ]
]

{ #category : #'initialize-release' }
OPExportDiagramWizard >> initialize [
	super initialize.
	modelName := ''.
	self addExportPane.
	self atEndDo: [ :values | self exportWith: values ]
]

{ #category : #accessing }
OPExportDiagramWizard >> modelName: aString [
	modelName := aString
]

{ #category : #accessing }
OPExportDiagramWizard >> view: aView [
	view := aView
]
