Class {
	#name : #OPTRPharoPlatform,
	#superclass : #TRPharoPlatform,
	#instVars : [
		'fontCache',
		'widthsCache'
	],
	#category : 'OpenPonk-Trachel'
}

{ #category : #testing }
OPTRPharoPlatform class >> beCurrent [
	<script>
	TRPlatform current: self new
]

{ #category : #testing }
OPTRPharoPlatform class >> isActivePlatform [
	^ true
]

{ #category : #fonts }
OPTRPharoPlatform >> defaultFamilyFontName [
	"the parent method is extremely expensive, so just pick a font a go with it

perf:	
[ RTLabel new ] benchFor: 2 seconds.
""a BenchmarkResult(191,509 iterations in 2 seconds 3 milliseconds. 95,611 per second)"".
[ RTLabel new ] benchFor: 2 seconds.
""a BenchmarkResult(9,460,274 iterations in 2 seconds 3 milliseconds. 4,723,052 per second)""
	"

	^ StandardFonts listFont familyName
]

{ #category : #fonts }
OPTRPharoPlatform >> fontCache [
	^ fontCache ifNil: [ fontCache := Dictionary new ]
]

{ #category : #fonts }
OPTRPharoPlatform >> fontFamilyName: name pointSize: number [
	"[ TRPlatform current fontFamilyName: 'Source Sans Pro' pointSize: 12 ] benchFor: 1 second.
""a BenchmarkResult(489,886 iterations in 1 second 2 milliseconds. 488,908 per second)""

[ TRPlatform current fontFamilyName: 'Source Sans Pro' pointSize: 12 ] benchFor: 1 second.
""a BenchmarkResult(2,972,218 iterations in 1 second 1 millisecond. 2,969,249 per second)"""

	^ (self fontCache at: name ifAbsentPut: [ Dictionary new ])
		at: number
		ifAbsentPut: [ LogicalFont familyName: name pointSize: number ]
]

{ #category : #fonts }
OPTRPharoPlatform >> resetFontCache [
	<script: 'self current resetFontCache'>
	fontCache := nil
]

{ #category : #fonts }
OPTRPharoPlatform >> resetWidthsCache [
	<script: 'self basicNew resetWidthsCache'>
	widthsCache := nil
]

{ #category : #fonts }
OPTRPharoPlatform >> widthOfString: string font: font [
	^ (self widthsCache at: string ifAbsentPut: [ Dictionary new ])
		at: font
		ifAbsentPut: [ self logCr: 'cache miss @ ' , string.
			font widthOfString: string ]
]

{ #category : #fonts }
OPTRPharoPlatform >> widthsCache [
	^ widthsCache ifNil: [ widthsCache := Dictionary new ]
]
