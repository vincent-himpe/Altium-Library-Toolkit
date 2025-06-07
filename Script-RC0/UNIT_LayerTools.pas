{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Layer Tools                                                                  }
{ -----------------------------------------------------------------------------}

Const

NoColor = 'ncol';
AllLayerMax = 64;

var
Board : IPCB_Board;
PCBLibrary : IPCB_Library;
LayerStack : IPCB_LayerStack_V7;
LayerObj : IPCB_LayerObject_V7;
MechLayer : IPCB_MechanicalLayer;
MechPairs : IPCB_MechanicalLayerPairs;
MaxMechLayers : integer;

Flag : Integer;
ML1,ML2 : integer;
i,j : integer;
x,y : integer;

Procedure PCBLib_ExportMechLayerInfo;
          Begin
               //Board := PCBServer.GetCurrentPCBBoard;
               PCBLibrary := PCBServer.GetCurrentPCBLibrary;
               if PCBLibrary = nil then exit;
               RunProcess('PCB:ExportMechLayers');
End;

Procedure PCB_ExportMechLayerInfo;
          Begin
               Board := PCBServer.GetCurrentPCBBoard;
               if Board = nil then exit;
               RunProcess('PCB:ExportMechLayers');
End;

Procedure PCB_ImportMechLayerDefault;
          var
               FileName : String;
          begin
               Board := PCBServer.GetCurrentPCBBoard;
               if Board = nil then exit;

               // This will open che ImportMechLayers File Dialog
               // RunProcess ('PCB:ImportMechLayers');

               //FileName := 'Filename='+(ExtractFilePath (Board.FlleName)) + 'Mech-Layers.stackup';
               FileName := 'Filename=c:\stack.Stackup';
               // For Direct Import Without the File Dialog
               Client.SendMessage ('PCB:ImportMechLayers', FileName, 255, Client.CurrentView);
end;

Procedure PCB_ImportMechLayerInfo_FromFile;
          var
               FileName : String;
          begin
               Board := PCBServer.GetCurrentPCBBoard;
               if Board = nil then exit;

               // This will open che ImportMechLayers File Dialog
                RunProcess ('PCB:ImportMechLayers');

               //FileName := 'Filename='+(ExtractFilePath (Board.FlleName)) + 'Mech-Layers.stackup';
               //FileName := 'Filename=c:\stack.Stackup';
               // For Direct Import Without the File Dialog
               //Client.SendMessage ('PCB:ImportMechLayers', FileName, 255, Client.CurrentView);
end;


Procedure PCB_HideUnusedMechLayers;
          var
             PCBSysopts : IPCB_SystemOptions;
          begin
               MaxMechLayers := 32;   // need to get this from options
               Board := PCBServer.GetCurrentPCBBoard;
               if Board = nil then exit;
               PCBSysopts := PCBServer.SystemOptions;
               if PCBSysopts = nil then exit;
               LayerStack := Board.Layerstack_v7;
               MechPairs := Board.MechanicalPairs;
               for x := 1 to MaxMechlayers do
               begin
                    ML1 := LayerUtils.MechanicalLayer(x);
                    MechLayer := Layerstack.layerobject_v7[ML1];
                    If NOT (MechLayer.UsedByPrims) then MechLayer.MechanicalLayerEnabled :=false;
                    If MechLayer.UsedByPrims then mechlayer.isdisplayed[Board] :=true;
               end;
               Board.ViewManager_UpdateLayerTabs;
               Board.ViewManager_FullUpdate;
end;






Function RemoveSelectedMechLayerPair_ocr (Junk: string) :boolean;

var
   PCBSysOpts : IPCB_SystemOptions;
   Board;C;1;P;M;

begin
   Board:=PCBServer.GetCurrentPCBBoard;
   P:=Board.MechanicalPairs;
   C:=Board.CurrentLayer;
   for I:=1 To MaxMechLayers do
   begin
        M:=LayerUtils.MechanicalLayer (i);
        if P.PairDefined(C, M) then
        begin
             P.RemovePair (C, M) ;
             // ShowInto ('UnPaired Mech Layers :' + Layer2String(C) + ' s ' + Layer2String (M)) =
             break;
        end;
   end;
   Result := True;
   EndHourGlass;
   Board.ViewManager_UpdateLayerTabs;
   Board.ViewManager_FullUpdate;
end;



Procedure PCB_ResetA11MechLayerPairs;
var
     PCBSysOpts: IPCB_SystemOptions;

begin
     MaxMechLayers := 32;  // needs to be loaded from options
     Board := PCBServer.GetCurrentPCBBoard;
     if Board = nil then exit;
     PCBSysOpts := PCBServer.SystemOptions;
     If PCBSysOpts = Nil Then exit;
     BeginHourGlass (crHourGlass) ;
     LayerStack := Board.LayerStack_V7;
     MechPairs := Board.MechanicalPairs;
     For i := 1 To MaxMechLayers do
     begin
          ML1 := LayerUtils.MechanicalLayer (i) ;
          MechLayer := LayerStack.LayerObject_V7[ML1];
          MechLayer.Name := 'Mechanical ' + IntToStr (i) ;
          if (i <= AllLayerMax) or MechLayer.MechanicalLayerEnabled then
          begin
               // remove existing mech pairs
               for j:= 1 to (MaxMechLayers) do
               begin
                    ML2 := LayerUtils.MechanicalLayer (j) ;
                    if MechPairs.PairDefined (ML2, ML1) then
                       MechPairs.RemovePair (ML2, ML1) ;
                    if MechPairs.PairDefined (ML1, ML2) then
                       MechPairs.RemovePair (ML1, ML2) ;
               end;
               MechLayer.MechanicalLayerEnabled :=true;
               MechLayer.LinkToSheet :=false;
               MechLayer.DisplayInSingleLayerMode :=False;
               MechLayer.IsDisplayed[Board] :=false;
               MechLayer.Kind :=0;
          end;
     end;

     EndHourGlass;
     Board.ViewManager_UpdateLayerTabs;
     Board.ViewManager_FullUpdate;
    end;





