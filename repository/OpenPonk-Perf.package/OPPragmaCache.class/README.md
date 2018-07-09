I cache commonly used PragmaCollector filters. I can be enabled/disabled at runtime.

# Perf test

ed := OPEditor new.

collector := PragmaCollector filter: [ :prg |
	(#(opEditorToolbarMenu) includes: prg keyword) and: [ prg methodSelector numArgs = 1 ] ].
collector reset.

[ 
builder := PragmaMenuBuilder pragmaKeyword: #opEditorToolbarMenu model: ed.
builder pragmaCollector: collector.
builder menuSpec
] benchFor: 2 seconds.
"a BenchmarkResult(114,305 iterations in 2 seconds 558 milliseconds. 44,685 per second)"

[ col := (PragmaMenuBuilder pragmaKeyword: #opEditorToolbarMenu model: ed) reset.
col menuSpec	
] benchFor: 2 seconds.
"a BenchmarkResult(52 iterations in 2 seconds 27 milliseconds. 25.654 per second)"