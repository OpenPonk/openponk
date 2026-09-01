"
I am a Calypso browser command that extends the standard test runner interactions. I allow developers to run a specific test method directly from the system browser and immediately export its execution context and failure trace to the clipboard utilizing OPLLMContextExporter.
"
Class {
	#name : 'OPClyExportTestFailureCommand',
	#superclass : 'ClyRunTestsFromMethodsCommand',
	#category : 'OpenPonk-Tools-Export',
	#package : 'OpenPonk-Tools',
	#tag : 'Export'
}

{ #category : 'activation' }
OPClyExportTestFailureCommand class >> fullBrowserTableIconActivation [
	"It should not be as icon in table"
]

{ #category : 'accessing' }
OPClyExportTestFailureCommand >> defaultMenuIconName [

	^ #smallExport
]

{ #category : 'accessing' }
OPClyExportTestFailureCommand >> defaultMenuItemName [

	^ 'Export'
]

{ #category : 'accessing' }
OPClyExportTestFailureCommand >> description [

	^ 'Exports the selected test context to the clipboard for sharing, LLM debugging etc.'
]

{ #category : 'execution' }
OPClyExportTestFailureCommand >> runTest: testSelector of: testClass [

	| report |
	OPTestFailureExporter resetCache.
	report := OPTestFailureExporter new
		          runTest: testClass
		          selector: testSelector.
	Clipboard clipboardText: report.
	report inspect.
	UIManager default inform:
		'Test report context exported to clipboard.'
]
