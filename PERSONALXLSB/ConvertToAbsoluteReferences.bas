Attribute VB_Name = "ConvertToAbsoluteReferences"
Sub ConvertToAbsoluteReferences()
    Dim cell As Range
    Dim formula As String
    
    If TypeName(Selection) <> "Range" Then
        MsgBox "Please select a range of cells.", vbExclamation
        Exit Sub
    End If
    
    For Each cell In Selection
        On Error Resume Next
        If cell.HasFormula Then
            formula = cell.formula
            formula = Application.ConvertFormula(formula:=formula, _
                                                 FromReferenceStyle:=xlA1, _
                                                 ToReferenceStyle:=xlA1, _
                                                 ToAbsolute:=xlAbsolute)
            If Err.Number = 0 Then
                cell.formula = formula
            Else
                MsgBox "Could not convert formula in cell " & cell.Address, vbExclamation
                Err.Clear
            End If
        End If
        On Error GoTo 0
    Next cell

    MsgBox "All references in the selected range have been converted to absolute references.", vbInformation
End Sub

