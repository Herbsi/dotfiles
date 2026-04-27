$UserPath = @(
  "$env:USERPROFILE\bin",
  "$env:USERPROFILE\.dotnet\tools",
  "$env:USERPROFILE\AppData\Local\Programs\R\R-4.6.0\bin\x64",
  "$env:USERPROFILE\scoop\shims",
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
