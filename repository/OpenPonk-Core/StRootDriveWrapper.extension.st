Extension { #name : 'StRootDriveWrapper' }

{ #category : '*OpenPonk-Core' }
StRootDriveWrapper >> directories [
	"We catch errors because we might not have the rights on the drives and in that case we will get an error.
	This mecanism should probably be generalized."

	^ [ (fileReference basename , '\') asFileReference directories ]
		  on: FileSystemError
		  do: [
			  self inform: 'Missing permissions on ' , fileReference basename.
			  #(  ) ]
]
