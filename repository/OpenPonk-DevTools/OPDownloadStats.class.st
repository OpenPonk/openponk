"
A release engineering utility that queries GitHub and GitLab APIs to compile OpenPonk download and release metrics.
"
Class {
	#name : 'OPDownloadStats',
	#superclass : 'Object',
	#classInstVars : [
		'resultPlatformColumnLetters'
	],
	#category : 'OpenPonk-DevTools-Releases',
	#package : 'OpenPonk-DevTools',
	#tag : 'Releases'
}

{ #category : 'processing' }
OPDownloadStats class >> downloadStats [

	<script>
	| repos year |
	repos := #( plugins 'borm-editor' BPMN 'class-editor' ERD 'fsm-editor' 'markov-chains' petrinets DEMO ).
	year := 2026.

	'dls.csv' asFileReference
		ensureDelete;
		writeStreamDo: [ :stream |
				repos do: [ :eachRepo |
							| dictionaries |
							dictionaries := self downloadStatsOfRepo: eachRepo year: year.
							self writeSummaryFormulaForRepo: eachRepo entryCount: dictionaries size toStream: stream.
							stream lf ] ]
]

{ #category : 'processing' }
OPDownloadStats class >> downloadStatsOfRepo: repo year: year [

	<script: 'self downloadStatsOfRepo: ''class-editor'' year: 2023'>
	| url fileName listResponse dictResponse yearDicts |
	url := String streamContents: [ :stream | stream << 'https://api.github.com/repos/OpenPonk/' << repo << '/contents/?ref=dls' ].
	listResponse := ZnClient new
		                url: url;
		                get.
	dictResponse := STONJSON fromString: listResponse.
	yearDicts := self selectYearDictionaries: dictResponse forYear: year.

	fileName := String streamContents: [ :stream | stream << 'dls-' << repo << '.csv' ].
	fileName asFileReference
		ensureDelete;
		writeStreamDo: [ :stream | self writeFromDictionaries: yearDicts repo: repo toStream: stream ].

	^ yearDicts
]

{ #category : 'processing' }
OPDownloadStats class >> getContentsOfLink: anUrl [

	^ ZnClient new
		  url: anUrl;
		  get
]

{ #category : 'result-columns' }
OPDownloadStats class >> nonPlatformColumns [

	^ 2
]

{ #category : 'result-columns' }
OPDownloadStats class >> platformColumns [

	^ self platforms size
]

{ #category : 'constants' }
OPDownloadStats class >> platforms [
	^ #( linux 'mac-intel' 'mac-arm' win )
]

{ #category : 'processing' }
OPDownloadStats class >> printRowSumOf: rowIndex to: s [

	s << '=SUMA(' << self resultPlatformColumnLetters first
	<< rowIndex asString << ':' << self resultPlatformColumnLetters last
	<< rowIndex asString << ')'
]

{ #category : 'result-columns' }
OPDownloadStats class >> resultColumns [
	^ self nonPlatformColumns + self platformColumns
]

{ #category : 'result-columns' }
OPDownloadStats class >> resultPlatformColumnLetters [

	^ resultPlatformColumnLetters ifNil: [
		  resultPlatformColumnLetters := (self nonPlatformColumns to:
		                                  self resultColumns - 1) collect: [
			                                 :each |
			                                 Character value:
				                                 $A charCode + each ] ]
]

{ #category : 'processing' }
OPDownloadStats class >> selectYearDictionaries: dictionaries forYear: year [

	| sortedDictionaries yearDictionaries |
	sortedDictionaries := dictionaries sortedAs: [ :each | each at: #name ].
	yearDictionaries := (sortedDictionaries select: [ :each | (each at: #name) beginsWith: year asString ]) asOrderedCollection.
	sortedDictionaries
		detect: [ :any | (any at: #name) beginsWith: (year + 1) asString ]
		ifFound: [ :nextYearEntry | yearDictionaries add: nextYearEntry ].
	^ yearDictionaries
]

{ #category : 'constants' }
OPDownloadStats class >> separator [

	^ ';'
]

{ #category : 'processing' }
OPDownloadStats class >> timestampStringFromFileName: fileName [

	^ String streamContents: [ :timestampStream |
			  timestampStream << (fileName first: 10) << ' '.
			  (fileName includes: $:)
				  ifTrue: [ timestampStream << (fileName copyFrom: 12 to: 19) ]
				  ifFalse: [
						  timestampStream << (fileName copyFrom: 12 to: 13) << ':' << (fileName copyFrom: 14 to: 15) << ':'
						  << (fileName copyFrom: 16 to: 17) ] ]
]

{ #category : 'processing' }
OPDownloadStats class >> writeCSV: csv toTime: to index: i toStream: s [

	| lines itemsByLines fromIso from |
	lines := csv lines select: [ :eachLine | eachLine beginsWith: 'open' ].
	itemsByLines := lines collect: [ :each | each splitOn: ',' ].
	fromIso := itemsByLines anyOne second.
	from := String streamContents: [ :ss |
		        ss << (fromIso first: 10) << ' '
		        << (fromIso copyFrom: 12 to: 19) ].
	s << from << self separator << to << self separator.
	self platforms do: [ :eachPlatform |
		self
			writeItemsByLines: itemsByLines
			platform: eachPlatform
			toStream: s.
		s << self separator ].
	self printRowSumOf: i + 1 to: s
]

{ #category : 'processing' }
OPDownloadStats class >> writeFromDictionaries: dictionaries repo: repo csvProvider: csvBlock toStream: stream [

	| lastRow sumRow |
	stream << 'from' << self separator << 'to' << self separator.
	self platforms do: [ :eachPlatform | stream << eachPlatform ] separatedBy: [ stream << self separator ].
	stream lf.

	dictionaries withIndexDo: [ :each :index |
			self
				writeFromDictionary: each
				csv: (csvBlock value: (each at: #download_url))
				index: index
				toStream: stream.
			stream lf ].

	lastRow := dictionaries size + 1.
	sumRow := lastRow + 1.

	stream << repo << self separator << self separator.
	self resultPlatformColumnLetters do: [ :columnLetter |
		stream << '=SUMA(' << columnLetter << '2:' << columnLetter << lastRow asString << ')' << self separator ].
	self printRowSumOf: sumRow to: stream
]

{ #category : 'processing' }
OPDownloadStats class >> writeFromDictionaries: dictionaries repo: repo toStream: stream [

	self
		writeFromDictionaries: dictionaries
		repo: repo
		csvProvider: [ :link | self getContentsOfLink: link ]
		toStream: stream
]

{ #category : 'processing' }
OPDownloadStats class >> writeFromDictionary: dictionary csv: csv index: index toStream: stream [

	| toTimestamp |
	toTimestamp := self timestampStringFromFileName: (dictionary at: #name).
	self
		writeCSV: csv
		toTime: toTimestamp
		index: index
		toStream: stream
]

{ #category : 'processing' }
OPDownloadStats class >> writeFromDictionary: dictionary index: index toStream: stream [

	| csv |
	csv := self getContentsOfLink: (dictionary at: #download_url).
	self
		writeFromDictionary: dictionary
		csv: csv
		index: index
		toStream: stream
]

{ #category : 'processing' }
OPDownloadStats class >> writeItemsByLines: itemsByLines platform: platform toStream: s [

	| sum |
	sum := itemsByLines sumNumbers: [ :items |
		       (items first includesSubstring: platform)
			       ifTrue: [ items third asInteger ]
			       ifFalse: [ 0 ] ].
	s << sum asString
]

{ #category : 'processing' }
OPDownloadStats class >> writeSummaryFormulaForRepo: repo entryCount: entryCount toStream: stream [

	| rowNumber |
	rowNumber := (entryCount + 2) asString.
	stream << '=''dls-' << repo << '.csv''!$A$' << rowNumber << ':$' << (Character value: $A charCode + self resultColumns) << '$'
	<< rowNumber
]
