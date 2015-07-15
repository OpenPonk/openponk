toolbar
toolbarFor: aGroup
	<DCEditorToolbar: 10000>
	(aGroup addItem: 'Diagram Controller')
		description: 'Inspect Diagram Controller';
		action: [ self diagramController inspect ].

	plugin editorToolbarFor: aGroup