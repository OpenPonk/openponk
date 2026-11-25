"
Verifies column calculation, row summation formulas, and CSV formatting of download statistics without requiring network access.
"
Class {
	#name : 'OPDownloadStatsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-DevTools-Tests-Releases',
	#package : 'OpenPonk-DevTools-Tests',
	#tag : 'Releases'
}

{ #category : 'tests' }
OPDownloadStatsTest >> testColumnCountsAndLetters [

	self assert: OPDownloadStats nonPlatformColumns equals: 2.
	self assert: OPDownloadStats platformColumns equals: OPDownloadStats platforms size.
	self assert: OPDownloadStats resultColumns equals: OPDownloadStats nonPlatformColumns + OPDownloadStats platformColumns.
	self assertCollection: OPDownloadStats resultPlatformColumnLetters hasSameElements: 'CDEF'
]

{ #category : 'tests' }
OPDownloadStatsTest >> testPrintRowSumOfToStream [
	| formula |
	formula := String streamContents: [ :stream |
		OPDownloadStats printRowSumOf: 5 to: stream ].
	self assert: formula equals: '=SUMA(C5:F5)'
]

{ #category : 'tests' }
OPDownloadStatsTest >> testResultPlatformColumnLettersLazyInitialization [

	| previousLetters computedLetters |
	previousLetters := OPDownloadStats instVarNamed: #resultPlatformColumnLetters.
	[
		OPDownloadStats instVarNamed: #resultPlatformColumnLetters put: nil.
		computedLetters := OPDownloadStats resultPlatformColumnLetters.
		self assertCollection: computedLetters hasSameElements: 'CDEF' ] ensure: [
		OPDownloadStats instVarNamed: #resultPlatformColumnLetters put: previousLetters ]
]

{ #category : 'tests' }
OPDownloadStatsTest >> testSelectYearDictionariesIncludesTargetYearAndFirstNextYearEntry [

	| entries selected selectedWithoutNext |
	entries := {
		           (Dictionary newFrom: { (#name -> '2026-06-01T120000.csv') }).
		           (Dictionary newFrom: { (#name -> '2025-12-31T235959.csv') }).
		           (Dictionary newFrom: { (#name -> '2026-01-15T100000.csv') }).
		           (Dictionary newFrom: { (#name -> '2027-02-01T000000.csv') }).
		           (Dictionary newFrom: { (#name -> '2027-01-01T000000.csv') }) }.
	selected := OPDownloadStats selectYearDictionaries: entries forYear: 2026.
	self
		assert: (selected collect: [ :each | each at: #name ] as: Array)
		equals: #( '2026-01-15T100000.csv' '2026-06-01T120000.csv' '2027-01-01T000000.csv' ).

	selectedWithoutNext := OPDownloadStats selectYearDictionaries: entries forYear: 2027.
	self
		assert: (selectedWithoutNext collect: [ :each | each at: #name ] as: Array)
		equals: #( '2027-01-01T000000.csv' '2027-02-01T000000.csv' )
]

{ #category : 'tests' }
OPDownloadStatsTest >> testTimestampStringFromFileNameHandlesColonAndCompactFormats [

	self assert: (OPDownloadStats timestampStringFromFileName: '2026-09-28T20:42:56.csv') equals: '2026-09-28 20:42:56'.
	self assert: (OPDownloadStats timestampStringFromFileName: '2026-09-28T204256.csv') equals: '2026-09-28 20:42:56'
]

{ #category : 'tests' }
OPDownloadStatsTest >> testWriteCSVToTimeIndexToStreamWithRealReleaseFileNames [
	| sampleCsv output |
	sampleCsv := String streamContents: [ :stream |
		stream << 'name,created_at,download_count'.
		stream lf.
		stream << 'openponk-class-editor-linux-nightly.zip,2026-09-28T19:08:54Z,5'.
		stream lf.
		stream << 'openponk-class-editor-mac-intel-nightly.zip,2026-09-28T19:08:51Z,3'.
		stream lf.
		stream << 'openponk-class-editor-mac-arm-nightly.zip,2026-09-28T19:08:55Z,7'.
		stream lf.
		stream << 'openponk-class-editor-win-nightly.zip,2026-09-28T19:08:52Z,10' ].
	output := String streamContents: [ :stream |
		OPDownloadStats
			writeCSV: sampleCsv
			toTime: '2026-09-28 20:42:56'
			index: 1
			toStream: stream ].
	self
		assert: output
		equals: '2026-09-28 19:08:54;2026-09-28 20:42:56;5;3;7;10;=SUMA(C2:F2)'
]

{ #category : 'tests' }
OPDownloadStatsTest >> testWriteFromDictionariesWithCsvProviderToStream [

	| dictionaries csvByUrl output expected |
	dictionaries := {
		                (Dictionary newFrom: {
				                 (#name -> '2026-01-10T08:15:30.csv').
				                 (#download_url -> 'url1') }).
		                (Dictionary newFrom: {
				                 (#name -> '2026-02-10T092045.csv').
				                 (#download_url -> 'url2') }) }.
	csvByUrl := Dictionary newFrom: {
			            ('url1' -> (String streamContents: [ :stream |
					              stream << 'openponk-linux.zip,2026-01-01T10:00:00Z,2'.
					              stream lf.
					              stream << 'openponk-win.zip,2026-01-01T10:00:00Z,5' ])).
			            ('url2' -> (String streamContents: [ :stream |
					              stream << 'openponk-mac-intel.zip,2026-02-01T11:30:00Z,3'.
					              stream lf.
					              stream << 'openponk-mac-arm.zip,2026-02-01T11:30:00Z,4' ])) }.
	output := String streamContents: [ :stream |
			          OPDownloadStats
				          writeFromDictionaries: dictionaries
				          repo: 'BPMN'
				          csvProvider: [ :url | csvByUrl at: url ]
				          toStream: stream ].
	expected := String streamContents: [ :stream |
			            stream << 'from;to;linux;mac-intel;mac-arm;win'.
			            stream lf.
			            stream << '2026-01-01 10:00:00;2026-01-10 08:15:30;2;0;0;5;=SUMA(C2:F2)'.
			            stream lf.
			            stream << '2026-02-01 11:30:00;2026-02-10 09:20:45;0;3;4;0;=SUMA(C3:F3)'.
			            stream lf.
			            stream << 'BPMN;;=SUMA(C2:C3);=SUMA(D2:D3);=SUMA(E2:E3);=SUMA(F2:F3);=SUMA(C4:F4)' ].
	self assert: output equals: expected
]

{ #category : 'tests' }
OPDownloadStatsTest >> testWriteItemsByLinesPlatformToStream [
	| itemsByLines output |
	itemsByLines := #(
		#('openponk-linux.zip' '2026-01-01T10:00:00Z' '12')
		#('openponk-win.zip' '2026-01-01T10:00:00Z' '30')
		#('openponk-linux-extra.zip' '2026-01-01T10:00:00Z' '8')
	).
	output := String streamContents: [ :stream |
		OPDownloadStats
			writeItemsByLines: itemsByLines
			platform: 'linux'
			toStream: stream ].
	self assert: output equals: '20'
]

{ #category : 'tests' }
OPDownloadStatsTest >> testWriteSummaryFormulaForRepoToStream [

	| formula |
	formula := String streamContents: [ :stream | OPDownloadStats writeSummaryFormulaForRepo: 'BPMN' entryCount: 12 toStream: stream ].
	self assert: formula equals: '=''dls-BPMN.csv''!$A$14:$G$14'
]
