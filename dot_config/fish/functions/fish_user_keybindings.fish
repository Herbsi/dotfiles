{{- if eq .chezmoi.hostname "Helium"}} 
function fish_user_key_bindings
  fzf_key_bindings
end
{{- end }}
{{- if eq .chezmoi.hostname "kuro"}} 
fzf_key_bindings
{{- end }}