Class {
	#name : 'OPDownloadStats',
	#superclass : 'Object',
	#classInstVars : [
		'resultPlatformColumnLetters'
	],
	#category : 'OpenPonk-Releaser',
	#package : 'OpenPonk-Releaser'
}

{ #category : 'processing' }
OPDownloadStats class >> downloadStats [

	<script>
	| repos year |
	repos := #( plugins 'borm-editor' BPMN 'class-editor' ERD 'fsm-editor'
	            'markov-chains' petrinets ).
	year := 2023.

	'dls.csv' asFileReference
		ensureDelete;
		writeStreamDo: [ :s |
			repos do: [ :each |
					| dictionaries |
					dictionaries := self downloadStatsOfRepo: each year: year.
					s << '=''dls' << '-' << each << '.csv''!$A$'
					<< (dictionaries size + 2) asString << ':$'
					<< (Character value: $A charCode + self resultColumns) << '$'
					<< (dictionaries size + 2) asString.
					s lf ] ]
]

{ #category : 'processing' }
OPDownloadStats class >> downloadStatsOfRepo: repo year: year [

	<script: 'self downloadStatsOfRepo: ''class-editor'' year: 2023'>
	| listResponse dictResponse listDicts yearDicts |
	listResponse := ZnClient new
		                url:
			                'https://api.github.com/repos/OpenPonk/' , repo
			                , '/contents/?ref=dls';
		                get.
	dictResponse := STONJSON fromString: listResponse.
	listDicts := dictResponse sortedAs: [ :each | each at: #name ].
	yearDicts := (listDicts select: [ :each |
		              (each at: #name) beginsWith: year asString ])
		             asOrderedCollection.

	listDicts
		detect: [ :any | (any at: #name) beginsWith: (year + 1) asString ]
		ifFound: [ :newYearOne | yearDicts add: newYearOne ].

	('dls-' , repo , '.csv') asFileReference
		ensureDelete;
		writeStreamDo: [ :s |
			self writeFromDictionaries: yearDicts repo: repo toStream: s ].

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

	^ #( linux mac 'mac-ARM' win )
]

{ #category : 'processing' }
OPDownloadStats class >> printRowSumOf: rowIndex to: s [

	s << '=SUMA(' << self resultPlatformColumnLetters first
	<< rowIndex asString << ':' << self resultPlatformColumnLetters last
	<< rowIndex asString << ')'
]

{ #category : 'result-columns' }
OPDownloadStats class >> resultColumns [

	^ 2 + self platforms size
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

{ #category : 'constants' }
OPDownloadStats class >> separator [

	^ ';'
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
OPDownloadStats class >> writeFromDictionaries: dictionaries repo: repo toStream: s [

	| lastRow sumRow |
	s << 'from' << self separator << 'to' << self separator.
	self platforms asStringOn: s delimiter: self separator.
	s lf.

	dictionaries withIndexDo: [ :each :index |
		self writeFromDictionary: each index: index toStream: s.
		s lf ].

	lastRow := dictionaries size + 1.
	sumRow := lastRow + 1.

	s << repo << self separator << self separator.
	self resultPlatformColumnLetters do: [ :col |
		s << '=SUMA(' << col << '2:' << col << '' << lastRow asString << ')'
		<< self separator ].
	self printRowSumOf: sumRow to: s
]

{ #category : 'processing' }
OPDownloadStats class >> writeFromDictionary: dictionary index: i toStream: s [

	| link fileName to csv |
	link := dictionary at: #download_url.
	fileName := dictionary at: #name.
	to := String streamContents: [ :toTimestampStream |
		      toTimestampStream << (fileName first: 10) << ' '.
		      (fileName includes: $:)
			      ifTrue: [
			      toTimestampStream << (fileName copyFrom: 12 to: 19) ]
			      ifFalse: [
				      toTimestampStream << (fileName copyFrom: 12 to: 13) << ':'
				      << (fileName copyFrom: 14 to: 15) << ':'
				      << (fileName copyFrom: 16 to: 17) ] ].

	csv := self getContentsOfLink: link.

	self
		writeCSV: csv
		toTime: to
		index: i
		toStream: s
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
