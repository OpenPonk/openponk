"
Verifies test failure context extraction, stack frame variable formatting, MVC triad collection, and export cache deduplication in OPTestFailureExporter.
"
Class {
	#name : 'OPTestFailureExporterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-DevTools-Tests-Export',
	#package : 'OpenPonk-DevTools-Tests',
	#tag : 'Export'
}

{ #category : 'accessing' }
OPTestFailureExporterTest >> controllerClass [

	^ OPNoteController
]

{ #category : 'private - fixtures' }
OPTestFailureExporterTest >> failingHelperForExporterTest [

	| sampleLocalValue |
	sampleLocalValue := 42.
	self assert: sampleLocalValue equals: 0
]

{ #category : 'private - fixtures' }
OPTestFailureExporterTest >> failingHelperWithUnprintableLocal [

	| brokenObject |
	brokenObject := Mock new.
	brokenObject stub printString willRaise: (Error new messageText: 'cannot print').
	self assert: brokenObject equals: nil
]

{ #category : 'private - fixtures' }
OPTestFailureExporterTest >> passingHelperForExporterTest [

	self assert: 1 equals: 1
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testContextTempNamesDelegatesToTemporaryVariableNames [

	| sampleTemp |
	sampleTemp := 1.
	self assertCollection: thisContext tempNames hasSameElements: thisContext temporaryVariableNames.
	self assert: sampleTemp equals: 1
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testGeneratesReportAndDeduplicatesCode [

	| exporter firstReport secondReport |
	[
		OPTestFailureExporter resetCache.
		exporter := OPTestFailureExporter new.
		firstReport := exporter runTest: self class selector: #failingHelperForExporterTest.
		self assert: (firstReport includesSubstring: '=== EXCEPTION ===') description: 'First report should contain exception section'.
		self
			assert: (firstReport includesSubstring: 'sampleLocalValue = 42')
			description: 'First report should capture local variable value from stack context'.
		self
			assert: (firstReport includesSubstring: 'OPNoteController')
			description: 'First report should include MVC triad classes from controllerClass'.

		secondReport := exporter runTest: self class selector: #failingHelperForExporterTest.
		self
			assert: secondReport size < firstReport size
			description: 'Second report without cache reset should omit already exported class definitions and methods' ] ensure: [
		OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testLazyCacheInitializationWhenCacheIsNil [

	| exporter cache |
	[
		OPTestFailureExporter classVarNamed: #ExportedCache put: nil.
		exporter := OPTestFailureExporter new.
		cache := OPTestFailureExporter classVarNamed: #ExportedCache.
		self assert: exporter class equals: OPTestFailureExporter.
		self assert: cache class equals: Dictionary.
		self assertEmpty: cache ] ensure: [ OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testPassingTestProducesEmptyReport [

	| report |
	[
		OPTestFailureExporter resetCache.
		report := OPTestFailureExporter new runTest: self class selector: #passingHelperForExporterTest.
		self assertEmpty: report ] ensure: [ OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testPrintContextHandlesUnprintableLocalVariable [

	| report |
	[
		OPTestFailureExporter resetCache.
		report := OPTestFailureExporter new runTest: self class selector: #failingHelperWithUnprintableLocal.
		self
			assert: (report includesSubstring: '<error printing object>')
			description: 'Unprintable local variables should fall back to placeholder text' ] ensure: [ OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPTestFailureExporterTest >> testSkipsMvcTriadLookupWhenTestClassHasNoControllerClass [

	| report |
	[
		OPTestFailureExporter resetCache.
		report := OPTestFailureExporter new runTest: OPDevToolsExportCommandsTest selector: #failingHelperWithoutControllerClass.
		self assert: (report includesSubstring: '=== EXCEPTION ===') description: 'Report should contain exception header'.
		self
			deny: (report includesSubstring: 'OPNoteController')
			description: 'Test classes without controllerClass must not inject OPNoteController' ] ensure: [
		OPTestFailureExporter resetCache ]
]
