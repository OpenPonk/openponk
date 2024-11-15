Extension { #name : 'StFileBrowserBookmark' }

{ #category : '*OpenPonk-Core' }
StFileBrowserBookmark class >> defaultBookmarks [

	| presets |
	self flag: 'Remove (let NewTools to replace it) in Pharo 13'.
	presets := {
		           self home.
		           self workingDirectory.
		           self desktop.
		           self documents.
		           self downloads }.

	^ OrderedCollection with: (StFileBrowserGroupBookmark
			   name: 'Bookmarks'
			   collection: presets
			   iconName: #book)
]

{ #category : '*OpenPonk-Core' }
StFileBrowserBookmark class >> root [

	self flag: 'Remove in Pharo 13'.
	^ self
		  name: '/'
		  location: FileLocator root
		  icon: (self iconNamed: #smallWindow)
]

{ #category : '*OpenPonk-Core' }
StFileBrowserBookmark class >> windowsDrives [

	self flag: 'Remove in Pharo 13'.
	^ FileLocator root asFileReference directories collect: [ :each |
		  self
			  name: each basename
			  location: each
			  icon: (self iconNamed: #smallWindow) ]
]
