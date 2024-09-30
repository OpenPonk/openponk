Class {
	#name : 'OPIdeaWelcomeIcons',
	#superclass : 'OPIcons',
	#category : 'OpenPonk-Core-Icons',
	#package : 'OpenPonk-Core',
	#tag : 'Icons'
}

{ #category : 'accessing - icons' }
OPIdeaWelcomeIcons class >> createNewProjectIcon [

	^ Form fromBinaryStream: self createNewProjectIconContents base64Decoded asByteArray readStream
]

{ #category : 'private - contents' }
OPIdeaWelcomeIcons class >> createNewProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\createNewProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAfElEQVR42mNgwAMuTVLQBmJZ
BnIBUHMjCBOr2BLdNiD/BAijicmC1GIzACTxFIj7oWxtKP8pzCtQuac4vYWk4CnUdmzsfnze
kEVSiAvLEgr1E3g0g+S0sdnaSEAjNoMawa6h2ACKvUDtQCQ/GilOSBQnZYozEx5vaeNTAwCa
VyUU/OC4vAAAAABJRU5ErkJggg=='
]

{ #category : 'accessing - icons' }
OPIdeaWelcomeIcons class >> importProjectIcon [

	^ Form fromBinaryStream: self importProjectIconContents base64Decoded asByteArray readStream
]

{ #category : 'private - contents' }
OPIdeaWelcomeIcons class >> importProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\importProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAX0lEQVR42mNgIANMLV/Ox0Au
AGrWBuLrQBxGieanIJoizSA+IQ27YH4lWTNU01OoIZYENc9avuEMMkYyABnjtplIAyxxOpdI
A3bhjH8iDcBtCDYDSALoBmDDw90ASgAAsEIRZbX5U38AAAAASUVORK5CYII='
]

{ #category : 'accessing - icons' }
OPIdeaWelcomeIcons class >> openProjectIcon [

	^ Form fromBinaryStream: self openProjectIconContents base64Decoded asByteArray readStream
]

{ #category : 'private - contents' }
OPIdeaWelcomeIcons class >> openProjectIconContents [
	"Private - Method generated with the content of the file File @ D:\OpenPonk\icons\idea\welcome\openProject.png"
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAASklEQVR42mNgGB5g1vINm7Dg
FEoNAOF8Sg3AiWlmgDMlgTjn5mLnMCB+SgI+gWyAM0iARAPCYAaQbzvUAPJtBwGKbIcaQL7t
Aw4AGOxGhu4o5hAAAAAASUVORK5CYII='
]
