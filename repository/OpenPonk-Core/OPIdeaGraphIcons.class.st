Class {
	#name : #OPIdeaGraphIcons,
	#superclass : #Object,
	#classVars : [
		'icons'
	],
	#category : #'OpenPonk-Core-Icons'
}

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> actualZoomIcon [
	"Private - Generated method"
	^ self icons
		at: #actualZoomIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self actualZoomIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> actualZoomIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\actualZoom.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA20lEQVR42sWTMQrCMBSGg9i6
OLh7A6+hqLPeQrAeQeeCpXge9w4d6qa46g3q4GT8I39LGhMiOjh8kP68fuT1vQoppfgFEcex
TggikIGSZMxCvbYWTHf7Fwj7oADSQcGadwGCFhiCOZiwMAAdMABnSg7MGoINkETJAkvWAydK
lrYW6mKwNjNee0ZB5hNIh6BLwd0nEB5B+ZcW1Ec8UhDp+6CPccQxjjnGtjbGagJXkDYE2oNv
kS7gwXNiE1SrvAI5uJGcWWoIE5vAR2JKPvrjHBLVzuIbgWKrXlbnJ91wOP9wZ6i6AAAAAElF
TkSuQmCC'
]

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> exportIcon [
	"Private - Generated method"
	^ self icons
		at: #exportIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self exportIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> exportIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\export.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABP0lEQVR42mP4//8/Awh3dXXh
xXpT7IX0pzlu05viIAPiw/QxIBnwHwc+U9vd4Gkyx/OU5WK//yZzPS7pTLbnJ9aAMy1dba4m
s7x2Wa8K/e+4Ofa/zeqw/4Zz3PdqTbRjw2UA3NnqfdaMutOdlpgvC/zvANTsvCPxv8OW2P8W
y4P+6053XgKSx2uA5hSHdqPFvv+tN0T+t9sa999+W/x/eyAN4oPEQfJ4DUDGlhuj/ltvifkP
ogkFIlYDjFYG/jffGPEfRJNlgM5iry9G64L/6yzxIt0A+V4zFs2Fbt/1V/v911ro9pZ0A3pM
gjTmO/3XWeH5X3Ou016SDJBq0bFTnGj6SmOhw3/NxU5fAybGZBFlgESDhqFUi/YsuV7DN8oz
LE+ozbNty+orTAIlLrICEYrPwNSQa8B/YgwgBlPPAABeEDpGXrZK1gAAAABJRU5ErkJggg=='
]

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> fitContentIcon [
	"Private - Generated method"
	^ self icons
		at: #fitContentIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self fitContentIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> fitContentIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\fitContent.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAdklEQVR42mP4//8/AyUYTERG
Rv4nB6MbwEAiJmzA6prQ/+vqw1AwSIxYA/5v7wgGO3X/hDA4hooRNADM39Hm9f/wRF8UDBIj
ZMB/ssMA6j9cfiZswOZm//+7ewJRMEiM1Fj4T41o/D/g0chASTSSnZTJz0yUYABuiwC/tz/3
ZwAAAABJRU5ErkJggg=='
]

{ #category : #'GT-InspectorExtensions' }
OPIdeaGraphIcons class >> gtInspectorIconsIn: composite [
	<gtInspectorPresentationOrder: 0>
	<script: 'self inspect'>
	composite table
		title: 'Icons';
		display: [ (self class selectorsInCategory: 'accessing - icons') sorted
				collect: [ :each | each -> (self perform: each) ] ];
		column: 'Icon' evaluated: #value width: 50;
		column: 'Selector' evaluated: #key
]

{ #category : #accessing }
OPIdeaGraphIcons class >> icons [
	^ icons ifNil: [ icons := Dictionary new ]
]

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> layoutIcon [
	"Private - Generated method"
	^ self icons
		at: #layoutIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self layoutIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> layoutIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\layout.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA6UlEQVR42mP4//8/AyWYITIy
EiteXRP6f119GE4MksdmQBEQvwTiAzu7w/8fmhKJE4Pk0Q1IBOLHQGwC4u/rC/l/clb4fyAb
TKNjkDy6AdeAOAjG39np+//IlACcGCSPbsAfIOaE8bc2uf0/0OuJE4PkQeqQDfiPK0DRsAAQ
bwVifpgB06CaYXgaHs3MQLwXqm4PiA8T3AMVBEmy4jFgKrplMAl+qLMEifQG3LtEJxokzZzQ
AIcYAIoKYhINkgFB0ChHGEBMooFqMIImtiRUFxCRaICK9wPxKyAuRQ4PsAHEJhpsmIHS7AwA
I+sBKc+7H3oAAAAASUVORK5CYII='
]

{ #category : #'accessing - reset' }
OPIdeaGraphIcons class >> resetIcons [
	<script>
	^ icons := nil
]

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> zoomInIcon [
	"Private - Generated method"
	^ self icons
		at: #zoomInIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self zoomInIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> zoomInIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\zoomIn.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA1UlEQVR42rWTPQ6CQBCFqbBR
Qu+FrPcYJuI9SCTE89hvQYEdxtobYKGN6xvzNllwUCKx+Mhm58232R8i51w0hdcnz3NPDDJg
QUss5+IgpwqWoAZugJoZVRAHzWdgQEIM56R2BDNNsGHgBNLV/hABR6SesuaYfRNYFg2bOwJK
DDNWE9xZTILGDqjNmblNFbR/2YI/xObDITbMZOF78IIZr8jfhKy2ICa4gQsoNcGYhyTND44L
TeAf1BZU4EoqzpU9YaEJvlH0JaP+uAGJbGf9i0DYSbOMn9sDVPxgE0dlAAAAAElFTkSuQmCC'
]

{ #category : #'accessing - icons' }
OPIdeaGraphIcons class >> zoomOutIcon [
	"Private - Generated method"
	^ self icons
		at: #zoomOutIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self zoomOutIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaGraphIcons class >> zoomOutIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\zoomOut.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAA1UlEQVR42rWTMQ6CQBBFqaBR
Yu+FrPcYJuI9SCTE89hvQYEdxtobYCGN6x/z12xwUCKxeGQz8+eRZZfIORdN4fnI89wTgwxY
0BLLWhzkVMES1MANUDOjCuJg+AwMSIlhTXpHkGiCDQMnsFjtD6+ArKXGnmP2TWDZNDLQF1Bi
mLGaoGMzRdhpoDdj5jZV0P5lC/4jNh8+YsNMFt4HL0h4RP4k5G1zYoITuIBSE4y5SDJ857rQ
BP5CbUEFrqRirewJC03wjaIvGfXHDUhkO+tfBMJOhmX9AGrrWDyXpM9CAAAAAElFTkSuQmCC'
]
