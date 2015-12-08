opening
openEditorOn: aDiagram
	| editor tab plugin |
	(editor := DCEditor new) workbench: self.
	plugin := pluginRegistry pluginFor: aDiagram.
	editor plugin: plugin.
	(tab := self newTab)
		label: aDiagram name;
		icon: plugin icon;
		retrievingBlock:
				[ | w |
			w := editor buildWithSpec asWidget.
			editor owner: tab.
			editor openDiagram: aDiagram.
			aDiagram whenChanged: [ tab label: aDiagram name ].
			editor paletteModel rebuildWidget.
			w ];
		whenTabSelected: [ topToolbar activeEditor: editor ].
	tabManager addTab: tab