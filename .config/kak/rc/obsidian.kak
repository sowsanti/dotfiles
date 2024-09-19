declare-option -hidden completions kaksidian
declare-option -hidden str ks_files ""

define-command -override is-obsidian-vault -docstring %{
	'is-obsidian-vault: informs the user weither the directory they are in is an Obsidian Vault'
} %{
	evaluate-commands %sh{
		filepth = "$PWD/.obsidian/workspace.json"
		if [! -f "$filepth"]; then
			echo 'echo -markup This is not an Obsidian Vault'
		else
			echo 'echo -markup This is an Obsidian Vault'
		fi
	}
}

set-face global KSLinkOuter bright-black
set-face global KSLinkInner cyan
set-face global KSWikiLinkOuter KSLinkOuter
set-face global KSWikiLinkInner KSLinkInner

hook global User ksload %{
  set-option window ks_files %sh{
    shopt -s globstar
    final=""
    for i in **/*.md; do # Whitespace-safe and recursive
    	filename=$(basename "$i")
    	filename=$(echo $filename | sed -e "s/\.md//")
    	final="$final$filename,"
    done
    echo $final
  }

  #completion
  #==========
  set-option global completers option=kaksidian %opt{completers}
  hook global InsertIdle .* %{
    try %{
      execute-keys -draft 2b s \A\[\[\z<ret>

      evaluate-commands -draft %{
        execute-keys h <a-i>w <a-semicolon>
        set-option window kaksidian "%val{cursor_line}.%val{cursor_column}+%val{selection_length}@%val{timestamp}"
      }

      evaluate-commands %sh{
        IFS=","
        for i in $kak_opt_ks_files; do
          completion="\"$i]]||$i {MenuInfo}Note\""
          echo "set-option -add window kaksidian $completion"
        done
      }
    } catch %{
      set-option window kaksidian
    }
  }

  #highlighting
  #============
  add-highlighter buffer/kaksidian group
  #TODO: check if wiki link exists before underline
  add-highlighter buffer/kaksidian/wikilink regex (\[\[([^\n]*)\]\]) 1:KSWikiLinkOuter 2:+u@KSWikiLinkInner
  add-highlighter buffer/kaksidian/link regex (\[([^\n]*)\])(\(([^\n]*)\)) 1:KSWikiLinkOuter 2:KSWikiLinkInner 3:KSLinkOuter 4:+u@KSLinkInner

	#commands
	#========
  #for now, only follows inner links
  #NOTE: this won't work if file name (link) is a path.
  #ex: "01-testing/note.md)
  #TODO: follow external links
  define-command ks-follow-link -docstring 'ks-follow-link: follow internal link under cursor' %{
    #TODO: restore visual selection
    execute-keys '<a-i>[<a-i>['
    evaluate-commands %sh{
      file=${kak_reg_dot}
      filepath=$(find . -name "$file*" | head -n 1)

      if ["$filepath" -eq ""]; then
      	filepath="./$file.md"
    	fi
      echo "edit \"${filepath}\""
    }
  }
}

hook global WinSetOption filetype=markdown %{
  evaluate-commands %sh{
		filepth="$PWD/.obsidian/workspace.json"
		if test -f "$filepth"; then
			echo "trigger-user-hook ksload"
		fi
  }
}
