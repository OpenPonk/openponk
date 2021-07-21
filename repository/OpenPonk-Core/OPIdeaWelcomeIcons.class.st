Class {
	#name : #OPIdeaWelcomeIcons,
	#superclass : #Object,
	#classVars : [
		'icons'
	],
	#category : #'OpenPonk-Core-Icons'
}

{ #category : #'accessing - icons' }
OPIdeaWelcomeIcons class >> createNewProjectIcon [
	"Private - Generated method"
	^ self icons
		at: #createNewProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self createNewProjectIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaWelcomeIcons class >> createNewProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\createNewProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAfElEQVR42mNgwAMuTVLQBmJZ
BnIBUHMjCBOr2BLdNiD/BAijicmC1GIzACTxFIj7oWxtKP8pzCtQuac4vYWk4CnUdmzsfnze
kEVSiAvLEgr1E3g0g+S0sdnaSEAjNoMawa6h2ACKvUDtQCQ/GilOSBQnZYozEx5vaeNTAwCa
VyUU/OC4vAAAAABJRU5ErkJggg=='
]

{ #category : #'GT-InspectorExtensions' }
OPIdeaWelcomeIcons class >> gtInspectorIconsIn: composite [
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
OPIdeaWelcomeIcons class >> icons [
	^ icons ifNil: [ icons := Dictionary new ]
]

{ #category : #'accessing - icons' }
OPIdeaWelcomeIcons class >> importProjectIcon [
	"Private - Generated method"
	^ self icons
		at: #importProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self importProjectIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaWelcomeIcons class >> importProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\importProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAX0lEQVR42mNgIANMLV/Ox0Au
AGrWBuLrQBxGieanIJoizSA+IQ27YH4lWTNU01OoIZYENc9avuEMMkYyABnjtplIAyxxOpdI
A3bhjH8iDcBtCDYDSALoBmDDw90ASgAAsEIRZbX5U38AAAAASUVORK5CYII='
]

{ #category : #'accessing - icons' }
OPIdeaWelcomeIcons class >> openProjectIcon [
	"Private - Generated method"
	^ self icons
		at: #openProjectIcon
		ifAbsentPut: [ Form
				fromBinaryStream: (self openProjectIconContents base64Decoded asByteArray readStream) ]
]

{ #category : #'private - contents' }
OPIdeaWelcomeIcons class >> openProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\openProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAASklEQVR42mNgGB5g1vINm7Dg
FEoNAOF8Sg3AiWlmgDMlgTjn5mLnMCB+SgI+gWyAM0iARAPCYAaQbzvUAPJtBwGKbIcaQL7t
Aw4AGOxGhu4o5hAAAAAASUVORK5CYII='
]

{ #category : #'accessing - reset' }
OPIdeaWelcomeIcons class >> resetIcons [
	<script>
	^ icons := nil
]
