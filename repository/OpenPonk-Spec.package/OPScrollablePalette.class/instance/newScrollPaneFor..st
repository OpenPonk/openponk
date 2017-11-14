instance creation
newScrollPaneFor: aForm
	| scrollpane |
	scrollpane := GeneralScrollPane new.
	scrollpane changeScrollerTableLayout.
	aForm buildWithSpec.
	"	aForm rebuildWidget."
	scrollpane scrollTarget: aForm widget widget.
	scrollpane
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ scrollpane