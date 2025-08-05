Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'
Invoke-Expression (& { (jj util completion power-shell | Out-String) })
Invoke-Expression (&starship init powershell)
function Set-TerminalTitle {
    $host.UI.RawUI.WindowTitle = "$(Get-Location)"
}
