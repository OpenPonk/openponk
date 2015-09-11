opening
openEditorOn: aDiagram
	| editor tab plugin |
	(editor := DCEditor new) workbench: self.
	editor buildWithSpec.
	plugin := pluginRegistry pluginFor: aDiagram.
	(tab := self newTab)
		label: aDiagram name;
		icon: plugin icon;
		retrievingBlock: [ 
			editor owner: tab.
			editor buildWithSpec asWidget ].
	tabManager addTab: tab.
	editor plugin: plugin.
	editor openDiagram: aDiagram.
	editor rebuildWidget.
	aDiagram whenChanged: [ tab label: aDiagram name ].
	editor paletteModel rebuildWidget