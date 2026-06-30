$UserPath = @(
  "$env:USERPROFILE\.dotnet\tools",
  "$env:USERPROFILE\scoop\shims",
  "$env:USERPROFILE\scoop\apps\gcc\current\bin",
  "$env:USERPROFILE\scoop\apps\git\current\cmd",
  "$env:USERPROFILE\scoop\apps\python\current",
  "$env:USERPROFILE\scoop\apps\python\current\Scripts",
  "$env:USERPROFILE\scoop\apps\rustup\current\.cargo\bin",
  "$env:USERPROFILE\AppData\Local\Programs\Beyond Compare 5",
  "C:\Program Files\Notepad++"
)

[Environment]::SetEnvironmentVariable(
  "Path",
  ($UserPath -join ';'),
  "User"
)
