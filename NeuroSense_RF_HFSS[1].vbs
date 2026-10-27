' NeuroSense RF - HFSS Electronics Desktop VBScript
' Geometry + excitation + solution setup. NOT pre-simulated.
Dim oAnsoftApp, oDesktop, oProject, oDesign, oEditor, oBoundary, oAnalysis, oReport
Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.NewProject
Set oProject = oDesktop.GetActiveProject()
oProject.InsertDesign "HFSS", "NeuroSense_RF", "DrivenModal", ""
Set oDesign = oProject.SetActiveDesign("NeuroSense_RF")
Set oEditor = oDesign.SetActiveEditor("3D Modeler")

Sub Box(n, x,y,z, dx,dy,dz, mat, color)
 oEditor.CreateBox Array("NAME:BoxParameters", "XPosition:=", CStr(x)&"mm", "YPosition:=", CStr(y)&"mm", "ZPosition:=", CStr(z)&"mm", "XSize:=", CStr(dx)&"mm", "YSize:=", CStr(dy)&"mm", "ZSize:=", CStr(dz)&"mm"), Array("NAME:Attributes", "Name:=", n, "Flags:=", "", "Color:=", color, "Transparency:=", 0.25, "PartCoordinateSystem:=", "Global", "UDMId:=", "", "MaterialValue:=", "\""&mat&"\"", "SolveInside:=", True)
End Sub
Sub Sheet(n,x,y,z,wx,wy,axis)
 oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", True, "XStart:=", CStr(x)&"mm", "YStart:=", CStr(y)&"mm", "ZStart:=", CStr(z)&"mm", "Width:=", CStr(wx)&"mm", "Height:=", CStr(wy)&"mm", "WhichAxis:=", axis), Array("NAME:Attributes", "Name:=", n, "Flags:=", "", "Color:=", "(220 155 65)", "Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=", "", "MaterialValue:=", "\"vacuum\"", "SolveInside:=", True)
End Sub
' PCB x=0..50, y=0..40, z=0..1.6
Box "FR4",0,0,0,50,40,1.6,"FR4_epoxy","(80 170 100)"
Sheet "Ground",0,0,0,50,40,"Z"
Sheet "Feed",0,18.5,1.6,50,3,"Z"
' Open-loop resonator: x=18..30, y=22..34, 1 mm copper trace
' Open at center of bottom edge: gap x=23..25
Sheet "LoopLeft",18,22,1.6,1,12,"Z"
Sheet "LoopTop",18,33,1.6,12,1,"Z"
Sheet "LoopRight",29,22,1.6,1,12,"Z"
Sheet "LoopBottomLeft",18,22,1.6,5,1,"Z"
Sheet "LoopBottomRight",25,22,1.6,5,1,"Z"
Set oBoundary = oDesign.GetModule("BoundarySetup")
' PEC sheet boundaries: no copper thickness, efficient initial prototype
Dim conductors
conductors = Array("Ground","Feed","LoopLeft","LoopTop","LoopRight","LoopBottomLeft","LoopBottomRight")
oBoundary.AssignPerfectE Array("NAME:PEC_Traces", "Objects:=", conductors, "InfGroundPlane:=", False)
' Port sheets are perpendicular to feed, between ground and feed; lumped ports
Sheet "P1",0,18.5,0,3,1.6,"X"
Sheet "P2",50,18.5,0,3,1.6,"X"
oBoundary.AssignLumpedPort Array("NAME:Port1", "Objects:=", Array("P1"), "RenormalizeAllTerminals:=", True, "DoDeembed:=", False, "Modes:=", Array("NAME:Modes", Array("NAME:Mode1", "ModeNum:=", 1, "UseIntLine:=", True, "IntLine:=", Array("NAME:IntLine", "Start:=", Array("0mm","20mm","0mm"), "End:=", Array("0mm","20mm","1.6mm")), "CharImp:=", "Zpi", "AlignmentGroup:=", 0, "RenormImp:=", "50ohm")))
oBoundary.AssignLumpedPort Array("NAME:Port2", "Objects:=", Array("P2"), "RenormalizeAllTerminals:=", True, "DoDeembed:=", False, "Modes:=", Array("NAME:Modes", Array("NAME:Mode1", "ModeNum:=", 1, "UseIntLine:=", True, "IntLine:=", Array("NAME:IntLine", "Start:=", Array("50mm","20mm","0mm"), "End:=", Array("50mm","20mm","1.6mm")), "CharImp:=", "Zpi", "AlignmentGroup:=", 0, "RenormImp:=", "50ohm")))
' Air region: radiation boundary on external airbox faces
Box "AirRegion",-40,-40,-40,130,120,81.6,"air","(150 210 250)"
oBoundary.AssignRadiation Array("NAME:Rad1", "Objects:=", Array("AirRegion"))
Set oAnalysis = oDesign.GetModule("AnalysisSetup")
oAnalysis.InsertSetup "HfssDriven", Array("NAME:Setup1", "Frequency:=", "3.5GHz", "PortsOnly:=", False, "MaxDeltaS:=", 0.02, "MaximumPasses:=", 12, "MinimumPasses:=", 2, "MinimumConvergedPasses:=", 2, "PercentRefinement:=", 30, "IsEnabled:=", True)
oAnalysis.InsertFrequencySweep "Setup1", Array("NAME:Sweep1", "IsEnabled:=", True, "RangeType:=", "LinearStep", "RangeStart:=", "1GHz", "RangeEnd:=", "6GHz", "RangeStep:=", "0.05GHz", "Type:=", "Discrete", "SaveFields:=", False)
oDesign.SetActiveEditor("3D Modeler")
oProject.SaveAs "NeuroSense_RF.aedt", True
MsgBox "NeuroSense RF geometry and setup created. Validate and run Analyze All; results are NOT yet generated."
