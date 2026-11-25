"
Verifies metadata, activation, context preparation, and execution behavior of Calypso, DrTests, and file-out export commands in OpenPonk-DevTools.
"
Class {
	#name : 'OPDevToolsExportCommandsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-DevTools-Tests-Export',
	#package : 'OpenPonk-DevTools-Tests',
	#tag : 'Export'
}

{ #category : 'private - fixtures' }
OPDevToolsExportCommandsTest >> failingHelperWithoutControllerClass [

	self assert: 1 equals: 2
]

{ #category : 'tests' }
OPDevToolsExportCommandsTest >> testClyExportTestFailureCommandMetadataAndExecution [

	| command oldClipboard existingWindows |
	command := OPClyExportTestFailureCommand new.
	self assert: OPClyExportTestFailureCommand fullBrowserTableIconActivation equals: OPClyExportTestFailureCommand.
	self assert: command defaultMenuIconName equals: #smallExport.
	self assert: command defaultMenuItemName equals: 'Export'.
	self assert: command description equals: 'Exports the selected test context to the clipboard for sharing, LLM debugging etc.'.

	oldClipboard := Clipboard clipboardText.
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	[
		command runTest: #failingHelperWithoutControllerClass of: self class.
		self
			assert: (Clipboard clipboardText asString includesSubstring: '=== EXCEPTION ===')
			description: 'Export command should copy failure report to clipboard' ] ensure: [
			self currentWorld submorphs
				select: [ :each | each isSystemWindow and: [ (existingWindows includes: each) not ] ]
				thenDo: [ :each | each delete ].
			Clipboard clipboardText: oldClipboard.
			OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPDevToolsExportCommandsTest >> testDTExportCommandInitializeAndExecute [

	| command contextMock leafMock oldClipboard existingWindows |
	command := OPDTExportCommand new.
	self assert: command name equals: 'Export'.
	self assert: command description equals: 'Runs the test and exports its context to the clipboard for sharing, LLM debugging etc.'.

	leafMock := Mock new.
	leafMock stub content willReturn: (self class selector: #failingHelperWithoutControllerClass).
	contextMock := Mock new.
	contextMock stub resultSelected willReturn: leafMock.
	command context: contextMock.

	oldClipboard := Clipboard clipboardText.
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	[
		command execute.
		self
			assert: (Clipboard clipboardText asString includesSubstring: '=== EXCEPTION ===')
			description: 'DrTests export command should copy failure report to clipboard' ] ensure: [
			self currentWorld submorphs
				select: [ :each | each isSystemWindow and: [ (existingWindows includes: each) not ] ]
				thenDo: [ :each | each delete ].
			Clipboard clipboardText: oldClipboard.
			OPTestFailureExporter resetCache ]
]

{ #category : 'tests' }
OPDevToolsExportCommandsTest >> testSycFileOutPackageTagCommandMetadataAndConfiguration [

	| command package exportTag releasesTag singleContext multiContext singleItem multiItem1 multiItem2 fileouter |
	command := OPSycFileOutPackageTagCommand new.
	self
		assert: (OPSycFileOutPackageTagCommand fullBrowserMenuActivation isKindOf: CmdContextMenuActivation)
		description: 'File out command should expose a Calypso context menu activation'.
	self assert: command defaultMenuIconName equals: #save.
	self assert: command defaultMenuItemName equals: 'File out'.

	package := self packageOrganizer packageNamed: 'OpenPonk-DevTools'.
	exportTag := package tagNamed: 'Export'.
	releasesTag := package tagNamed: 'Releases'.

	singleItem := Mock new.
	singleItem stub actualObject willReturn: releasesTag.
	singleContext := Mock new.
	singleContext stub selectedItems willReturn: { singleItem }.
	command prepareFullExecutionInContext: singleContext.
	self assert: command fileoutFilename equals: 'Releases'.

	fileouter := Fileouter new.
	command configureFileouter: fileouter.
	self assertCollection: fileouter behaviors hasSameElements: releasesTag classes.

	multiItem1 := Mock new.
	multiItem1 stub actualObject willReturn: exportTag.
	multiItem2 := Mock new.
	multiItem2 stub actualObject willReturn: releasesTag.
	multiContext := Mock new.
	multiContext stub selectedItems willReturn: {
			multiItem1.
			multiItem2 }.
	command prepareFullExecutionInContext: multiContext.
	self assert: command fileoutFilename equals: 'packagefileout'.

	fileouter := Fileouter new.
	command configureFileouter: fileouter.
	self assertCollection: fileouter behaviors hasSameElements: exportTag classes , releasesTag classes
]
