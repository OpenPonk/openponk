"
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
""a BenchmarkResult(114,305 iterations in 2 seconds 558 milliseconds. 44,685 per second)""

[ col := (PragmaMenuBuilder pragmaKeyword: #opEditorToolbarMenu model: ed) reset.
col menuSpec	
] benchFor: 2 seconds.
""a BenchmarkResult(52 iterations in 2 seconds 27 milliseconds. 25.654 per second)""
"
Class {
	#name : #OPPragmaCache,
	#superclass : #Object,
	#instVars : [
		'useCache',
		'collectors'
	],
	#classInstVars : [
		'current'
	],
	#category : #'OpenPonk-Perf'
}

{ #category : #accessing }
OPPragmaCache class >> current [
	^ current ifNil: [ current := self new ]
]

{ #category : #resetting }
OPPragmaCache class >> reset [
	<script>
	current := nil
]

{ #category : #initialization }
OPPragmaCache >> collectorForKeyword: aKeyword [
	useCache
		ifFalse: [ ^ self newCollectorForKeyword: aKeyword ].
	^ collectors at: aKeyword ifAbsentPut: [ self newCollectorForKeyword: aKeyword ]
]

{ #category : #initialization }
OPPragmaCache >> collectorForKeyword: aKeyword model: aModel [
	
]

{ #category : #configuration }
OPPragmaCache >> disableCache [
	useCache := false
]

{ #category : #initialization }
OPPragmaCache >> initialize [
	super initialize.
	self useCache.
	collectors := Dictionary new
]

{ #category : #initialization }
OPPragmaCache >> newCollectorForKeyword: aKeyword [
	^ (PragmaCollector
		filter:
			[ :prg | prg selector = aKeyword and: [ prg methodSelector numArgs = 1 ] ])
		reset;
		yourself
]

{ #category : #configuration }
OPPragmaCache >> useCache [
	useCache := true
]
