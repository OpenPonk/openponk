"
Tests tool palette entry creation, icon bindings, and active tool switching in the diagram editor.
"
Class {
	#name : 'OPPaletteEntryTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Palettes',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Palettes'
}

{ #category : 'tests' }
OPPaletteEntryTest >> testDefaultActionSelectsEntryInPalette [

	| palette entry |
	palette := OPPalette new.
	entry := palette newCreationEntry: [ OPTestEntityController new ].

	self assert: entry palette identicalTo: palette.
	entry performAction.

	self assert: palette selectedTool identicalTo: entry tool.
	self assert: entry state description: 'Default action should select the palette entry'
]

{ #category : 'tests' }
OPPaletteEntryTest >> testRegisterShortcutRespectsFormKeyboardFocus [

	| existingWindows project workbench window editor palette entry otherEntry textInput keymap event |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	window := nil.
	[
		project := OPProject named: 'ShortcutTest'.
		workbench := OPWorkbench new.
		workbench openProject: project.
		window := workbench open.
		editor := OPEditor new.
		editor owner: workbench.
		editor instVarNamed: #workbench put: workbench.
		workbench instVarNamed: #focusedEditor put: editor.
		palette := OPPalette new.
		palette owner: editor.
		entry := palette newCreationEntry: [ OPTestEntityController new ].
		otherEntry := palette newCreationEntry: [ OPTestEntityController new ].

		textInput := workbench form addTextInput: 'Name'.
		workbench form rebuildWidget.
		self currentWorld doOneCycle.

		entry registerShortcut: nil.
		entry registerShortcut: $n asKeyCombination.
		keymap := workbench contextKeyBindings keymaps detect: [ :each | each shortcut = $n asKeyCombination ].

		event := KeyboardEvent new.
		event wasHandled: true.
		keymap action value: nil value: nil value: event.
		self assert: palette selectedTool identicalTo: entry tool.

		palette selectEntry: otherEntry.
		textInput takeKeyboardFocus.
		self currentWorld doOneCycle.

		event := KeyboardEvent new.
		event wasHandled: true.
		keymap action value: nil value: nil value: event.
		self deny: event wasHandled description: 'Shortcut must be ignored when a form text input has keyboard focus'.
		self assert: palette selectedTool identicalTo: otherEntry tool ] ensure: [
			window ifNotNil: [ window close ].
			self currentWorld submorphs
				select: [ :each | each isSystemWindow and: [ (existingWindows includes: each) not ] ]
				thenDo: #delete ]
]

{ #category : 'tests' }
OPPaletteEntryTest >> testShouldIgnoreEventReturnsTrueWhenFocusedEditorIsNilOrDifferent [

	| workbench editor otherEditor palette entry mockWindow |
	workbench := OPWorkbench new.
	editor := OPEditor new.
	editor instVarNamed: #workbench put: workbench.
	otherEditor := OPEditor new.
	otherEditor instVarNamed: #workbench put: workbench.
	palette := OPPalette new.
	palette owner: editor.
	entry := OPPaletteEntry new.
	entry owner: palette.
	mockWindow := Mock new.
	mockWindow stub presenter willReturn: workbench.

	self assert: (entry shouldIgnoreEvent: mockWindow) description: 'Shortcut must be ignored when workbench has no focused editor'.

	workbench instVarNamed: #focusedEditor put: otherEditor.
	self assert: (entry shouldIgnoreEvent: mockWindow) description: 'Shortcut must be ignored when another editor is focused'
]

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupFocusesForm [
	"Verify that creation tool completes and focuses the dynamic form without modal dialogs."
	| paletteEntry creationTool dummyController dummyDiagramController formSpy |
	paletteEntry := OPPaletteEntry new.
	creationTool := OPNodeCreationTool new.
	paletteEntry tool: creationTool.

	formSpy := OPPropertiesFormFocusSpy new.
	formSpy addTextInput: 'Name'.

	dummyDiagramController := Mock new.
	dummyDiagramController stub form willReturn: formSpy.

	dummyController := Mock new.
	dummyController stub diagramController willReturn: dummyDiagramController.

	creationTool instVarNamed: #controller put: dummyController.
	creationTool doOnCompleteActions.

	self
		assert: formSpy focusTaken
		description: 'Completing creation tool should focus first input on properties form'
]

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupWithoutDiagramController [
	"Verify that creation tool safely executes completion for headless controllers without a diagram controller."
	| paletteEntry creationTool dummyController callbackExecuted |
	callbackExecuted := false.
	paletteEntry := OPPaletteEntry new.
	creationTool := OPNodeCreationTool new.
	paletteEntry tool: creationTool.
	paletteEntry whenCreated: [ :ctrl | callbackExecuted := true ].

	dummyController := Mock new.
	dummyController stub diagramController willReturn: nil.

	creationTool instVarNamed: #controller put: dummyController.
	creationTool doOnCompleteActions.

	self
		assert: callbackExecuted
		description: 'whenCreated: callback should execute even when diagramController is nil'
]
