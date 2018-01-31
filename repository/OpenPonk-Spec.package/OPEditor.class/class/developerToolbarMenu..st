toolbar
developerToolbarMenu: aBuilder
	<opEditorToolbarMenu>
	| editor |
	OPWorkbench isDevelopmentMode
		ifFalse: [ ^ self ].
	editor := aBuilder model.
	(aBuilder item: 'Inspect Controller...') action: [ editor diagramController inspect ].
	(aBuilder item: 'Export as PNG...') action: [ editor canvasModel exportAsPng ].
	aBuilder withSeparatorAfter