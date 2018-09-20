"
I am fired whenever a connection handle has moved.

!! Purpose

Since handles are added and removed dynamically during runtime it's hard to attach TRTranslationCallback to handles.
"
Class {
	#name : #OPRTHandleMoved,
	#superclass : #Announcement,
	#category : 'OpenPonk-Roassal2-Connection'
}
