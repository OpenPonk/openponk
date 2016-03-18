actions
openFirstDiagram
	disableAutosave := true.
	project models ifNotEmpty: [ workbench openEditorOn: project models first ].
	self loadAutosave.
	disableAutosave := false