opening
openEditorOn: aDiagram
	| editor tab plugin |
	(editor := DCEditor new) workbench: self.
	editor buildWithSpec.
	plugin := pluginRegistry pluginFor: aDiagram.
	(tab := self newTab)
		label: aDiagram name;
		icon: plugin icon;
		retrievingBlock:
				[ 
			| w |
			w := editor buildWithSpec asWidget.
			editor owner: tab.
			editor plugin: plugin.
			editor openDiagram: aDiagram.
			aDiagram whenChanged: [ tab label: aDiagram name ].
			editor paletteModel rebuildWidget.
			editor canvasMenuModel rebuildWidget.
			w ].
	tabManager addTab: tab