as yet unclassified
openEditorOn: aDiagram
	| editor tab |
	(editor := DCEditor new) workbench: self.
	(tab := self newTab)
		label: aDiagram name;
		retrievingBlock: editor buildWithSpec asWidget.
	tabManager addTab: tab.
	editor openDiagram: aDiagram.
	editor rebuildWidget.
	"	aDiagram whenChanged: [ tab label: aDiagram name ]."
	editor paletteModel rebuildWidget