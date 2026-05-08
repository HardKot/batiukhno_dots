# Autocompletion for rmt utility (and rm via alias)

# Standard rm compatibility
complete -c rmt -s r -l recursive -d "Remove directories and their contents recursively"
complete -c rmt -s f -l force -d "Ignore nonexistent files and arguments, never prompt"
complete -c rmt -s i -d "Prompt before every removal"
complete -c rmt -s I -d "Prompt once before removing more than three files"
complete -c rmt -s d -l dir -d "Remove empty directories"
complete -c rmt -s v -l verbose -d "Explain what is being done"

# Unique rmt (trash) functions
complete -c rmt -l destroy -d "Delete permanently (bypass trash)"
complete -c rmt -l td -d "Open trash manager CLI"
complete -c rmt -l ti -d "Show trash information"
complete -c rmt -l tf -d "Flush all elements from the trash"

# Forward completions to our rm alias
complete -c rm -w rmt