opening
openEditorOn: aDiagram
	| editor tab |
	(editor := DCEditor new) workbench: self.
	editor buildWithSpec.
	(tab := self newTab)
		label: aDiagram name;
		icon: (self iconForDiagram: aDiagram className asSymbol);
		retrievingBlock: editor buildWithSpec asWidget.
	tabManager addTab: tab.
	editor openDiagram: aDiagram.
	editor rebuildWidget.
	"	aDiagram whenChanged: [ tab label: aDiagram name ]."
	editor paletteModel rebuildWidget