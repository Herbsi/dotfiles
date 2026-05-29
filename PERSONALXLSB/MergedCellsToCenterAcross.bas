Attribute VB_Name = "MergedCellsToCenterAcross"
Sub ConvertMergedCellsToCenterAcross()
    Dim c As Range
    Dim mergedRange As Range
    
    If TypeName(ActiveSheet) <> "Worksheet" Then Exit Sub
    
    For Each c In ActiveSheet.UsedRange
        If c.MergeCells = True And c.MergeArea.Rows.Count = 1 Then
            Set mergedRange = c.MergeArea
            mergedRange.UnMerge
            mergedRange.HorizontalAlignment = xlCenterAcrossSelection
        End If
    Next
End Sub
