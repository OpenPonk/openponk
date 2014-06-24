as yet unclassified
testExport
	| builder director topLevelMachine |
	topLevelMachine := self createDiagram1.
	builder := DCSmDotBuilder new.
	director := DCSmExportDirector new.
	director export: topLevelMachine toFile: '/tmp/test.dot' using: builder