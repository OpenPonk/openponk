Extension { #name : #WindowsResolver }

{ #category : #'*OpenPonk-Spec' }
WindowsResolver >> home [

	"Value of the $USERPROFILE environment variable. If HOME_PATH is set, use this (FIT CTU specific)"

	^ self
		  directoryFromEnvVariableNamed: 'HOME_PATH'
		  or: [ self directoryFromEnvVariableNamed: 'USERPROFILE' ]
]
