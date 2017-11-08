tests - ui interaction
testAttachEditor
	| editor workbench |
	editor := OPEditor new.
	workbench := OPWorkbench new.
	editor stub workbench willReturn: workbench.
	diagramController editor: editor.
	self assert: diagramController formPresenter isNotNil