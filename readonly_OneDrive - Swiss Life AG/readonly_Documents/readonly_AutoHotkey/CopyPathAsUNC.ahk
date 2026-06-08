#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

OnClipboardChange(HandleClipboard)

HandleClipboard(DataType) {
    if (DataType != 1)
        return

    clipboard := A_Clipboard

    if !RegExMatch(clipboard, "i)^`"?([A-Z]):\\", &m)
        return

    drive := m[1]
    if (drive = "C")
        return

    unc := GetMappedUNC(drive)
    if (!unc)
        return

    A_Clipboard := RegExReplace(clipboard, "i)^(`"?)" drive ":", "$1" unc)
}

GetMappedUNC(drive) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(A_ComSpec " /c net use " drive ":")

    output := exec.StdOut.ReadAll()

    if RegExMatch(output, "(\\\\eopx.+|\\\\swiss.+)", &m)
        return m[1]

    return ""
}
