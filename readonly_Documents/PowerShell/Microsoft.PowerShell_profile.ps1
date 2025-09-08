Invoke-Expression (& { (jj util completion power-shell | Out-String) })
Invoke-Expression (&starship init powershell)
function Set-TerminalTitle {
    $host.UI.RawUI.WindowTitle = "$(Get-Location)"
}
Invoke-Expression (& { (zoxide init powershell | Out-String) })
