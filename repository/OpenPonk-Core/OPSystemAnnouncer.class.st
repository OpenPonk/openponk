"
I am a global announcer for OpenPonk and any Workbenches currently running.

I am a singleton.
"
Class {
	#name : #OPSystemAnnouncer,
	#superclass : #Announcer,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #initialization }
OPSystemAnnouncer class >> reset [
	<script>
	uniqueInstance := nil
]

{ #category : #accessing }
OPSystemAnnouncer class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
