Class {
	#name : #OPIdeaActionsIcons,
	#superclass : #Object,
	#classVars : [
		'icons'
	],
	#category : #'OpenPonk-Core-Icons'
}

{ #category : #'GT-InspectorExtensions' }
OPIdeaActionsIcons class >> gtInspectorIconsIn: composite [
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
OPIdeaActionsIcons class >> icons [
	^ icons ifNil: [ icons := Dictionary new ]
]

{ #category : #'accessing - icons' }
OPIdeaActionsIcons class >> propertiesIcon [
	"Private - Generated method"
	^ self icons
		at: #propertiesIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self propertiesIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaActionsIcons class >> propertiesIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\actions\properties.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAuUlEQVR42mP4//8/AyUYTERG
Rv6PiIz6D6KB+AwQl4dFRieIx7b+B2KGqqoqrBjFAJDiR48f/H/14sn/O/fvgfkVczcSb0D2
lNX/oTaaQ+klL58/gRnwHxtGMeDp00cgxcegmvcCvdAMcg3RBkAVSwHxBiDmRxIjzgvbtmyC
BSIcE20AUCEI/8eGcWnGcAE2jE8zhgHoNoO8RJILoBph3oGLQRUTFwu0NID8aAQZRjAz4YtG
ogygBAMA5Stta5h2zD4AAAAASUVORK5CYII='
]

{ #category : #'accessing - reset' }
OPIdeaActionsIcons class >> resetIcons [
	<script>
	^ icons := nil
]
