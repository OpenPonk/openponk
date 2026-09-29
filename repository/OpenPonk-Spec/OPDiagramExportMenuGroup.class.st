"
A Commander 1 menu group that aggregates graphical export options (PNG, SVG, PDF) within diagram menus.
"
Class {
	#name : 'OPDiagramExportMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
}

{ #category : 'accessing' }
OPDiagramExportMenuGroup >> iconName [
	"Answers the icon name for the submenu item."
	^ #smallScreenshot
]

{ #category : 'accessing' }
OPDiagramExportMenuGroup >> name [
	"Answers the display name of the menu group."
	^ 'Export diagram as...'
]

{ #category : 'accessing' }
OPDiagramExportMenuGroup >> order [
	"Answers the order priority within the parent menu."
	^ 300
]
