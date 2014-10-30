private
cleanView
	"roassalView cleanAll is unusable because it breaks (maybe) misused TRRemoveCallbacks"

	roassalView edges copy do: #remove.
	roassalView elements copy do: #remove.
	roassalView canvas clean