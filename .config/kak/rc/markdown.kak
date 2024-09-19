# Hook to handle Markdown buffers
hook global WinSetOption filetype=markdown %{
  # Highlight headings (from # to ######)
  add-highlighter buffer/markdown_heading_1 regex ^(#\ [^\n]*)$ 0:black,red+bF
  add-highlighter buffer/markdown_heading_2 regex ^(##\ [^\n]*)$ 0:black,yellow+bF
  add-highlighter buffer/markdown_heading_3 regex ^(###\ [^\n]*)$ 0:black,green+bF
  add-highlighter buffer/markdown_heading_4 regex ^(####\ [^\n]*)$ 0:black,cyan+bF
  add-highlighter buffer/markdown_heading_5 regex ^(#####\ [^\n]*)$ 0:black,blue+bF
  add-highlighter buffer/markdown_heading_6 regex ^(######\ [^\n]*)$ 0:black,magenta+bF

  # Highlight Markdown lists (bullet points)
  add-highlighter buffer/markdown_list regex "^[\s]*[-+*] [^\n]*" 0:yellow

  # Highlight TODO and DONE items
  add-highlighter buffer/markdown_todo regex "- \[ \] [^\n]*" 0:blue+b
  add-highlighter buffer/markdown_done regex "- \[x\] [^\n]*" 0:green+b

  # Conceal checkboxes with custom symbols
  add-highlighter buffer/markdown_checkbox_empty regex "\[ \] [^\n]*" 0:white+underline
  add-highlighter buffer/markdown_checkbox_checked regex "\[x\] [^\n]*" 0:green+b

  # Conceal the actual [ ] and [x] characters with ☐ and ☑
  add-highlighter buffer/checkbox_conceal regex "- \[ \] " 0:default fill '☐'
  add-highlighter buffer/checkbox_conceal regex "- \[x\] " 0:default fill '☑'

  # Optionally, you can conceal other parts (such as section numbers in headings)
  add-highlighter buffer/heading_conceal regex "(#+) (.+)$" 1:default hide

  # Markdown-specific settings or options can be set here (e.g., indentwidth)
  set-option buffer tabstop 2
  set-option buffer indentwidth 2
}
