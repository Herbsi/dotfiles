Attribute VB_Name = "SetZoomA1"
Sub SetZoomA1()
    Dim ws As Worksheet
    Application.ScreenUpdating = False
    
    For Each ws In ActiveWorkbook.Worksheets
        ws.Activate
        ActiveWindow.Zoom = 100
        Range("A1:A1").Select
        ActiveWindow.ScrollRow = 1
        ActiveWindow.ScrollColumn = 1
    
    Next
    Application.ScreenUpdating = True
    
    Sheets(1).Select
End Sub

