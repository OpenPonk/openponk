actions
openFirstDiagram
	disableAutosave := true.
	project diagrams ifNotEmpty: [ workbench openEditorOn: project diagrams first ].
	self loadAutosave.
	disableAutosave := false