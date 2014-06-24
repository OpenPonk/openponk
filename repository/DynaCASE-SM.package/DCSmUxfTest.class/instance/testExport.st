as yet unclassified
testExport
	| builder director diagram stream layouter layoutModel layout |
	diagram := self createDiagram1.
	layouter := DCSmGridLayoutGenerator new
		model: diagram;
		width: 2;
		cellSize: 100 @ 50.
	layoutModel := layouter generateLayout.
	layout := layoutModel layout.
	builder := DCSmUxfBuilder new.
	director := DCSmExportDirector new.
	stream := '/tmp/export.uxf' asFileName writeStream.
	director export: layout toStream: stream using: builder