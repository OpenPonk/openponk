"
I am a DrTests command that extends the DrTests UI. I allow developers to select a specific test result (leaf result) and export its execution context and associated class structures to the clipboard for LLM-assisted debugging.
"
Class {
	#name : 'OPDTExportCommand',
	#superclass : 'DTLeafResultCommand',
	#category : 'OpenPonk-Tools-Export',
	#package : 'OpenPonk-Tools',
	#tag : 'Export'
}

{ #category : 'executing' }
OPDTExportCommand >> execute [

	| testCase report |
	testCase := self resultSelected content.
	OPTestFailureExporter resetCache.
	report := OPTestFailureExporter new
		          runTest: testCase class
		          selector: testCase selector.
	Clipboard clipboardText: report.
	report inspect.
	UIManager default inform: 'Test context exported to clipboard.'
]

{ #category : 'initialization' }
OPDTExportCommand >> initialize [

	super initialize.
	self
		name: 'Export';
		description:
			'Runs the test and exports its context to the clipboard for sharing, LLM debugging etc.'
]
