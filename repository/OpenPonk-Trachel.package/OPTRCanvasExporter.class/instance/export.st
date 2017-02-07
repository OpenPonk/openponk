export
export
	"Makes the export itself. Repeatable last step of process. Do not change any settings after export has been made."

	self performFinalOperations.
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName value