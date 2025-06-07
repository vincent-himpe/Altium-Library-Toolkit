{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Library Cleaner                                                              }
{ -----------------------------------------------------------------------------}
var
    settings_courtyard_centroidlength : integer;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : LibClean_Startup
// Configures the system for modifications and creates the "footprint" object pointing to the current open footprint
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure LibClean_Startup;
begin
     GetUserSettings;
     PCBServer.PreProcess;
     //memo1.clear;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;
     If CurrentLib = Nil Then
     Begin
        LogMSG('ERR : This is not a PCB library document');
        Exit;
     End;
     footprint := currentlib.CurrentComponent;
end;


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : GetUsersettings
// Retrieve the user options from the "Settings" Tab
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure GetUserSettings;
var
  p: double;
begin


   // courtyard information

   Str2Double(trim(txt_courtyardwidth.Text),p);
   settings_courtyard_linewidth    := MMsToCoord(p);

   Str2Double(trim(txt_courtyardgap.Text),p);
   settings_courtyard_clearance    := MMsToCoord(p);

   Str2Double(trim(txt_CentroidWidth.Text),p);
   settings_courtyard_centroidsize := MMsToCoord(p);

   Str2Double(trim(txt_Centroidspoke.Text),p);
   settings_courtyard_centroidlength := MMsToCoord(p);

   // Assembly information

   Str2Double(trim(txt_assemblylinewidth.Text),p);
   settings_assembly_linewidth     := MMsToCoord(p);

   Str2Double(trim(txt_AssemblyPinLineWith.Text),p);
   settings_assembly_padwidth      := MMsToCoord(p);

   // Silkscreen Information

   Str2Double(trim( txt_silkscreenwidth.Text),p);
   settings_silkscreen_linewidth   := MMsToCoord(p);

   Str2Double(trim(txt_silktocopper.Text),p);
   settings_silkscreen_clearance   := MMsToCoord(p);

   // Soldermask Clearance

   Str2Double(trim(txt_soldermask_to_smt.Text),p);
   settings_soldermask_smt         := mmstocoord(p);

   Str2Double(trim(txt_soldermask_to_th.Text),p);
   settings_soldermask_th          := mmstocoord(p);

   Str2Double(trim(txt_soldermask_to_mech.Text),p);
   settings_soldermask_mech        := mmstocoord(p);

   Str2Double(trim(txt_soldermask_to_via.Text),p);
   settings_soldermask_viahole     := mmstocoord(p);

   // Paste mask

   Str2Double(trim(txt_PasteMaskRetraction.Text),p);
   settings_pastemask_retraction        := mmstocoord(p);


   // Layer Assignment
   // eMechanical1 = 57 , se we add 56 to any number given to get the actual layer.
   Str2int(trim(txt_layers_3dbody.Text),p);
   settings_layers_3dbody     := p+56;

   Str2int(trim(txt_layers_assembly.Text),p);
   settings_layers_assembly     := p+56;

   Str2int(trim(txt_layers_courtyard.Text),p);
   settings_layers_courtyard     := p+56;

   Str2int(trim(Edit11txt_layers_centroid.Text),p);
   settings_layers_centroid     := p56;

   Str2int(trim(txt_layers_designator.Text),p);
   settings_layers_designator     := p+56;

   // Options

   settings_AppplyDefaultStack      := CHK_ApplyDefaultStack.Checked;
   settings_RemoveUnusedMechanicals := CHK_RemoveUnusedMech.Checked;
   settings_RemoveUnusedCopper      := CHK_RemoveUnusedCopper.Checked;

   settings_apply_2221_padsizing    := CHK_ApplyIPC2221.Checked;
   settings_Pads_RoundSMDPads       := CHK_ApplyRoundSMD.Checked;
   settings_Pads_ThruShape          :=0;
      if settings_rdio_pin1_square.Checked = true then settings_Pads_ThruShape :=1;
      if settings_rdio_pin1_round.Checked = true then settings_Pads_ThruShape :=2;
   settings_Pads_ReshapeThruPin1   := CHK_Pads_ProcessThruPads.Checked;

   settingS_rebuild_assembly       := CHK_RebuildAssemblyLayer.Checked;
   settings_mark_pin1_on_assembly  := CHK_MarkPin1Assembly.Checked;

   settings_remove_pin1dots        := chk_pin1removedots.Checked;
   settings_mark_pin1_on_courtyard := CHK_MarkPin1Courtyard.Checked;

   settings_Assembly_Rebuild       := CHK_RebuildAssemblyLayer.schecked;
   settings_Assembly_MarkPinOne    := CHK_Assembly_MarkPin1.Checked;
   settings_Assembly_MarkPins      := chk_Assembly_Markpins.Checked;
   settings_Assembly_Resize        := CHK_ResizeAssemblyLayer.Checked;

   settings_Designater_Process     := CHK_ProcessDesignator.checked;
   settings_Designator_Add         := settings_rdio_adddesignator.Checked;
   settingS_Designator_Cleanup     := settings_rdio_cleanup.Checked;
   settingS_Designator_Remove      := settings_rdio_removedesignator.Checked;

   Settings_Courtyard_Rebuild      := CHK_RebuildCourtyardLayer.Checked;
   settings_Courtyard_MarkPin1     := CHK_MarkPin1Courtyard.Checked;
   settings_Courtyard_pin1style    := cmb_CourtYardPin1Style.ItemIndex;    // 0 = none , 1 arrow , 2 box
   settings_Courtyard_Resize       := CHK_ResizeCourtyard.checked;

   settings_SilkScreen_Rebuild     := CHK_RebuildSilkscreenlayer.Checked;
   settings_Silkscreen_Resize      := CHK_ResizeSilkscreenLayer.Checked;
   settings_Silkscreen_Wipe        := chk_wipesilkscreen.Checked;

   settings_pastemask_retract      := CHK_PasteMask_retract.checked;

   settings_Misc_RemovePin1Dots    := CHK_RemovePin1Dots
   settings_Misc_Fixup3Dmodels     := CHK_Fixup3D
   settings_Misc_UnlockObjects     := CHK_UnlockObjects
   settings_Misc_ResetGridstyle    := CHK_ResetGridStyle
   settings_Misc_GarbageCollector  := CHK_GarbageCollector
   settings_Misc_ProcessDeisgnator := CHK_ProcessDesignator
   settings_Misc_RetractPaste      := CHK_PasteMask_retract




   //settings_processall             := chk_processall.Checked;


   settings_pin1indicatorlength := mmstocoord(0.75);

   get_Thermal_Settings;

end;

procedure FindPin1;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     apad                 : IPCB_pad;
begin
     pin1pad   := nil;
     pin1bound :=nil;
     pin1found :=false;
     smtpin1found := false;

     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     While (APrimitive <> Nil) Do
     begin
            // processing block
            if aprimitive.ObjectId = ePadObject then begin
               apad :=APrimitive;
               if apad.Name = '1' then begin
                  if apad.Layer =eTopLayer then SMTPin1Found :=true;
                  if apad.Layer =eBottomLayer then smtpin1found :=true;
                  if apad.Layer =eMultiLayer then Pin1Found :=true;
                  pin1pad :=aprimitive;
                  pin1bound :=aprimitive.BoundingRectangle;
               end;
            end;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);

end;

// Helper : Footprintcleaner : find height from 3d models
Procedure AssignHeight;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     currentheight        : integer;
begin
     LogMSG('RUN : Fixup 3D Models And Data');
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     currentheight := footprint.Height;
     footprint.height :=0;
     While (APrimitive <> Nil) Do
     begin
            // processing block
             if APrimitive.objectid = eComponentBodyObject then begin
                aprimitive.Layer := eMechanical1;

                // Set the locked property to true :
                APrimitive.moveable :=false;

                APrimitive.BodyOpacity3D :=1;
                if aprimitive.overallheight > footprint.height then begin
                   footprint.height :=aprimitive.overallheight;
                   foundsomething :=1;
                end;
             end;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin
        if currentheight <> footprint.Height then LogMSG('    : Updated Height to '+ FloatToStr(CoordToMMs(footprint.Height)));
     end;
     if footprint.Height = 0 then  logmsg('!!! : No 3d model Found');
     footprint.EndModify;
     LogMSG('END : Fixup 3D Models And Data');
end;
