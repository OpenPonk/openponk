"
Verifies column calculation, row summation formulas, and CSV formatting of download statistics without requiring network access.
"
Class {
	#name : 'OPDownloadStatsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-DevTools-Tests',
	#package : 'OpenPonk-DevTools',
	#tag : 'Tests'
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
