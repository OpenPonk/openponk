Class {
	#name : #OPIdeaActionsIcons,
	#superclass : #OPIcons,
	#category : #'OpenPonk-Core-Icons'
}

{ #category : #'accessing - icons' }
OPIdeaActionsIcons class >> propertiesIcon [

	^ Form fromBinaryStream: self propertiesIconContents base64Decoded asByteArray readStream
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
