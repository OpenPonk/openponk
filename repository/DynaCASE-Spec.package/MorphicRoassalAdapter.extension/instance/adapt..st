*DynaCASE-Spec
adapt: aComposableModel
|pane|
	super adapt: aComposableModel.
	
	view := widget.
	canvas := view setUpCanvas.
	widget := canvas buildMorph.
	widget
		setProperty: #model toValue: self;
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	pane:=ScrollPane new.
	pane scroller addMorph: (widget extent: 1000@1000).
	widget:=pane.
	widget 
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	
	
	self basicApplyScript
	