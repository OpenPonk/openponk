opening
openEditorOn: aDiagram
	| editor tab |
	(editor := DCEditor new) workbench: self.
	editor buildWithSpec.
	(tab := self newTab)
		label: aDiagram name;
		icon: ((pluginRegistry pluginFor: aDiagram) icon);
		retrievingBlock: editor buildWithSpec asWidget.
	tabManager addTab: tab.
	editor openDiagram: aDiagram.
	editor rebuildWidget.
	aDiagram whenChanged: [ tab label: aDiagram name ].
	editor paletteModel rebuildWidget