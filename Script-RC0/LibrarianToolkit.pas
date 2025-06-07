{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Revision log                                                                 }
{ -----------------------------------------------------------------------------}
{ 0.0 : Alpha Build                                                            }
{..............................................................................}
{..............................................................................}

const
     experimental = false;
     ToolVersion = ' RC0';
     TopOverlayWidth = 0.2;
     assemblylayerwidth = 0.25;
     M13width = 0.25;
     M15width = 0.05;
     SMTsoldermask = 0.05; // was 0.075
     CourtyardOffset = 0.25;
     CourtyardWidth = 0.05;
     SmallGrid = 0.025;
     th_spokewidth   = 0.1;     // soldermmask spoke width
     th_viaringwidth = 0.076;   // cutout on thermal via ( encroaching distance )
     th_ringwidth    = 0.20;    // ring width on via
     th_pastespoke   = 0.15 ;
     paste_cutout_via = 0.5;
     solder_cutout_via = 0.508+ th_viaringwidth+th_viaringwidth+0.1;  // viahole + encroach +0.1
  //   thermalpitch =1.1;
var
   global_currentfootprint         : IPCB_LibComponent;                         // a footprint object to be used while passing the footprint to a subfunction
   settings_courtyard_linewidth    : integer;
   settings_courtyard_clearance    : integer;
   settings_courtyard_centroidsize : integer;
   settings_assembly_linewidth     : integer;
   settings_assembly_padwidth      : integer;
   settings_silkscreen_linewidth   : integer;
   settings_silkscreen_clearance   : integer;
   settings_apply_2221_padsizing   : boolean;
   settings_remove_pin1dots        : boolean;
   settings_mark_pin1_on_courtyard : boolean;
   settings_mark_pin1_on_assembly  : boolean;
   settings_mark_pins_on_assembly  : boolean;
   settings_rebuild_courtyard      : boolean;
   settingS_rebuild_assembly       : boolean;
   settings_rebuild_silkscreen     : boolean;
   settings_designator_add         : boolean;
   settings_designator_remove      : boolean;
   settings_pastemask_retraction   : integer;
   settings_pastemask_retract      : boolean;
  // settings_thermalfarm_holesize   : integer;
  // settings_thermalfarm_backpadsize : integer;
  // settings_thermalfarm_toppadsize : integer;
  // settings_thermalfarm_midpadsize : integer;
  // settings_thermalfarm_pitch      : integer;
   settings_soldermask_smt         : integer;
   settings_soldermask_mech        : integer;
   settings_soldermask_viahole     : integer;
   settings_soldermask_th          : integer;
   settings_wipe_silkscreen        : boolean;
   settings_courtyard_pin1style    : integer;
   settings_processall             : boolean;
   settings_silkscreen_pin1        : booelan;
   settings_componentboundary      : tcoordrect;
   settings_pin1boundary           : tcoordrect;
   settings_pin1indicatorlength    : integer;

   settings_thermal_holesize       : integer;
   settings_thermal_TopPad         : integer;
   settings_thermal_MidPad         : integer;
   settings_thermal_BottomPad      : integer;
   settings_thermal_pitch          : integer;
   settings_thermal_tilesize       : integer;
   settings_thermal_minimumtile    : integer;
   settings_thermal_masktype       : integer;
   settings_pin1                   : integer;
   thermalpad                      : ipcb_pad;

   Pin1Pad                         : IPCb_PAD;                                  // storage for the object holding pin1
   Pin1Bound                       : tcoordrect;                                // a spatial entity storing the boundary of pin 1
   SMTPin1Found                    : boolean;                                   // true if pin 1 is SMT
   Pin1Found                       : boolean;                                   // true if there is a pin 1 (smt or thru-hole)
   designator_object               : ipcb_text;                                 // used to pass the designator string to the sizing algorithm
   designator_frame                : tcoordrect;                                // used to pass the body frame to the designator sizing algorithm

   // ------------------------- old variables. needs cleanup --------------------

     logbook              : Tstring;
     maxx                 : integer;                                            // used for footprint boundary calculation : holds the maximum x of copper or M13 objects
     minx                 : integer;                                            // used for footprint boundary calculation : holds the minimum x of copper or M13 objects
     maxy                 : integer;                                            // used for footprint boundary calculation : holds the maximum y of copper or M13 objects
     miny                 : integer;                                            // used for footprint boundary calculation : holds the minimum y of copper or M13 objects
     boundarea            : tcoordrect;                                         // a spatial entity storing the boundary of an object

     m13bound             : tcoordrect;                                         // a spatial entity storing the boundary of all m13 objects
     CurrentLib           : IPCB_Library;                                       // holds the current library
     APrimitive           : IPCB_Primitive;                                     // the primitive under investigation
     APrimitive2          : IPCB_Primitive2;                                    // a temporary storage for a primitive
     afill                : ipcb_fill;                                          // a fill type object
     APad2                : IPCB_Pad2;                                          // a pad2 type object (altium has 3 pad types : Pad, Pad2 and Pad3)
     APad3                : IPCB_Pad3;                                          // a pad2 type object

     TextObj              : IPCB_Text;
     FootprintIterator    : IPCB_LibraryIterator;
     ObjIterator          : IPCB_GroupIterator;
     Footprint            : IPCB_LibComponent;
     aVia                 : IPCB_Via;
     aPad                 : iPCB_Pad;
     aTrack               : iPCB_track;
     pinnumber            : integer;
     holesize             : real;
     padsize              : real;
     ViaCache             : TPadCache;
     descr                : Tstring;
     blah                 : integer;
     Tracklist            : TInterfaceList;
//   thermal wizard variables
     th_brd               : IPCB_Board;
     th_comp              : IPCB_Component;
     th_via               : IPCB_Via;
     th_nettring          : tstring;
     th_net               : ipcb_net;


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Make an entry in the logbook
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function LogMSG(msg : tstring);
begin
         logbook := logbook + msg + #13;
         memo1.lines.add(msg);
end;

procedure ClearLog;
begin
  memo1.Clear;
end;

Function SchLogMSG(msg : tstring);
begin
         //logbook := logbook + msg + #13;
         memo2.lines.add(msg);
end;

procedure SchClearLog;
begin
  memo2.Clear;
end;


Procedure get_Thermal_Settings;
begin
    settings_thermal_holesize := MMsToCoord(trim(txt_thermal_holesize.Text));
    settings_thermal_TopPad := MMsToCoord(trim(txt_thermal_toppad.Text));
    settings_thermal_MidPad := MMsToCoord(trim(txt_thermal_midpad.Text));
    settings_thermal_BottomPad := MMsToCoord(trim(txt_thermal_backpad.Text));
    settings_thermal_pitch := MMsToCoord(trim(txt_thermal_pitch.Text));
    settings_thermal_tilesize := MMsToCoord(trim(txt_thermal_pastetile.Text));
    settings_thermal_minimumtile := MMsToCoord(trim(txt_thermal_minimumtile.Text));
    settings_thermal_masktype :=1;
end;



// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : Cleanup the Footprint
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Helper : dummy routine
Procedure skeleton;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     While (APrimitive <> Nil) Do
     begin
            // processing block

            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin
        LogMSG('  -> Deleted Restriced Stuff');
     end;
     footprint.EndModify;
end;


procedure Resizedesignator;
begin
    if  (designator_object <> nil)
    and (designator_frame <> nil) then begin
        designator_object.Layer      :=  eMechanical13;
        designator_object.Text       :=  '.DESIGNATOR';
        designator_object.UseTTFonts := false;
        designator_object.Size       := MilsToCoord(12);
        designator_object.width      := MilsToCoord(2);
        designator_object.rotation   := MilsToCoord(0);
        designator_object.Bold       := false;
        designator_object.Inverted   := false;
        designator_object.InvertedTTTextBorder := MMsToCoord(0.02);
        designator_object.TTFInvertedTextJustify :=5;
        designator_object.Multiline :=true;
        designator_object.X1Location :=designator_frame.left;
        designator_object.y1Location :=designator_frame.bottom;
        designator_object.X2Location :=designator_frame.right;
        designator_object.y2Location :=designator_frame.top;
        designator_object.XLocation := designator_frame.left;
        designator_object.yLocation := designator_frame.bottom;

    end;
end;
// Helper : Footprintcleaner : fix the .designator string
Procedure FixDesignator;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     TextObj              : IPCB_Text;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     While (APrimitive <> Nil) Do
     begin
            // processing block
            if (APrimitive.objectid = eTextObject) then begin
               if (APrimitive.layer = eMechanical13 ) then begin
                  if uppercase(trim(APrimitive.text)) = '.DESIGNATOR' then begin
                     APrimitive.text := '.DESIGNATOR';   // force it  to uppercase
                        aprimitive.Moveable := true;
                        foundsomething := 1;
                        APrimitive.XLocation :=  footprint.board.xorigin + MilsToCoord(-65);
                        APrimitive.YLocation :=  footprint.board.yorigin + MilsToCoord(-6);
                        APrimitive.Size      := MilsToCoord(12);   // sets the height of the text.
                        APrimitive.width     := MilsToCoord(2);
                        APrimitive.rotation  := MilsToCoord(0);
                        APrimitive.multiline := false;
                        APrimitive.textkind  := 0;
                        aprimitive.Moveable := false;
                        if settings_designator_remove = true then begin
                           aprimitive.Selected :=true;
                           aprimitive.Moveable := true;
                        end;
                     end;
                  end;
               end;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin
        if settings_designator_remove = true then begin
           ResetParameters;
           AddStringParameter('Action', 'Document');
           RunProcess('PCB:Zoom');
           resetparameters;
       //    runprocess('PCB:Clear');
           runprocess('PCB:DeleteObjects');
           LogMSG('  -> Removed .Designator');
        end
        else begin
           LogMSG('  -> Processed .Designator');
        end;
     end
     else begin
         if settings_designator_add = true then begin
            TextObj := PCBServer.PCBObjectFactory(eTextObject, eNoDimension, eCreate_Default);
            TextObj.Layer     :=  eMechanical13;
            TextObj.Text      :=  '.DESIGNATOR';
            TextObj.Size      :=  MilsToCoord(12);
            TextObj.width     :=  MilsToCoord(2);
            TextObj.rotation  :=  MilsToCoord(0);
            TextObj.XLocation :=  footprint.board.xorigin + MilsToCoord(-65);
            TextObj.YLocation :=  footprint.board.yorigin + MilsToCoord(-6);
            Footprint.board.AddPCBObject(TextObj);
            PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,textobj.I_ObjectAddress);
            pcbserver.PostProcess;
            LogMSG('  -> Added .Designator');
         end;
     end;
     footprint.EndModify;
end;

// Helper : Footprintcleaner : derive size from step model
Procedure GetEnvelope;
var
    ObjIterator          : IPCB_GroupIterator;
    APrimitive           : IPCB_Primitive;
    foundsomething       : integer;
    boundarea            : tcoordrect;
begin
   footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     maxx :=footprint.board.xorigin;
     minx :=footprint.board.xorigin;
     maxy :=footprint.board.yorigin;
     miny :=footprint.board.yorigin;
     While (APrimitive <> Nil) Do
     begin
            // processing block
            if (APrimitive.objectid = ePadObject) then begin
                boundarea := APrimitive.BoundingRectangle;
                boundarea.left := boundarea.left + MMsToCoord(SMTsoldermask);
                boundarea.right := boundarea.right - MMsToCoord(SMTsoldermask);
                boundarea.top := boundarea.top - MMsToCoord(SMTsoldermask);
                boundarea.bottom := boundarea.bottom + MMsToCoord(SMTsoldermask);
                if boundarea.left <minx then minx := boundarea.left;
                if boundarea.right>maxx then maxx := boundarea.right;
                if boundarea.bottom <miny then miny := boundarea.bottom;
                if boundarea.top >maxy then maxy := boundarea.top;
            end;
            if (APrimitive.objectid = eviaobject) then begin
                if (APrimitive.x - ((aprimitive.SizeOnLayer(eTopLayer))/2)) < minx then minx := APrimitive.x - ((aprimitive.SizeOnLayer(eTopLayer))/2);
                if (APrimitive.y - ((aprimitive.SizeOnLayer(eTopLayer))/2)) < miny then miny := APrimitive.y - ((aprimitive.SizeOnLayer(eTopLayer))/2);
                if (APrimitive.x + ((aprimitive.SizeOnLayer(eTopLayer))/2)) > maxx then maxx := APrimitive.x + ((aprimitive.SizeOnLayer(eTopLayer))/2);
                if (APrimitive.y + ((aprimitive.SizeOnLayer(eTopLayer))/2)) > maxy then maxy := APrimitive.y + ((aprimitive.SizeOnLayer(eTopLayer))/2);
                if (APrimitive.x - ((aprimitive.SizeOnLayer(eBottomlayer))/2)) < minx then minx := APrimitive.x - ((aprimitive.SizeOnLayer(eBottomlayer))/2);
                if (APrimitive.y - ((aprimitive.SizeOnLayer(eBottomlayer))/2)) < miny then miny := APrimitive.y - ((aprimitive.SizeOnLayer(eBottomlayer))/2);
                if (APrimitive.x + ((aprimitive.SizeOnLayer(eBottomlayer))/2)) > maxx then maxx := APrimitive.x + ((aprimitive.SizeOnLayer(eBottomlayer))/2);
                if (APrimitive.y + ((aprimitive.SizeOnLayer(eBottomlayer))/2)) > maxy then maxy := APrimitive.y + ((aprimitive.SizeOnLayer(eBottomlayer))/2);
            end;
            if (APrimitive.objectid = eTrackObject) then begin
              if APrimitive.Layer = eMechanical13 then begin
                 if APrimitive.x1 <minx then minx := APrimitive.x1;
                 if APrimitive.x1 >maxx then maxx := APrimitive.x1;
                 if APrimitive.y1 <miny then miny := APrimitive.y1;
                 if APrimitive.y1 >maxy then maxy := APrimitive.y1;
                 if APrimitive.x2 <minx then minx := APrimitive.x2;
                 if APrimitive.x2 >maxx then maxx := APrimitive.x2;
                 if APrimitive.y2 <miny then miny := APrimitive.y2;
                 if APrimitive.y2 >maxy then maxy := APrimitive.y2;
              end;
            end;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin
        LogMSG('  -> Deleted Restriced Stuff');
     end;
     footprint.EndModify;
end;
// Helper : Footprintcleaner : remove junk layer 11 and other garbage
Procedure DeleterestrictedStuff;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     // check name and description
     footprint.name := AnsiUpperCase(trim(footprint.name));
     footprint.name := stringreplace(footprint.name,'_','-',rfreplaceall);
     if copy (footprint.name ,1,4) = 'CON-' then begin
        footprint.name := inputbox ('name discrepancy ','Component [' + footprint.Name +'] is potentially incorrect '+ #13 + 'Make correction if needed.',footprint.name);
     end;
     if copy(footprint.name ,1,5) = 'CONN-' then begin
       footprint.name := inputbox ('name discrepancy ','Component [' + footprint.Name +'] is potentially incorrect '+ #13 + 'Make correction if needed.',footprint.name);
     end;
     footprint.name := AnsiUpperCase(trim(footprint.name));
     if trim(footprint.Description) ='' then begin
        descr := inputbox ('Missing Description','Component [' + footprint.Name +'] has no description.'+ #13 +'Enter a description or leave the field blank to copy the name.','');
        if descr = '' then descr := footprint.name;
           descr := stringreplace(descr,'-',' ',rfReplaceAll);
           descr := stringreplace(descr,'_',' ',rfReplaceAll);
           footprint.description :=descr;
        end;
     footprint.description :=  AnsiUpperCase(trim(footprint.description));
     // now go hunt for junk
       While (APrimitive <> Nil) Do
       begin
           aprimitive.Selected := true;             // select the item to begin : we are assuming it to be garbage
                                                    // the test below will determine if we keep it
           // lets look at strings
           if (APrimitive.objectid = eTextObject) then begin
              if (APrimitive.layer = eMechanical15) then APrimitive.Selected :=false;               // courtyard strings
              if (APrimitive.layer = eMechanical13) then begin
                 APrimitive.Selected :=false;               // assembly layer strings
                 if aprimitive.text = '1' then aprimitive.Selected :=true;
              end;
              if (APrimitive.layer = eDrillDrawing) then APrimitive.Selected :=false;               // drill layer strings
           end;
          if (APrimitive.objectid = ePadObject ) then APrimitive.Selected :=false;                    // pads
          if (APrimitive.objectid = eviaObject ) then APrimitive.Selected :=false;                    // vias
          if (
              (APrimitive.objectid = eTrackObject) or
              (APrimitive.objectid = eArcObject) or
              (APrimitive.objectid = eRegionObject) or
              (APrimitive.objectid = eFillObject) or
              (APrimitive.objectid = ePolyObject)
              ) then begin
              if (APrimitive.layer = eMechanical15) then APrimitive.Selected :=false;               // courtyard strings
              if (APrimitive.layer = eMechanical13) then APrimitive.Selected :=false;               // assembly layer strings
              if (APrimitive.layer = eDrillDrawing) then APrimitive.Selected :=false;               // drill layer strings
              if (APrimitive.layer = eTopLayer) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eTopOverlay) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eBottomLayer) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eBottomOverlay) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eTopPaste) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eBottompaste) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eTopSolder) then APrimitive.Selected :=false;                   // drill layer strings
              if (APrimitive.layer = eBottomSolder) then APrimitive.Selected :=false;                   // drill layer strings
          end;

          if APrimitive.objectid = eComponentBodyObject then begin
             aprimitive.Selected :=false;
          end;
          if aprimitive.Selected = true then foundsomething  :=1;
          // irrespective of what happened before :
          if (settings_wipe_silkscreen=true) then begin
              if (APrimitive.layer = eTopOverlay) then APrimitive.Selected :=true;
              if (APrimitive.layer = ebottomOverlay) then APrimitive.Selected :=true;
          end;


          APrimitive := ObjIterator.NextPCBObject;
       end;
     Footprint.GroupIterator_Destroy(ObjIterator);
   //  if foundsomething = 1 then begin
   //     LogMSG('  -> Deleted Restriced Stuff');
        resetparameters;
     //   runprocess('PCB:Clear');
         runprocess('PCB:DeleteObjects');
   //  end;
           Footprint.LayerUsed(eMechanical1) :=false;
           Footprint.LayerUsed(eMechanical2) :=false;
           Footprint.LayerUsed(eMechanical3) :=false;
           Footprint.LayerUsed(eMechanical4) :=false;
           Footprint.LayerUsed(eMechanical5) :=false;
           Footprint.LayerUsed(eMechanical6) :=false;
           Footprint.LayerUsed(eMechanical7) :=false;
           Footprint.LayerUsed(eMechanical8) :=false;
           Footprint.LayerUsed(eMechanical9) :=false;
           Footprint.LayerUsed(eMechanical10) :=false;
           Footprint.LayerUsed(eMechanical11) :=false;
           Footprint.LayerUsed(eMechanical12) :=false;
           Footprint.LayerUsed(eMechanical1) :=true;
           Footprint.LayerUsed(eMechanical13) :=true;
           Footprint.LayerUsed(eMechanical15) :=true;
           Footprint.LayerUsed(eMechanical16) :=true;

           Footprint.LayerUsed(eMidLayer1) :=false;
           Footprint.LayerUsed(eMidLayer2) :=false;
           Footprint.LayerUsed(eMidLayer3) :=false;
           Footprint.LayerUsed(eMidLayer4) :=false;
           Footprint.LayerUsed(eMidLayer5) :=false;
           Footprint.LayerUsed(eMidLayer6) :=false;
           Footprint.LayerUsed(eMidLayer7) :=false;
           Footprint.LayerUsed(eMidLayer8) :=false;
           Footprint.LayerUsed(eMidLayer9) :=false;
           Footprint.LayerUsed(eMidLayer10) :=false;
           Footprint.LayerUsed(eMidLayer11) :=false;
           Footprint.LayerUsed(eMidLayer12) :=false;
           Footprint.LayerUsed(eMidLayer13) :=false;
           Footprint.LayerUsed(eMidLayer14) :=false;
           Footprint.LayerUsed(eMidLayer15) :=false;
           Footprint.LayerUsed(eMidLayer16) :=false;
           Footprint.LayerUsed(eMidLayer17) :=false;
           Footprint.LayerUsed(eMidLayer18) :=false;
           Footprint.LayerUsed(eMidLayer19) :=false;
           Footprint.LayerUsed(eMidLayer20) :=false;
           Footprint.LayerUsed(eMidLayer21) :=false;
           Footprint.LayerUsed(eMidLayer22) :=false;
           Footprint.LayerUsed(eMidLayer23) :=false;
           Footprint.LayerUsed(eMidLayer24) :=false;
           Footprint.LayerUsed(eMidLayer25) :=false;
           Footprint.LayerUsed(eMidLayer26) :=false;
           Footprint.LayerUsed(eMidLayer27) :=false;
           Footprint.LayerUsed(eMidLayer28) :=false;
           Footprint.LayerUsed(eMidLayer29) :=false;
           Footprint.LayerUsed(eMidLayer30) :=false;

           Footprint.LayerUsed(eInternalPlane1) :=false;
           Footprint.LayerUsed(eInternalPlane2) :=false;
           Footprint.LayerUsed(eInternalPlane3) :=false;
           Footprint.LayerUsed(eInternalPlane4) :=false;
           Footprint.LayerUsed(eInternalPlane5) :=false;
           Footprint.LayerUsed(eInternalPlane6) :=false;
           Footprint.LayerUsed(eInternalPlane7) :=false;
           Footprint.LayerUsed(eInternalPlane8) :=false;
           Footprint.LayerUsed(eInternalPlane9) :=false;
           Footprint.LayerUsed(eInternalPlane10) :=false;
           Footprint.LayerUsed(eInternalPlane11) :=false;
           Footprint.LayerUsed(eInternalPlane12) :=false;
           Footprint.LayerUsed(eInternalPlane13) :=false;
           Footprint.LayerUsed(eInternalPlane14) :=false;
           Footprint.LayerUsed(eInternalPlane15) :=false;
       footprint.endModify;
end;
// Helper : Get user settings into data array
procedure GetSettings;
var
  p: double;
begin

   Str2Double(trim(txt_courtyardwidth.Text),p);
   settings_courtyard_linewidth    := MMsToCoord(p);

   Str2Double(trim(txt_courtyardgap.Text),p);
   settings_courtyard_clearance    := MMsToCoord(p);

   settings_courtyard_centroidsize := MMsToCoord(0.5);

   Str2Double(trim(txt_assemblylinewidth.Text),p);
   settings_assembly_linewidth     := MMsToCoord(p);

   Str2Double(trim(txt_AssemblyPinLineWith.Text),p);
   settings_assembly_padwidth      := MMsToCoord(p);

   Str2Double(trim( txt_silkscreenwidth.Text),p);
   settings_silkscreen_linewidth   := MMsToCoord(p);

   Str2Double(trim(txt_silktocopper.Text),p);
   settings_silkscreen_clearance   := MMsToCoord(p);

   settings_apply_2221_padsizing   := chk_apply2221.Checked;
   settings_remove_pin1dots        := chk_pin1removedots.Checked;
   settings_mark_pin1_on_courtyard := chk_pin1markoncourtyard.Checked;
   settings_mark_pin1_on_assembly  := chk_pin1markonassembly.Checked;
   settings_mark_pins_on_assembly  := chk_markassemblypins.Checked;
   settings_rebuild_courtyard      := true;

   settingS_rebuild_assembly       := chk_rebuildassembly.Checked;
   settings_rebuild_silkscreen     := chk_rebuildsilkscreen.Checked;
   settings_designator_add         := settings_rdio_adddesignator.Checked;
   settingS_designator_remove      := settings_rdio_removedesignator.Checked;
   settings_wipe_silkscreen        := chk_wipesilkscreen.Checked;

   if settings_rdio_pin1_leave.Checked = true then settings_pin1 :=0;
   if settings_rdio_pin1_square.Checked = true then settings_pin1 :=1;
   if settings_rdio_pin1_round.Checked = true then settings_pin1 :=2;

   settings_pastemask_retraction   := MMsToCoord(0.025);
   settings_pastemask_retract      := false;

   Str2Double(trim(txt_soldermask_to_smt.Text),p);
   settings_soldermask_smt         := mmstocoord(p);
   Str2Double(trim(txt_soldermask_to_mech.Text),p);
   settings_soldermask_mech        := mmstocoord(p);
   Str2Double(trim(txt_soldermask_to_via.Text),p);
   settings_soldermask_viahole     := mmstocoord(p);
   Str2Double(trim(txt_soldermask_to_th.Text),p);
   settings_soldermask_th          := mmstocoord(p);

  // Str2Double(trim(txt_thermal_holesize.Text),p);
  // settings_thermalfarm_holesize   := mmstocoord(p);
  // Str2Double(trim(txt_thermal_backpad.Text),p);
  // settings_thermalfarm_backpadsize := mmstocoord(p);
  // Str2Double(trim(txt_thermal_toppad.Text),p);
  // settings_thermalfarm_toppadsize := mmstocoord(p);
  // Str2Double(trim(txt_thermal_midpad.Text),p);
  // settings_thermalfarm_midpadsize := mmstocoord(p);
  // Str2Double(trim(txt_thermal_pitch.Text),p);
   //settings_thermalfarm_pitch      := mmstocoord(p);
   settings_processall             := chk_processall.Checked;
   settings_courtyard_pin1style := cmb_pin1style.ItemIndex;    // 0 = none , 1 arrow , 2 box

   settings_pin1indicatorlength := mmstocoord(0.75);

   get_Thermal_Settings;

end;

// this can only be run after all other cleanup routines
Procedure RebuildCourtyard;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     atrack               : IPCB_Track;
     xref                 : integer;
     yref                 : integer;
     leftedge : integer;
begin

     footprint.BeginModify;
     // fist nuke layer 15
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     // ----------------------------------------------------------------------------------------
     // destroy layer 15
     While (APrimitive <> Nil) Do
     begin
            // processing block
            aprimitive.Selected :=false;
            if aprimitive.Layer = eMechanical15 then aprimitive.Selected := true;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     resetparameters;
    // runprocess('PCB:Clear');
        runprocess('PCB:DeleteObjects');
     // ----------------------------------------------------------------------------------------
     // time to rebuild it
     // figure out how large this thing is ...
     Getenvelope;
     // ----------------------------------------------------------------------------------------
     // lets start with the centroid marker
     pcbserver.Preprocess;
     xref := footprint.board.xorigin;
     yref := footprint.board.yorigin;
     footprint.beginmodify;
     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := footprint.board.xorigin -settings_courtyard_centroidsize;
     atrack.x2 := footprint.board.xorigin ;
     atrack.y1 := footprint.board.yorigin ;
     atrack.y2 := footprint.board.yorigin ;
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;

     pcbserver.Preprocess;
     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := footprint.board.XOrigin ;
     atrack.x2 := footprint.board.xorigin + settings_courtyard_centroidsize;
     atrack.y1 := footprint.board.yorigin;
     atrack.y2 := footprint.board.yorigin;
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;

     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := footprint.board.xorigin ;
     atrack.x2 := footprint.board.xorigin;
     atrack.y1 := footprint.board.yorigin -settings_courtyard_centroidsize;
     atrack.y2 := footprint.board.yorigin;
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;

     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := footprint.board.xorigin ;
     atrack.x2 := footprint.board.xorigin;
     atrack.y1 := footprint.board.yorigin;
     atrack.y2 := footprint.board.yorigin+ settings_courtyard_centroidsize;
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;

     // ----------------------------------------------------------------------------------------
     // now build courtyard. use the data from GetEnvelope
     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
     atrack.x2 := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
     atrack.y1 := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,yref);
     atrack.y2 := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,yref);
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;

     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
     atrack.x2 := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
     atrack.y1 := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,yref);
     atrack.y2 := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,yref);
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;

     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
     atrack.x2 := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
     atrack.y1 := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,yref);
     atrack.y2 := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,yref);
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;

     atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
     atrack.width := settings_courtyard_linewidth;
     atrack.layer := eMechanical15;
     atrack.x1 := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
     atrack.x2 := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
     atrack.y1 := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,yref);
     atrack.y2 := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,yref);
     footprint.board.addpcbobject(atrack);
     PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
     pcbserver.PostProcess;
     pcbserver.Preprocess;
     // store the courtyard for later usage

//     settings_componentboundary.left := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
//     settings_componentboundary.right := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
//     settings_componentboundary.top := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,xref);
//     settings_componentboundary.bottom := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,xref);

     leftedge := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref); ;
     FindPin1;



     if SMTPin1Found then begin
        if settings_courtyard_pin1style = 1 then begin
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := leftedge; //RoundupToQuarterMMCoord(pin1bound.left - settings_courtyard_clearance + settings_soldermask_smt,xref);
           atrack.x2 := pin1bound.left;
           atrack.y1 := pin1bound.top;
           atrack.y2 := pin1bound.top - (pin1bound.top-pin1bound.bottom)/2;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.left;
           atrack.x2 := leftedge; //RoundupToQuarterMMCoord(pin1bound.left -settings_courtyard_clearance + settings_soldermask_smt,xref);
           atrack.y1 := pin1bound.bottom + (pin1bound.top-pin1bound.bottom)/2;
           atrack.y2 := pin1bound.bottom ;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
        end;
        if settings_courtyard_pin1style = 2 then begin
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := leftedge; //RoundupToQuarterMMCoord(pin1bound.left - settings_courtyard_clearance + settings_soldermask_smt,xref);
           atrack.x2 := pin1bound.left+ ((pin1bound.right-pin1bound.left)/2);
           atrack.y1 := pin1bound.top;
           atrack.y2 := pin1bound.top - ((pin1bound.top-pin1bound.bottom)/2);
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.left+ ((pin1bound.right-pin1bound.left)/2);
           atrack.x2 := leftedge; //RoundupToQuarterMMCoord(pin1bound.left -settings_courtyard_clearance + settings_soldermask_smt,xref);
           atrack.y1 := pin1bound.bottom + (pin1bound.top-pin1bound.bottom)/2;
           atrack.y2 := pin1bound.bottom ;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
        end;
        if (settings_courtyard_pin1style = 3) or (settings_courtyard_pin1style = 4) then begin
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.left+ settings_soldermask_smt;
           atrack.x2 := pin1bound.right-+ settings_soldermask_smt;
           atrack.y1 := pin1bound.bottom+ settings_soldermask_smt;
           atrack.y2 := pin1bound.bottom+ settings_soldermask_smt;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.left+ settings_soldermask_smt;
           atrack.x2 := pin1bound.right - settings_soldermask_smt;
           atrack.y1 := pin1bound.top- settings_soldermask_smt;
           atrack.y2 := pin1bound.top- settings_soldermask_smt;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.left+ settings_soldermask_smt;
           atrack.x2 := pin1bound.left+ settings_soldermask_smt;
           atrack.y1 := pin1bound.top- settings_soldermask_smt;
           atrack.y2 := pin1bound.bottom+ settings_soldermask_smt;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
           atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
           atrack.width := mmstocoord(0.05);
           atrack.layer := eMechanical15;
           atrack.x1 := pin1bound.right- settings_soldermask_smt;
           atrack.x2 := pin1bound.right- settings_soldermask_smt;
           atrack.y1 := pin1bound.top- settings_soldermask_smt;
           atrack.y2 := pin1bound.bottom+ settings_soldermask_smt;
           footprint.board.addpcbobject(atrack);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
           pcbserver.PostProcess;
           pcbserver.Preprocess;
        end;
        if (settings_courtyard_pin1style = 4) then begin
            pcbserver.Preprocess;
            atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
            atrack.width := mmstocoord(0.05);
            atrack.layer := eMechanical15;
            atrack.x1 := pin1bound.left+ settings_soldermask_smt;
            atrack.x2 := pin1bound.right- settings_soldermask_smt;
            atrack.y1 := pin1bound.top- settings_soldermask_smt;
            atrack.y2 := pin1bound.bottom+ settings_soldermask_smt;
            footprint.board.addpcbobject(atrack);
            PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
            pcbserver.PostProcess;
            pcbserver.Preprocess;
            atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
            atrack.width := mmstocoord(0.05);
            atrack.layer := eMechanical15;
            atrack.x1 := pin1bound.right- settings_soldermask_smt;
            atrack.x2 := pin1bound.left+ settings_soldermask_smt;
            atrack.y1 := pin1bound.top- settings_soldermask_smt;
            atrack.y2 := pin1bound.bottom+ settings_soldermask_smt;
            footprint.board.addpcbobject(atrack);
            PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
            pcbserver.PostProcess;
        end;
        // now store pin1 boundary for later use
        if (Pin1Found or SMTPin1Found) then begin
       // settings_pin1boundary :=TCoordRect.create;

        settings_componentboundary := pin1pad.BoundingRectangle;
        settings_componentboundary.left := RoundupToQuarterMMCoord(minx - settings_courtyard_clearance,xref);
        settings_componentboundary.right := RoundupToQuarterMMCoord(maxx + settings_courtyard_clearance,xref);
        settings_componentboundary.top := RoundupToQuarterMMCoord(maxy + settings_courtyard_clearance,xref);
        settings_componentboundary.bottom := RoundupToQuarterMMCoord(miny - settings_courtyard_clearance,xref);
        settings_pin1boundary := pin1pad.BoundingRectangle;
        settings_pin1boundary.left   := settings_pin1boundary.left   + settings_soldermask_smt;
        settings_pin1boundary.right  := settings_pin1boundary.right  - settings_soldermask_smt;
        settings_pin1boundary.top    := settings_pin1boundary.top    - settings_soldermask_smt;
        settings_pin1boundary.bottom := settings_pin1boundary.bottom + settings_soldermask_smt;
     end
     else settings_pin1boundary := nil;

        end;
        footprint.endmodify;
        footprint.GraphicallyInvalidate;
        footprint.board.viewmanager_fullupdate;
        ResetParameters;
        AddStringParameter('Action', 'Document');
        RunProcess('PCB:Zoom');
end;

{var
  footprint : IPCB_LibComponent;}
{ Procedure CreateTrack (x1,y1,x2,y2,Layer,width);
var
    atrack :ipcb_track;
Begin
    atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
    atrack.width := mmstocoord(width);
    atrack.layer := layer;
    atrack.x1 := mmstocoord(x1);
    atrack.x2 := mmstocoord(x2);
    atrack.y1 := mmstocoord(y1);
    atrack.y2 := mmstocoord(y2);
    footprint.board.addpcbobject(atrack);
    PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
End;  }
{Procedure CreatePad (x,y,length,width,Layer,holesize,shape);
var
    apad :ipcb_pad;
Begin
    apad := pcbserver.PCBObjectFactory(ePadObject,eNoDimension,eCreate_Default);
    apad.Mode     := ePadMode_Simple;
    apad.HoleType := eRoundHole
    apad.Plated   := true;
    apad.TopShape :=shape;
    apad.TopXSize = mmstocoord(length);
    apad.TopySize = mmstocoord(width);
    apad.layer := layer;
    apad.x := mmstocoord(x);
    apad.x := mmstocoord(x);
    footprint.board.addpcbobject(apad);
    PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,apad.I_ObjectAddress);
End;}

{Procedure CreatePart;
begin
   // draw centroid
   Createtrack (0,0,5,0,eMechanical15,0.1);
   Createtrack (0,0,-5,0,eMechanical15,0.1);
   Createtrack (0,0,0,5,eMechanical15,0.1);
   Createtrack (0,0,0,-5,eMechanical15,0.1);
   // draw courtyard
   Createtrack (-10,10,10,10,eMechanical15,0.1);
   Createtrack (-10,-10,10,-10,eMechanical15,0.1);
   Createtrack (-10,10,-10,-10,eMechanical15,0.1);
   Createtrack (10,10,10,-10,eMechanical15,0.1);
   // draw outline
   Createtrack (8,8,-8,8,eTopoverlay,0.1);
   // ...
   Createpad (5,5,1.2,2.1,eToplayer,0,eRoundedrectangle);
   // ...
end;

}
procedure AssemblyLayerMakePads();
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     boundarea            : tcoordrect;
     maxx                 : integer;
     maxy                 : integer;
     minx                 : integer;
     miny                 : integer;
     aTrack               : iPCB_track;
     q                    : integer;
     anArc                : IPCB_Arc;
 begin

     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     maxx :=footprint.board.xorigin;
     minx :=footprint.board.xorigin;
     maxy :=footprint.board.yorigin;
     miny :=footprint.board.yorigin;
     While (APrimitive <> Nil) Do
     begin
         aprimitive.Selected :=false;
         if aprimitive.objectid = ePadObject then begin
            // if the pad has a hole : draw it
            if aprimitive.holesize <>0 then begin
                pcbserver.Preprocess;
                boundarea := aprimitive.BoundingRectangle;
                anarc := pcbserver.PCBObjectFactory(eArcObject,eNoDimension,eCreate_Default);
                anarc.XCenter := boundarea.left + ((boundarea.right-boundarea.left)/2);
                anarc.YCenter := boundarea.bottom + ((boundarea.top-boundarea.bottom)/2);
                anarc.EndAngle := 360;
                anarc.StartAngle := 360;
                anarc.Layer := eMechanical13;
                anarc.LineWidth := settings_assembly_padwidth;
                anarc.Radius := aprimitive.holesize/2;
                footprint.board.addpcbobject(anarc);
                PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,anarc.I_ObjectAddress);
                pcbserver.PostProcess;
            end;

            if (aprimitive.topshape = eRounded) then begin
              if aprimitive.XSizeOnLayer(eTopLayer) <> aprimitive.ySizeOnLayer(eTopLayer) then
              begin
                 // todo : mark oblong pads ....
              end
              else begin
                pcbserver.Preprocess;
                boundarea := aprimitive.BoundingRectangle;
                anarc := pcbserver.PCBObjectFactory(eArcObject,eNoDimension,eCreate_Default);
                anarc.XCenter := boundarea.left + ((boundarea.right-boundarea.left)/2);
                anarc.YCenter := boundarea.bottom + ((boundarea.top-boundarea.bottom)/2);
                anarc.EndAngle := 360;
                anarc.StartAngle := 360;
                anarc.Layer := eMechanical13;
                anarc.LineWidth := settings_assembly_padwidth;

                anarc.Radius := aprimitive.ySizeOnLayer(eTopLayer)/2;

                footprint.board.addpcbobject(anarc);
                PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,anarc.I_ObjectAddress);
                pcbserver.PostProcess;

              end;



            end;
            if (aprimitive.topshape = eRectangular) or (aprimitive.topshape = eRoundedRectangular) then begin
               boundarea := aprimitive.BoundingRectangle;
             //  if aprimitive.name ='1' then begin
             //     if settings_mark_pin1_on_assembly = true then begin
             //        // todo : mark pin 1 on assembly if
             //     end;
             //  end;
               atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
               atrack.width := settings_assembly_padwidth;
               atrack.layer := eMechanical13;
               atrack.x1 := boundarea.left+settings_soldermask_smt ;
               atrack.x2 := boundarea.left+settings_soldermask_smt ;
               atrack.y1 := boundarea.top-settings_soldermask_smt ;
               atrack.y2 := boundarea.bottom+settings_soldermask_smt ;
               footprint.board.addpcbobject(atrack);
               PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
               pcbserver.PostProcess;
               pcbserver.Preprocess;

               atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
               atrack.width := settings_assembly_padwidth;
               atrack.layer := eMechanical13;
               atrack.x1 := boundarea.right-settings_soldermask_smt  ;
               atrack.x2 := boundarea.right-settings_soldermask_smt ;
               atrack.y1 := boundarea.top-settings_soldermask_smt ;
               atrack.y2 := boundarea.bottom+settings_soldermask_smt ;
               footprint.board.addpcbobject(atrack);
               PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
               pcbserver.PostProcess;
               pcbserver.Preprocess;

               atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
               atrack.width := settings_assembly_padwidth;
               atrack.layer := eMechanical13;
               atrack.x1 := boundarea.left+settings_soldermask_smt ;
               atrack.x2 := boundarea.right-settings_soldermask_smt ;
               atrack.y1 := boundarea.top-settings_soldermask_smt ;
               atrack.y2 := boundarea.top-settings_soldermask_smt ;
               footprint.board.addpcbobject(atrack);
               PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
               pcbserver.PostProcess;
               pcbserver.Preprocess;

               atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
               atrack.width := settings_assembly_padwidth;
               atrack.layer := eMechanical13;
               atrack.x1 := boundarea.left+settings_soldermask_smt ;
               atrack.x2 := boundarea.right-settings_soldermask_smt ;
               atrack.y1 := boundarea.bottom+settings_soldermask_smt ;
               atrack.y2 := boundarea.bottom +settings_soldermask_smt;
               footprint.board.addpcbobject(atrack);
               PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
               pcbserver.PostProcess;
               pcbserver.Preprocess;
           end;
         end;
         APrimitive := ObjIterator.NextPCBObject;
     end;

end;

procedure RebuildSilkScreen;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     boundarea            : tcoordrect;
     maxx                 : integer;
     maxy                 : integer;
     minx                 : integer;
     miny                 : integer;
     aTrack               : iPCB_track;
     TextObj              : IPCB_Text;
     Textobj3             : ipcb_text3;
     p                    : ipcb_text;
     afill                : IPCB_Fill;
     fill                : IPCB_Fill;
begin
      // settings_componentboundary
      // settings_pin1boundary

      if settings_pin1boundary <>nil then begin
      {   atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
         atrack.width := milstocoord(6);
         atrack.layer := eTopOverlay;
         atrack.x1 := settings_componentboundary.left +milstocoord(3) ;
         atrack.x2 := settings_componentboundary.left +milstocoord(3) ;
         atrack.y1 := settings_componentboundary.top -milstocoord(3) ;
         atrack.y2 := settings_pin1boundary.bottom +milstocoord(3) ;
         footprint.board.addpcbobject(atrack);
         PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
       }  atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
         atrack.width := milstocoord(6);
         atrack.layer := eTopOverlay;
         atrack.x1 := settings_componentboundary.left +mmstocoord(6*0.025) ;
         atrack.x2 := settings_componentboundary.left +mmstocoord(6*0.025) +settings_pin1indicatorlength; //settings_pin1boundary.right -mmstocoord(3*0.025) ;
         atrack.y1 := settings_componentboundary.top -mmstocoord(6*0.025) ;
         atrack.y2 := settings_componentboundary.top -mmstocoord(6*0.025) ;
         footprint.board.addpcbobject(atrack);
         atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
         atrack.width := milstocoord(6);
         atrack.layer := eTopOverlay;
         atrack.x1 := settings_componentboundary.left +mmstocoord(6*0.025) ;
         atrack.x2 := settings_componentboundary.left +mmstocoord(6*0.025) ;
         atrack.y1 := settings_componentboundary.top -mmstocoord(6*0.025) ;
         atrack.y2 := settings_componentboundary.top -mmstocoord(6*0.025) -settings_pin1indicatorlength; //settings_componentboundary.top +mmstocoord(3*0.025) -( settings_pin1boundary.right-settings_componentboundary.left);
         footprint.board.addpcbobject(atrack);
         PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
      end;
end;

Procedure BuildAssembly;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
     boundarea            : tcoordrect;
     maxx                 : integer;
     maxy                 : integer;
     minx                 : integer;
     miny                 : integer;
     aTrack               : iPCB_track;
     TextObj              : IPCB_Text;
     Textobj3             : ipcb_text3;
     p                    : ipcb_text;
     afill                : IPCB_Fill;
      fill                : IPCB_Fill;
begin

     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     maxx :=footprint.board.xorigin;
     minx :=footprint.board.xorigin;
     maxy :=footprint.board.yorigin;
     miny :=footprint.board.yorigin;
     While (APrimitive <> Nil) Do
     begin
            // Sweep over the 3d models
            aprimitive.Selected :=false;
            if (aprimitive.Layer = eMechanical1) then begin
                foundsomething := 1 ;
                boundarea := aprimitive.BoundingRectangle;
                if boundarea.left <minx then minx := boundarea.left;
                if boundarea.right>maxx then maxx := boundarea.right;
                if boundarea.bottom <miny then miny := boundarea.bottom;
                if boundarea.top >maxy then maxy := boundarea.top;
            end;
            // destroy layer 13
            aprimitive.Selected :=false;
            if aprimitive.Layer = eMechanical13 then begin
             //  if aprimitive.objectid <> eTextObject then begin  // but leave the .designators.

                  //if (aprimitive.ObjectId = eTrackObject)  then aprimitive.MOVABLE   := TRUE;
                  //IF (aprimitive.ObjectId = eArcObject)    then aprimitive.MOVABLE   := TRUE;

                //  IF (aprimitive.ObjectId = eFillObject)    then aprimitive.MOVABLE   := TRUE;
                  if (aprimitive.ObjectId = eTextObject) then aprimitive.moveable :=true;
                  aprimitive.Selected := true;
             //  end;
            end;
            APrimitive := ObjIterator.NextPCBObject;
     end;

     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin                                           // if nothing was found we have no 3d body . so skip this.
        resetparameters;
        runprocess('PCB:DeleteObjects');  // pcb:Clear is defunct in nexus 4

        atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
        atrack.width := settings_assembly_linewidth;
        atrack.layer := eMechanical13;
        atrack.x1 := minx ;
        atrack.x2 := minx ;
        atrack.y1 := maxy ;
        atrack.y2 := miny ;
        footprint.board.addpcbobject(atrack);
        PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
        pcbserver.PostProcess;
        pcbserver.Preprocess;

        atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
        atrack.width := settings_assembly_linewidth;
        atrack.layer := eMechanical13;
        atrack.x1 := maxx  ;
        atrack.x2 := maxx ;
        atrack.y1 := maxy ;
        atrack.y2 := miny ;
        footprint.board.addpcbobject(atrack);
        PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
        pcbserver.PostProcess;
        pcbserver.Preprocess;

        atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
        atrack.width := settings_assembly_linewidth;
        atrack.layer := eMechanical13;
        atrack.x1 := minx ;
        atrack.x2 := maxx ;
        atrack.y1 := miny ;
        atrack.y2 := miny ;
        footprint.board.addpcbobject(atrack);
        PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
        pcbserver.PostProcess;
        pcbserver.Preprocess;

        atrack := pcbserver.PCBObjectFactory(eTrackObject,eNoDimension,eCreate_Default);
        atrack.width := settings_assembly_linewidth;
        atrack.layer := eMechanical13;
        atrack.x1 := minx ;
        atrack.x2 := maxx ;
        atrack.y1 := maxy ;
        atrack.y2 := maxy ;
        footprint.board.addpcbobject(atrack);
        PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,atrack.I_ObjectAddress);
        pcbserver.PostProcess;

        if settings_mark_pins_on_assembly = true then begin
           AssemblyLayerMakePads;

        end;
        if settings_designator_add = true then begin
           designator_object := PCBServer.PCBObjectFactory(eTextObject, eNoDimension, eCreate_Default);
           designator_object.Layer      :=  eMechanical13;
           designator_object.Text       :=  '.DESIGNATOR';
           designator_object.UseTTFonts := false;
           designator_object.Size       := MilsToCoord(10);
           designator_object.width      := MilsToCoord(1);
           designator_object.rotation   := MilsToCoord(0);
           designator_object.Bold       := false;
           designator_object.Inverted   := false;
           designator_object.InvertedTTTextBorder := MMsToCoord(0.02);
           designator_object.TTFInvertedTextJustify :=5;
           designator_object.Multiline  := true;
           designator_object.X1Location := minx;
           designator_object.y1Location := miny;
           designator_object.X2Location := maxx;
           designator_object.y2Location := maxy;
           designator_object.XLocation  := minx;
           designator_object.yLocation  := miny;
           designator_object.UseInvertedRectangle :=true;
        //   ShowMessage(FloatToStr(CoordToMMs(designator_object.X2Location)));

           while (designator_object.x2Location > maxx)do begin
              designator_object.Size       := designator_object.Size - MilsToCoord(1);
              designator_object.x2Location := maxx;
           end;
           Footprint.board.AddPCBObject(designator_object);
           PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,designator_object.I_ObjectAddress);
           pcbserver.PostProcess;
       //    ShowMessage(floatToStr(CoordToMMs(designator_object.X2Location)));
        end;

        if settings_mark_pin1_on_assembly = true then begin
           if pin1pad <> nil then begin
              pcbserver.Preprocess;
              // when creating these kind of object the execution order is important !!!
              // certain translation commands override other position commands and nullify the command !
              TextObj := PCBServer.PCBObjectFactory(eTextObject, eNoDimension, eCreate_Default);
              TextObj.Layer     :=  eMechanical13;
              TextObj.Text      :=  '1';
              textobj.UseTTFonts :=true;
              TextObj.Size      :=  MilsToCoord(12);
              TextObj.width     :=  MilsToCoord(2);
              TextObj.rotation  :=  MilsToCoord(0);
              textobj.Bold      := true;
              textobj.Inverted  := true;
              textobj.InvertedTTTextBorder := MMsToCoord(0.02);
              textobj.TTFInvertedTextJustify :=5;
              textobj.Multiline :=true;
              boundarea :=pin1pad.BoundingRectangle;
              textobj.X1Location :=boundarea.left+settings_soldermask_smt;
              textobj.y1Location :=boundarea.bottom+settings_soldermask_smt;
              textobj.X2Location :=boundarea.right-settings_soldermask_smt;
              textobj.y2Location :=boundarea.top-settings_soldermask_smt;

              textobj.XLocation := boundarea.left+settings_soldermask_smt;
              textobj.yLocation := boundarea.bottom+settings_soldermask_smt;

           //   textobj.TTFTextHeight := MMsToCoord(3);
           //   textobj.TTFTextwidth  := MMsToCoord(1.5);

              Footprint.board.AddPCBObject(TextObj);
              PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,textobj.I_ObjectAddress);
              pcbserver.PostProcess;

          // lets try a fill instead
          //    pcbserver.Preprocess;
          //    afill := pcbserver.PCBObjectFactory(eFillObject,eNoDimension,eCreate_Default);
          //    boundarea :=pin1pad.BoundingRectangle;
          //    afill.X1Location :=boundarea.left;
          //    afill.y1Location :=boundarea.bottom;
          //    afill.X2Location :=boundarea.right;
          //    afill.y2Location :=boundarea.top;
          //    afill.Layer :=eMechanical13;
          //    footprint.board.AddPCBObject(afill);
          //    PCBServer.SendMessageToRobots(footprint.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,afill.I_ObjectAddress);
              pcbserver.PostProcess;
           end;
        end;
     end;
     footprint.EndModify;
end;

procedure TrackProcessor;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     While (APrimitive <> Nil) Do
     begin
            // processing block

               aprimitive.Selected :=false;
               // --------------------------------------------------------------------------------------------------------------------------
               // process tracks
               // --------------------------------------------------------------------------------------------------------------------------
               if APrimitive.objectid   = eTrackObject then Begin
                  if APrimitive.Layer = eTopOverlay then begin
                     APrimitive.width := settings_silkscreen_linewidth;
                  end;
                  if APrimitive.Layer = eBottomOverlay then begin
                     APrimitive.width := settings_silkscreen_linewidth;
                  end;
                  if APrimitive.Layer = eMechanical13 then begin
                     APrimitive.width := settings_assembly_linewidth;
                  end;
                  if APrimitive.Layer = eMechanical15 then begin
                     APrimitive.width := settings_courtyard_linewidth;
                  end;
                  if APrimitive.Layer = eMechanical16 then begin
                     APrimitive.width := settings_courtyard_linewidth;
                  end;
               End;

               // --------------------------------------------------------------------------------------------------------------------------
               // Process arcs
               // --------------------------------------------------------------------------------------------------------------------------
               if APrimitive.objectid   = eArcObject then Begin
                  if (APrimitive.Layer = eTopOverlay) or (APrimitive.Layer = eBottomOverlay) then begin
                     APrimitive.linewidth := settings_silkscreen_linewidth;

                  end;
                  if APrimitive.Layer = eMechanical13 then begin
                     APrimitive.linewidth := settings_assembly_linewidth;
                  end;
                  if APrimitive.Layer = eMechanical15 then begin
                     APrimitive.linewidth := settings_courtyard_linewidth;
                  end;
                  if APrimitive.Layer = eMechanical16 then begin
                     APrimitive.linewidth := settings_courtyard_linewidth;
                  end;

                  // hunt for dots ....
                  if  (APrimitive.Layer = eMechanical13) or
                      (APrimitive.Layer = eTopOverlay)   or
                      (APrimitive.Layer = eBottomOverlay) then begin

                      if APrimitive.radius = MMsToCoord(0.25) then begin  // it's a dot !!
                        APrimitive.linewidth := MMsToCoord(0.25);
                        if settings_remove_pin1dots = true then aprimitive.Selected :=true;
                      end;
                      if APrimitive.radius = MMsToCoord(0.125) then begin // it's a dot !!
                        APrimitive.linewidth := MMsToCoord(0.25) ;
                        if settings_remove_pin1dots = true then aprimitive.Selected :=true;
                      end;
                   end;
               if settings_remove_pin1dots = true then begin
                 resetparameters;
               //  runprocess('PCB:Clear');
                 runprocess('PCB:DeleteObjects');
               End;

       end;
               APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     if foundsomething = 1 then begin
        LogMSG('  -> Deleted Restriced Stuff');
     end;
     footprint.EndModify;

end;

Procedure Padprocessor;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;

     PIN1PAD := nil;
     pin1bound :=nil;
     smtpin1found :=false;

     While (APrimitive <> Nil) Do
     begin
            // processing block
            // --------------------------------------------------------------------------------------------------------------------------
            // check pads
            // --------------------------------------------------------------------------------------------------------------------------
            if (APrimitive.objectid = ePadObject)  then begin

               // .......................................................................................................................
               // multilayer pad check
               // .......................................................................................................................
               // - if pad smaller than drillstrike : pads should be zero and non plated.
               // - set pin 1 rectangle , others round.
               // - set soldermask expansion mode to  'from holeedge'
               // - set soldermask expansion to 0.1mm
               // - set to simple mode
               // - set plated on non electrical pads : non plated on mechanical

               // APrimitive.Mode := ePadMode_Simple;
               if (APrimitive.layer = eMultiLayer ) then begin
                  APrimitive.Mode := ePadMode_Simple;
                  APrimitive.Plated := true;

                  // todo : slotted holes

                  // check if this thing is round ! we don't muck with slots !!!
                  if (APrimitive.HoleType = eRoundHole) then begin
                     // set pin 1 rectangle: others round
                     if APrimitive.Name = '1' then begin
                       if settings_pin1 =1 then  APrimitive.topshape := eRectangular;
                       if settings_pin1 =2 then  APrimitive.topshape := eRounded;
                     end
                     else begin
                          APrimitive.topshape := eRounded;
                        end;

                        // clean up non plated holes
                        // if pad is smaller or equal than hole : set pad to zero
                        if APrimitive.TopXSize <= APrimitive.HoleSize then begin
                           APrimitive.TopXSize := mmstocoord(0);
                        end;
                        if APrimitive.botXSize <= APrimitive.HoleSize then begin
                           APrimitive.botXSize := mmstocoord(0);
                        end;
                        if APrimitive.TopySize <= APrimitive.HoleSize then begin
                           APrimitive.TopySize := mmstocoord(0);
                        end;
                        if APrimitive.botySize <= APrimitive.HoleSize then begin
                           APrimitive.botySize := mmstocoord(0);
                        end;
                        // see if it is non plated ...
                        If APrimitive.plated = false then begin
                          APrimitive.TopySize := mmstocoord(0);
                          APrimitive.botySize := mmstocoord(0);
                          APrimitive.TopXSize := mmstocoord(0);
                          APrimitive.botXSize := mmstocoord(0);
                        end;

                        // if padsize is now zero : unplate it
                        if APrimitive.topxsize = mmstocoord(0) then begin
                           APrimitive.Plated := false;
                        end;

                        // set soldermask pullback

                        if APrimitive.plated= false then begin
                           APrimitive.SolderMaskExpansionFromHoleEdge := true;
                           viacache := APrimitive.GetState_Cache;
                           viacache.SolderMaskExpansion := settings_soldermask_mech;
                           Viacache.SolderMaskExpansionValid := eCacheManual;
                           APrimitive.SetState_Cache := Viacache;
                        end
                        else begin
                           APrimitive.SolderMaskExpansionFromHoleEdge := false;
                           viacache := APrimitive.GetState_Cache;
                           viacache.SolderMaskExpansion := settings_soldermask_th;
                           Viacache.SolderMaskExpansionValid := eCacheManual;
                           APrimitive.SetState_Cache := Viacache;
                        end;

                        if APrimitive.plated = true then begin
                           // todo : verify ipc2221 formula
                           if settings_apply_2221_padsizing = true then begin
                              holesize := CoordToMMs(APrimitive.holesize);
                              padsize := CoordToMMs(APrimitive.topxsize);

                           // ipc 7351c / PCBlibraries equation :
                              padsize := Roundup_1Decimal (holesize * 1.5)  ;
                              APrimitive.TopySize := mmstocoord(padsize);
                              APrimitive.botySize := mmstocoord(padsize);
                              APrimitive.TopXSize := mmstocoord(padsize);
                              APrimitive.botXSize := mmstocoord(padsize);
                           end;
                        end;

                        end;
                  end;

                  // .......................................................................................................................
                  // SMT pads check
                  // .......................................................................................................................
                  // - make sure plated flag is on.
                  // - pin 1 rectangle
                  // - others rounded rectangle with 25% pullback

                  if (APrimitive.layer = eTopLayer) or
                     (APrimitive.layer = eBottomLayer) then begin                                                                              //
                     APrimitive.Plated := true;
                    // set everything to rounded rectangle . we will deal with pin 1 later ...

                     APrimitive.topshape := eRoundedRectangular;
                     viacache := APrimitive.GetState_Cache;
                     viacache.SolderMaskExpansion := settings_soldermask_smt;
                     Viacache.SolderMaskExpansionValid := eCacheManual;
                     APrimitive.SetState_Cache := Viacache;

                     // cast the pad as type ipcb_pad2 to get to the cornerradius
                     APAD2 :=APrimitive ;
                     apad2.SetState_StackCRPctOnLayer (etoplayer, 25);

                      boundarea := APrimitive.BoundingRectangle;
                      boundarea.left := boundarea.left + settings_soldermask_smt;
                      boundarea.right := boundarea.right - settings_soldermask_smt;
                      boundarea.top := boundarea.top - settings_soldermask_smt;
                      boundarea.bottom := boundarea.bottom + settings_soldermask_smt;
                      // STORE PIN1 SO WE CAN MUCK WITH IT LATER
                      if APrimitive.name = '1' then begin
                          PIN1PAD := APrimitive;
                          pin1bound :=boundarea;
                          smtpin1found :=true;
                      end;
                  end;
                  // include possible thruhole pads
                  if APrimitive.name = '1' then begin
                          PIN1PAD := APrimitive;
                          pin1bound :=boundarea;
                  end;
               end;

            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     footprint.EndModify;
end;

Procedure ViaProcessor;
var
     ObjIterator          : IPCB_GroupIterator;
     APrimitive           : IPCB_Primitive;
     foundsomething       : integer;
begin
     footprint.BeginModify;
     ObjIterator := Footprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     foundsomething := 0;
     While (APrimitive <> Nil) Do
     begin
         if (APrimitive.objectid = eViaObject)  then begin
            if (APrimitive.holesize <= settings_thermal_holesize) then begin
               APrimitive.holesize :=settings_thermal_holesize;
            end;
            // cast to via object
            avia := APrimitive;
            // no tenting and no testpoint
            avia.IsTenting := false;
            avia.IsTenting_Bottom :=false;
            avia.IsTenting_top :=false;
            avia.IsTestpoint_Bottom := false;
            avia.IsTestpoint_Top := false;
            avia.IsAssyTestpoint_Bottom :=false;
            avia.IsAssyTestpoint_Top := false;

            // local stack
            avia.Mode := ePadMode_LocalStack;
            if avia.SizeOnLayer(eTopLayer)   <= settings_thermal_toppad  then avia.SizeOnLayer(eTopLayer)    := settings_thermal_toppad ;
            if avia.sizeonlayer(eMidLayers)  <= settings_thermal_midpad  then avia.sizeonlayer(eMidLayers)   := settings_thermal_midpad ;
            if avia.sizeonlayer(eBottomLayer)<= settings_thermal_bottompad then avia.sizeonlayer(eBottomLayer) := settings_thermal_bottompad;
            apad :=avia;


            // cast back
            APrimitive := apad;
            APrimitive.SolderMaskExpansionFromHoleEdge := true;
            viacache := APrimitive.GetState_Cache;
            // todo : via mask expansion setting
            viacache.SolderMaskExpansion := settings_soldermask_viahole;
            Viacache.SolderMaskExpansionValid := eCacheManual;
            APrimitive.SetState_Cache := Viacache;
               end;
            APrimitive := ObjIterator.NextPCBObject;
     end;
     Footprint.GroupIterator_Destroy(ObjIterator);
     footprint.EndModify;
end;

procedure test;
var
  LOOPCOUNTER          : INTEGER;
begin
     memo1.clear;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;                                                             // Grab the library
     If CurrentLib = Nil Then
     Begin
        LogMSG('This is not a PCB library document');
        Exit;
     End;                                                                                                      // run any hanging commands first and cleanup the command stack

    ResetParameters;
    AddStringParameter('Action', 'Document');
    RunProcess('PCB:Zoom');
    GetSettings;
    FootprintIterator := CurrentLib.LibraryIterator_Create;
    FootprintIterator.SetState_FilterAll;


    Try
        For loopcounter := 0 to currentlib.ComponentCount -1 do
        Begin
            footprint := currentlib.GetComponent(loopcounter);
            currentlib.CurrentComponent := footprint;
            footprint.AllowGlobalEdit := true;
            footprint.PrimitiveLock :=false;
            footprint.BeginModify;
            DeleterestrictedStuff;
            AssignHeight;
            FixDesignator;
            trackprocessor;
            viaprocessor;
            if chk_rebuildassembly.Checked = true then BuildAssembly;
            RebuildCourtyard;

            footprint.endModify;
            footprint.GraphicallyInvalidate;
            footprint.board.viewmanager_fullupdate;
            ResetParameters;
            AddStringParameter('Action', 'Document');
            RunProcess('PCB:Zoom');
        End;
    Finally
//        CurrentLib.LibraryIterator_Destroy(FootprintIterator);
    End;
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Initial cleanups
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
           footprint := currentlib.GetComponent(loopcounter);
end;

procedure CleanupCurrentfootprint;
begin
       ResetParameters;
       AddStringParameter('Action', 'Document');
       RunProcess('PCB:Zoom');
       LogMSG('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
       footprint := currentlib.CurrentComponent;
       if footprint.Name<> '---SYMBOLS' then begin
          LogMSG ('Processing Part : ' + footprint.name);
          DeleterestrictedStuff;
          AssignHeight;
          FixDesignator;
          TrackProcessor;
          ViaProcessor;
          Padprocessor;
              // it is important that the courtyard / assembly / silkscreen builders are run AFTER the pad processor
              // as the padprocessor extracts the pin 1 information !
          if settingS_rebuild_assembly = true then BuildAssembly;
          if settings_rebuild_courtyard = true then RebuildCourtyard;
          if settings_rebuild_silkscreen = true then RebuildSilkScreen;
              // if more than 2 smt pins : make pin 1 rectangular
              //      if (maxpinnumber > 2) then begin
              //         pin1pad.stackShapeOnLayer(etoplayer) := eRectangular;
              //         pin1pad.topshape := eRectangular;
              //     end;
          end
          else begin
              LogMSG ('Skipped Librarian Part : ' + footprint.name);
          end;
          CurrentLib.board.ViewManager_FullUpdate      ;
end;

Procedure CleanupVAULTFootprints;
Var
    LoopCounter          : INTEGER;
    pinnumber            : integer;
    holesize             : real;
    padsize              : real;
    ViaCache             : TPadCache;
    descr                : Tstring;
    blah                 : integer;
    Tracklist            : TInterfaceList;
    I                    : INTEGER;
      tcount             : integer;
      qq                 : pwidechar;
      qs                 : WideString;
      BOUND              : TCoordRect;


Begin

     GetSettings;
     De_Carlify;

     FootprintIterator := CurrentLib.LibraryIterator_Create;
     FootprintIterator.SetState_FilterAll;
     Try
        For loopcounter := 0 to currentlib.ComponentCount -1 do
        Begin
           footprint := currentlib.GetComponent(loopcounter);
           currentlib.CurrentComponent := footprint;
           CleanupCurrentfootprint;
           Footprint.GroupIterator_Destroy(ObjIterator);
        End;
    Finally
        CurrentLib.LibraryIterator_Destroy(FootprintIterator);
    End;

End;

procedure TForm1.Button1Click(Sender: TObject);
begin
     getsettings;
     PCBServer.PreProcess;
     memo1.clear;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;
     If CurrentLib = Nil Then
     Begin
        LogMSG('This is not a PCB library document');
        Exit;
     End;
     resetstyle           ;
     IF  chk_processall.Checked then CleanupVAULTFootprints else CleanupCurrentfootprint ;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     CurrentLib.Board.ViewManager_FullUpdate;
     refresh_screen;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
     getsettings;
     settings_rebuild_silkscreen :=true;
     PCBServer.PreProcess;
     memo1.clear;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;
     If CurrentLib = Nil Then
     Begin
        LogMSG('This is not a PCB library document');
        Exit;
     End;
     IF  chk_processall.Checked then CleanupVAULTFootprints else CleanupCurrentfootprint ;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     CurrentLib.Board.ViewManager_FullUpdate;
     refresh_screen;
     settings_rebuild_silkscreen :=false;
end;





procedure TForm1.Button3Click(Sender: TObject);
begin
     memo1.lines.clear;
     unlock_process;
     logmsg ('Altium::PCBserver Processes Unlocked');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     graballpads;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     ResetStyle;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     setpin1square;
end;













// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// HOLEWIZARD
//
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

var
  round_pindiameter : double;
  round_holediameter : double;
  round_paddiameter : double;

  square_pinlength :double;
  square_pinwidth :double;
  square_pindiameter :double;
  square_holediameter :double;
  square_paddiameter :double;

  slot_hole_width : double;
  slot_hole_length : double;
  slot_pad_width : double;
  slot_pad_length : double;
  slot_pin_length : double;
  slot_pin_width : double;
  slot_x : double;
  slot_y: double;


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// HOLEWIZARD
// Recalc : do the calculations
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        // calculate the pad diameter  IPC2222 fixed alloance
        //   if Form1.rbt_holewiz_a.checked = true then round_paddiameter := round_holediameter + 0.1 + 0.6;
        //   if Form1.rbt_holewiz_b.checked = true then round_paddiameter := round_holediameter + 0.1 + 0.5;
        //   if Form1.rbt_holewiz_c.checked = true then round_paddiameter := round_holediameter + 0.1 + 0.4;

procedure recalc(dummy:integer);
begin
     //  slot_width := 0;
     //  slot_length :=0;
     slot_x := 0;
     slot_y :=0;
     round_pindiameter :=0;
     // -------------------------------------------------------------------------
     // round pin calculation
     // -------------------------------------------------------------------------
     // first get pin diameter
        str2double(form1.txt_diameter.text,round_pindiameter  );
        //round_pindiameter := Roundup_2Decimal (round_pindiameter)  ;
        // calculate the hole diameter
        if rbt_holewiz_a.checked = true then round_holediameter := round_pindiameter + 0.25;
        if rbt_holewiz_b.checked = true then round_holediameter := round_pindiameter + 0.20;
        if rbt_holewiz_c.checked = true then round_holediameter := round_pindiameter + 0.15;
        lbl_holewiz_round_holesize.caption := Roundup_1Decimal(round_holediameter);
        // calculate the pad diameter  IPC7351C proportional allowance
        lbl_holewiz_round_padsize.caption := Roundup_1Decimal (round_holediameter * 1.5);

     // -------------------------------------------------------------------------
     // Square pin calculation
     // -------------------------------------------------------------------------
     // first get pin diameter
        square_pinlength :=0;
        square_pinwidth :=0;
        str2double (form1.txt_sr_length.text,square_pinlength);
        str2double(form1.txt_sr_width.text,square_pinwidth);
        square_pindiameter := sqrt((square_pinlength*square_pinlength)+( square_pinwidth*square_pinwidth));
        square_pindiameter := Roundup_2Decimal (square_pindiameter) ;
     // calculate the hole diameter
        if rbt_holewiz_a.checked = true then square_holediameter := square_pindiameter + 0.25;
        if rbt_holewiz_b.checked = true then square_holediameter := square_pindiameter + 0.20;
        if rbt_holewiz_c.checked = true then square_holediameter := square_pindiameter + 0.15;
        lbl_holewiz_square_holesize.caption := Roundup_1Decimal(square_holediameter);
     // calculate the pad diameter  IPC7351C proportional alloance
        lbl_holewiz_square_padsize.caption := Roundup_1Decimal (square_holediameter *1.5); ;

     // -------------------------------------------------------------------------
     // Slot pin calculation
     // -------------------------------------------------------------------------
     // first get pin width
        str2double(form1.txt_slot_width.text,slot_pin_width);

     // calculate the slot width
        if rbt_holewiz_a.checked = true then slot_hole_width := slot_pin_width + 0.25;
        if rbt_holewiz_b.checked = true then slot_hole_width := slot_pin_width + 0.20;
        if rbt_holewiz_c.checked = true then slot_hole_width := slot_pin_width + 0.15;
        lbl_holewiz_slot_holewidth.caption := Roundup_1Decimal(slot_hole_width);
     // calculate the pad width
        lbl_holewiz_slot_padwidth.caption := Roundup_1Decimal (slot_hole_width *1.5);
     // now the slot length
        str2double(form1.txt_slot_length.text,slot_pin_length);
      //slot_pin_length :=slot_pin_length + slot_pin_width;
      //if rbt_holewiz_a.checked = true then slot_hole_length := slot_pin_length + 0.25;
      //if rbt_holewiz_b.checked = true then slot_hole_length := slot_pin_length + 0.20;
      //if rbt_holewiz_c.checked = true then slot_hole_length := slot_pin_length + 0.15;

      lbl_holewiz_slot_holelength.caption := Roundup_1Decimal(slot_pin_length+slot_hole_width);
      // calculate the pad width
      //  if Form1.RadioButton1.checked = true then slot_pad_length := slot_hole_length + 0.1 + 0.6;
      //  if Form1.RadioButton2.checked = true then slot_pad_length := slot_hole_length + 0.1 + 0.5;
      //  if Form1.RadioButton3.checked = true then slot_pad_length := slot_hole_length + 0.1 + 0.4;
      lbl_holewiz_slot_padlength.caption := Roundup_1Decimal(slot_pin_length + (slot_hole_width*1.5));

end      ;



// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// HOLEWIZARD
// UI Handlers
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure tForm1.rbt_holewiz_aClick(Sender: TObject);  // ipc level change to A
begin
     recalc(1);
end;

procedure tForm1.rbt_holewiz_bClick(Sender: TObject);  // ipc level change to B
begin
     recalc(1);
end;

procedure tForm1.rbt_holewiz_cClick(Sender: TObject);  // ipc level change to C
begin
     recalc(1);
end;

procedure tForm1.txt_diameterChange(Sender: TObject);  // Round pin diameter change
begin
     recalc(1);
end;
procedure tForm1.txt_sr_lengthChange(Sender: TObject); // rectangle pin length change
begin
     recalc(1);
end;

procedure TForm1.txt_sr_widthChange(Sender: TObject);  // rectangle pin width change
begin
     recalc(1);
end;

procedure TForm1.txt_slot_widthChange(Sender: TObject); // slot pin width change
begin
     recalc(1);
end;

procedure TForm1.txt_slot_lengthChange(Sender: TObject); // slot pin length change
begin
     recalc(1);
end;

procedure TForm1.Form1Create(Sender: TObject);       // form creation
begin
     recalc(1);
     form1.Caption := form1.Caption + ToolVersion;
     button15.Visible := experimental;
     getsettings;
end;





// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Fix Thermal pad
// UI Handlers
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   procedure TForm1.Button6Click(Sender: TObject);
   begin
        CleanThermalPad;
   end;


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Fix Thermal pad
// Add a circular cutout in the pastemask over the via hole
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 procedure AddPasteCutoutCircle (posx :double, posy : double , diameter : double);
var
   th_pad       : ipcb_pad;
   th_primitive : ipcb_primitive;
   th_ViaCache  : TPadCache;
   th_poly      : ipcb_region;
   centerx      : double;
   centery      : double;
   halfx        : double;
   halfy        : double;
   tenpx_D      : double;
   tenpy_D      : double;
   tenpx        : integer;
   tenpy        : integer;
   tenpx7       : integer;
   tenpy7       : integer;
   tenpx3       : integer;
   tenpy3       : integer;

   leftx        : integer;
   rightx       : integer;
   topy         : integer;
   bottomy      : integer;
   halfwidth    : integer;
   halfheight   : integer;
   maskwidth    : integer;
begin

    th_poly := pcbserver.PCBObjectFactory(eRegionObject,eNoDimension,eCreate_Default);              // make a new region
    th_poly.Kind :=1;                                                                               // cutout
    th_poly.Layer := eTopPaste;                                                                     // this time top paste mask
    th_poly.maincontour.clear;                                                                      // wipe it clean
    centerx := th_comp.x+MMsToCoord(PosX);                                                                    // lets get our center location for x
    centery := th_comp.y+MMsToCoord(PosY);                                                                    // and y

    tenpx_d    := (diameter  ) /2;                                                                    // figure out what is radius of (10 percent of the width). /20 because /10 would be diameter
    tenpy_d    := (diameter  ) /2;                                                                    // this time : no soldermask opening. this is paste !
    tenpx      := MMsToCoord(tenpx_d);                                                              // get all the other numbers
    tenpy      := MMsToCoord(tenpy_d);
    tenpx3     := MMsToCoord(tenpx_d*0.3);
    tenpy3     := MMsToCoord(tenpy_d*0.3);
    tenpx7     := MMsToCoord(tenpx_d*0.7);
    tenpy7     := MMsToCoord(tenpy_d*0.7);
    halfwidth  := MMsToCoord(diameter /2);
    halfheight := MMsToCoord(diameter /2);
    maskwidth  := MMsToCoord(0);                                                                    //no maskwidth
                                                                                                    // note : if in future we want to contract the paste we can inject a negative maskwidth
                                                                                                    //        we also need to do thatfor tenpx_d and tenpy_d !!

    // from here on all calculations are integers . we follow same mechanism as for soldermask
    leftx  := centerx - halfwidth - maskwidth;                                                      // you know the drill by now. same as for soldermask
    rightx := centerx + halfwidth + maskwidth;                                                      // get the edges first
    topy   := centery + halfheight + maskwidth;
    bottomy:= centery - halfheight - maskwidth;

    th_poly.maincontour.AddPoint(leftx  + tenpx  , topy             );                              // and add the bendpoints
    th_poly.maincontour.AddPoint(leftx  + tenpx3 , topy    - tenpy3 );
    th_poly.maincontour.AddPoint(leftx           , topy    - tenpy  );
    th_poly.maincontour.AddPoint(leftx           , bottomy + tenpy  );
    th_poly.maincontour.AddPoint(leftx  + tenpx3 , bottomy + tenpy3 );
    th_poly.maincontour.AddPoint(leftx  + tenpx  , bottomy          );

    th_poly.maincontour.AddPoint(rightx - tenpx  , bottomy          );
    th_poly.maincontour.AddPoint(rightx - tenpx3 , bottomy + tenpy3 );
    th_poly.maincontour.AddPoint(rightx          , bottomy + tenpy  );
    th_poly.maincontour.AddPoint(rightx          , topy    - tenpy  );
    th_poly.maincontour.AddPoint(rightx - tenpx3 , topy    - tenpy3 );
    th_poly.maincontour.AddPoint(rightx - tenpx  , topy             );

                                                                  // add to component
    PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_poly.I_ObjectAddress);
      th_Comp.AddPCBObject(th_poly);
    th_Brd.AddPCBObject(th_poly);                                                                   // and into the board
end;

 procedure AddSolderCutoutCircle (posx :double, posy : double , diameter : double);
var
   th_pad       : ipcb_pad;
   th_primitive : ipcb_primitive;
   th_ViaCache  : TPadCache;
   th_poly      : ipcb_region;
   centerx      : double;
   centery      : double;
   halfx        : double;
   halfy        : double;
   tenpx_D      : double;
   tenpy_D      : double;
   tenpx        : integer;
   tenpy        : integer;
   tenpx7       : integer;
   tenpy7       : integer;
   tenpx3       : integer;
   tenpy3       : integer;

   leftx        : integer;
   rightx       : integer;
   topy         : integer;
   bottomy      : integer;
   halfwidth    : integer;
   halfheight   : integer;
   maskwidth    : integer;
begin

    th_poly := pcbserver.PCBObjectFactory(eRegionObject,eNoDimension,eCreate_Default);              // make a new region
    th_poly.Kind :=1;                                                                               // cutout
    th_poly.Layer := eTopSolder;                                                                    // this time top paste mask
    th_poly.maincontour.clear;                                                                      // wipe it clean
    centerx := th_comp.x+MMsToCoord(PosX);                                                                    // lets get our center location for x
    centery := th_comp.y+MMsToCoord(PosY);                                                                    // and y

    tenpx_d    := (diameter  ) /2;                                                                    // figure out what is radius of (10 percent of the width). /20 because /10 would be diameter
    tenpy_d    := (diameter  ) /2;                                                                    // this time : no soldermask opening. this is paste !
    tenpx      := MMsToCoord(tenpx_d);                                                              // get all the other numbers
    tenpy      := MMsToCoord(tenpy_d);
    tenpx3     := MMsToCoord(tenpx_d*0.3);
    tenpy3     := MMsToCoord(tenpy_d*0.3);
    tenpx7     := MMsToCoord(tenpx_d*0.7);
    tenpy7     := MMsToCoord(tenpy_d*0.7);
    halfwidth  := MMsToCoord(diameter /2);
    halfheight := MMsToCoord(diameter /2);
    maskwidth  := MMsToCoord(0);                                                                    //no maskwidth
                                                                                                    // note : if in future we want to contract the paste we can inject a negative maskwidth
                                                                                                    //        we also need to do thatfor tenpx_d and tenpy_d !!

    // from here on all calculations are integers . we follow same mechanism as for soldermask
    leftx  := centerx - halfwidth - maskwidth;                                                      // you know the drill by now. same as for soldermask
    rightx := centerx + halfwidth + maskwidth;                                                      // get the edges first
    topy   := centery + halfheight + maskwidth;
    bottomy:= centery - halfheight - maskwidth;

    th_poly.maincontour.AddPoint(leftx  + tenpx  , topy             );                              // and add the bendpoints
    th_poly.maincontour.AddPoint(leftx  + tenpx3 , topy    - tenpy3 );
    th_poly.maincontour.AddPoint(leftx           , topy    - tenpy  );
    th_poly.maincontour.AddPoint(leftx           , bottomy + tenpy  );
    th_poly.maincontour.AddPoint(leftx  + tenpx3 , bottomy + tenpy3 );
    th_poly.maincontour.AddPoint(leftx  + tenpx  , bottomy          );

    th_poly.maincontour.AddPoint(rightx - tenpx  , bottomy          );
    th_poly.maincontour.AddPoint(rightx - tenpx3 , bottomy + tenpy3 );
    th_poly.maincontour.AddPoint(rightx          , bottomy + tenpy  );
    th_poly.maincontour.AddPoint(rightx          , topy    - tenpy  );
    th_poly.maincontour.AddPoint(rightx - tenpx3 , topy    - tenpy3 );
    th_poly.maincontour.AddPoint(rightx - tenpx  , topy             );

                                                                  // add to component
    PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_poly.I_ObjectAddress);
      th_Comp.AddPCBObject(th_poly);
    th_Brd.AddPCBObject(th_poly);                                                                   // and into the board
end;

procedure AddCutSpoke(posX:double, posy:double, height:double, width:double, layer:integer);
var
   th_pad       : ipcb_pad;
   th_primitive : ipcb_primitive;
   th_poly      : ipcb_region;
   centerx      : integer;
   centery      : integer;
   topbound     : integer;
   bottombound  : integer;
   leftbound    : integer;
   rightbound   : integer;

begin
    th_poly := pcbserver.PCBObjectFactory(eRegionObject,eNoDimension,eCreate_Default);              // make a new region
    th_poly.Kind :=1;                                                                               // cutout
    th_poly.Layer := layer;                                                                         // this time top paste mask
    th_poly.maincontour.clear;                                                                      // wipe it clean
    centerx := th_comp.x;                                                                           // find centerpoint of the component first. : center of x
    centery := th_comp.y;                                                                           // and center of y

    // we get an x and y offset. to figure out what needs to be done we first need to know if
    // we need to draw a horizontal or vertical bar

    if width < height then begin                                                                    // it is a vertical bar
       // for a vertical bar the yoffset is zero and we draw from -(heigth/2) to (height/2)
       // the x offset is (centerx + posx) and we draw from centeroffset -(width/2) to centeroffset +(height/2)

       topbound    := centery + MMsToCoord(height/2);
       bottombound := centery - MMsToCoord(height/2);
       leftbound   :=(centerx + MMsToCoord(posx)) - MMsToCoord(width/2);
       rightbound  :=(centerx + mmstocoord(posx)) + MMsToCoord(width/2);
    end
    else begin                                                                                      // it is a horizontal bar
       topbound    :=(centery + mmstocoord(posy)) + MMsToCoord(height/2);
       bottombound :=(centery + mmstocoord(posy)) - MMsToCoord(height/2);
       leftbound   :=centerx - MMsToCoord(width/2);
       rightbound  :=centerx + MMsToCoord(width/2);

    end;

    th_poly.maincontour.AddPoint (leftbound,topbound);
    th_poly.maincontour.addpoint (leftbound,bottombound);
    th_poly.maincontour.addpoint (rightbound,bottombound);
    th_poly.maincontour.addpoint (rightbound,topbound);

                                                                  // add to component
    PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_poly.I_ObjectAddress);
    th_Comp.AddPCBObject(th_poly);
    th_Brd.AddPCBObject(th_poly);                                                                   // and into the board

end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Fix Thermal pad
// Add a via at given coordinate
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure AddviaAt (posx :double, posy : double);
var
   th_pad       : ipcb_pad;
   th_primitive : ipcb_primitive;
   th_ViaCache  : TPadCache;
begin
   PCBServer.PreProcess;
    th_Via := PcbServer.PCBObjectFactory(eViaObject,eNoDimension,eCreate_Default);
    If th_Via = Nil Then Exit;
    th_Via.BeginModify;
    th_Via.Mode := ePadMode_Simple;
    th_Via.X    := th_comp.x+MMsToCoord(PosX);
    th_Via.Y    := th_comp.y+MMsToCoord(PosY);
    th_Via.Size := MMsToCoord(0.508);
    th_Via.HoleSize := MMsToCoord(0.254);
    th_Via.LowLayer  := eTopLayer;
    th_Via.HighLayer := eBottomLayer;
  //  th_via.SolderMaskExpansion := MMsToCoord(0.1);
  //  th_via.SolderMaskExpansionFromHoleEdge :=true;
    th_via.IsTenting := false;
    th_via.IsTenting_Bottom :=false;
    th_via.IsTenting_top :=false;
    th_via.IsTestpoint_Bottom := false;
    th_via.IsTestpoint_Top := false;
    th_via.IsAssyTestpoint_Bottom :=false;
    th_via.IsAssyTestpoint_Top := false;

    // local stack
    th_via.Mode := ePadMode_LocalStack;
    th_via.SizeOnLayer (eTopLayer) :=mmstocoord(0.508) ;
    th_via.sizeonlayer (eMidLayers) :=mmstocoord(0.508) ;
    th_via.sizeonlayer (eBottomLayer) :=mmstocoord(0.6) ;

    // ------------------------------------------------------------------------------------------
    // this following is very advanced altium wizardry.
    // we need to recast a via to the root class of primitive, via an intermediate pad class.
    // only the ipcb_primitive can modify the expansion from hole edge
    // then to set manual expansion we need access ot the padstack cache

    //th_pad :=th_via;           // cast via to pad type
   // th_Primitive := th_pad;    // recast the pad to primitive so we can get to advanced stuff
    //   th_Primitive.SolderMaskExpansionFromHoleEdge := true;
    //   th_viacache := th_Primitive.GetState_Cache;
    //      if tw_openmask.Checked = false then begin                                                 // if we use open mask there is no via soldermsk
    //         th_viacache.SolderMaskExpansion := mmstocoord(0.15);
    //      end
    //      else begin
    //         th_viacache.SolderMaskExpansion := mmstocoord(0);
    //      end;
    //      th_Viacache.SolderMaskExpansionValid := eCacheManual;
    //      th_viacache.SolderMaskExpansionFromHoleEdge := true;
    //   th_Primitive.SetState_Cache := Viacache;
    //th_via := th_primitive;    // now throw it back into a via.
    // ------------------------------------------------------------------------------------------
   // th_pad :=th_via;           // cast via to pad type
    th_via.SolderMaskExpansionFromHoleEdge := true;
    th_viacache := th_via.GetState_Cache;
    th_Viacache.SolderMaskExpansionValid := eCacheManual;
    if tw_openmask.Checked = false then begin                                                       // if we use open mask there is no via soldermsk
       th_viacache.SolderMaskExpansion := mmstocoord(th_viaringwidth);
    end
    else begin
       th_viacache.SolderMaskExpansion := mmstocoord(0);
    end;
    th_via.SetState_Cache := th_Viacache;
    if th_net <> nil then th_via.Net := th_net;



    PCBServer.PostProcess;
    th_Via.EndModify;
    th_Comp.AddPCBObject(th_Via);
    PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_Via.I_ObjectAddress);
    th_Brd.AddPCBObject(th_Via);
end;

Procedure Addmasks (posx :double, posy : double , height : double , width : double);
var
   th_pad       : ipcb_pad;
   th_primitive : ipcb_primitive;
   th_ViaCache  : TPadCache;
   th_poly      : ipcb_polygon;
   centerx      : double;
   centery      : double;
   halfx        : double;
   halfy        : double;
   tenpx_D      : double;
   tenpy_D      : double;
   tenpx        : integer;
   tenpy        : integer;
   tenpx7       : integer;
   tenpy7       : integer;
   tenpx3       : integer;
   tenpy3       : integer;

   leftx        : integer;
   rightx       : integer;
   topy         : integer;
   bottomy      : integer;
   halfwidth    : integer;
   halfheight   : integer;
   maskwidth    : integer;
   segment      : array[0..16] of tpolysegment;
   x            : integer;
begin
      // lets begin by creating the required storage entitities for segments
      for x := 0 to 11 do begin
           segment[x] := TPolySegment;
           segment[x].Kind :=ePolySegmentLine;
      end;
      centerx := MMsToCoord(PosX);                                                                  // lets get our center location for x
      centery := MMsToCoord(PosY);                                                                  // and y

     // let's start with soldermask

     if tw_openmask.Checked = false then begin


        //      *a         *l                                                                       // this map shows the bendpoints for the polygon
        //    *b             *k                                                                     // we fake rounding by injecting a point at 0.3 - 0.3 of 10 percent of dimension
        //  *c                 *j
        //
        //            c
        //
        //  *d                 *i
        //    *e             *h
        //      *f         *g

        tenpx_d    := (width  + (2 * smtsoldermask)) /20;                                           // figure out what is radius of (10% of the width) including the soldermask expansion for x
        tenpy_d    := (height + (2 * smtsoldermask)) /20;                                           // 10 is diameter so we divide by 20 to get radius ( diameter = radius *2 )

        // we need to switch over to coordinate space
        tenpx      := MMsToCoord(tenpx_d);                                                          // tenpercent of width (x)
        tenpy      := MMsToCoord(tenpy_d);                                                          // tenpercent of height (y)
        tenpx3     := MMsToCoord(tenpx_d*0.3);                                                      // 0.3 x tenpercent width (x)
        tenpy3     := MMsToCoord(tenpy_d*0.3);
        tenpx7     := MMsToCoord(tenpx_d*0.7);                                                      // 0.7 * tenpercent width (x) .we dont use this. for future purposes
        tenpy7     := MMsToCoord(tenpy_d*0.7);
        halfwidth  := MMsToCoord(width /2);                                                         // half the width of the polgon
        halfheight := MMsToCoord(height /2);                                                        // half the height of the polygon
        maskwidth  := MMsToCoord(smtsoldermask);                                                    // and the mask border over copper

        // from here on all calculations are integers
        // let's first grab the edges of the polygon

        leftx  := centerx - halfwidth - maskwidth;                                                  // left edge
        rightx := centerx + halfwidth + maskwidth;                                                  // right edge
        topy   := centery + halfheight + maskwidth;                                                 // top edge
        bottomy:= centery - halfheight - maskwidth;                                                 // bottom edge

        // the following equations control the position of the bend points
        // *ax = leftx + tenpx
        // *ay = topy
        // *bx = leftx + tenpx3
        // *by = topy - tenpy3
        // *cx = leftx
        // *cy = topy - tenpy
        // *dx = leftx
        // *dy = bottomy + tenpy
        // *ex = leftx + tenpx3
        // *ey = bottomy + tenpy3
        // *fx = leftx + tenpx
        // *fy = bottomy
        // *gx = rightx - tenpx
        // *gy = bottomy
        // *hx = rightx - tenpx3
        // *hy = bottomy + tenpy3
        // *ix = rightx
        // *iy = bottomy + tenpy
        // *jx = rightx
        // *jy = topy   - tenpy
        // *kx = rightx - tenpx3
        // *ky = topy - tenpy3
        // *lx = rightx - tenpx
        // *ly = topy

        segment[0].vx := leftx + tenpx;
        segment[0].vy := topy;
        segment[1].vx := leftx + tenpx3 ;
        segment[1].vy := topy - tenpy3  ;
        segment[2].vx  := leftx          ;
        segment[2].vy  := topy - tenpy   ;
        segment[3].vx  := leftx          ;
        segment[3].vy  := bottomy + tenpy ;
        segment[4].vx  := leftx + tenpx3  ;
        segment[4].vy  := bottomy + tenpy3;
        segment[5].vx  := leftx + tenpx   ;
        segment[5].vy  := bottomy         ;
        segment[6].vx  := rightx - tenpx  ;
        segment[6].vy  := bottomy         ;
        segment[7].vx  := rightx - tenpx3 ;
        segment[7].vy  := bottomy + tenpy3;
        segment[8].vx  := rightx          ;
        segment[8].vy  := bottomy + tenpy ;
        segment[9].vx  := rightx          ;
        segment[9].vy  := topy   - tenpy  ;
        segment[10].vx  := rightx - tenpx3 ;
        segment[10].vy  := topy - tenpy3   ;
        segment[11].vx  := rightx - tenpx  ;
        segment[11].vy  := topy            ;

        th_poly := PCBServer.PCBObjectFactory(ePolyObject, eNoDimension, eCreate_Default);
        th_poly.SetState_PointCount(12);
        for x := 0 to 11 do begin
           th_poly.setstate_segments(x,segment[x]);
        end;
        th_poly.setstate_segments(12,segment[0]);                                                   // close it
        th_poly.SetState_PourOver(true);
        th_poly.SetState_PolyHatchStyle(ePolySolid);
        th_poly.SetState_BorderWidth(false);
        th_poly.SetState_Layer(eTopSolder);
        th_poly.SetState_RemoveNarrowNecks(false);
        th_poly.SetState_RemoveIslandsByArea (false);
        th_poly.SetState_Removedead(false);

        th_Comp.AddPCBObject(th_poly);                                                              // inject the polygon in the component
        PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_poly.I_ObjectAddress);
        th_Brd.AddPCBObject(th_poly);
        th_Comp.AddPCBObject(th_poly);

        th_poly.Rebuild                                                                             // and add it to the board
    end;

    // let's do pastemask


    tenpx_d    := (width  ) /20;                                                                    // figure out what is radius of (10 percent of the width). /20 because /10 would be diameter
    tenpy_d    := (height ) /20;                                                                    // this time : no soldermask opening. this is paste !
    tenpx      := MMsToCoord(tenpx_d);                                                              // get all the other numbers
    tenpy      := MMsToCoord(tenpy_d);
    tenpx3     := MMsToCoord(tenpx_d*0.3);
    tenpy3     := MMsToCoord(tenpy_d*0.3);
    tenpx7     := MMsToCoord(tenpx_d*0.7);
    tenpy7     := MMsToCoord(tenpy_d*0.7);
    halfwidth  := MMsToCoord(width /2);
    halfheight := MMsToCoord(height /2);
    maskwidth  := MMsToCoord(0);                                                                    //no maskwidth
                                                                                                    // note : if in future we want to contract the paste we can inject a negative maskwidth
                                                                                                    //        we also need to do thatfor tenpx_d and tenpy_d !!

    // from here on all calculations are integers . we follow same mechanism as for soldermask
    leftx  := centerx - halfwidth - maskwidth;                                                      // you know the drill by now. same as for soldermask
    rightx := centerx + halfwidth + maskwidth;                                                      // get the edges first
    topy   := centery + halfheight + maskwidth;
    bottomy:= centery - halfheight - maskwidth;


     segment[0].vx := leftx + tenpx;
        segment[0].vy := topy;
        segment[1].vx := leftx + tenpx3 ;
        segment[1].vy := topy - tenpy3  ;
        segment[2].vx  := leftx          ;
        segment[2].vy  := topy - tenpy   ;
        segment[3].vx  := leftx          ;
        segment[3].vy  := bottomy + tenpy ;
        segment[4].vx  := leftx + tenpx3  ;
        segment[4].vy  := bottomy + tenpy3;
        segment[5].vx  := leftx + tenpx   ;
        segment[5].vy  := bottomy         ;
        segment[6].vx  := rightx - tenpx  ;
        segment[6].vy  := bottomy         ;
        segment[7].vx  := rightx - tenpx3 ;
        segment[7].vy  := bottomy + tenpy3;
        segment[8].vx  := rightx          ;
        segment[8].vy  := bottomy + tenpy ;
        segment[9].vx  := rightx          ;
        segment[9].vy  := topy   - tenpy  ;
        segment[10].vx  := rightx - tenpx3 ;
        segment[10].vy  := topy - tenpy3   ;
        segment[11].vx  := rightx - tenpx  ;
        segment[11].vy  := topy            ;

    th_poly := PCBServer.PCBObjectFactory(ePolyObject, eNoDimension, eCreate_Default);
    th_poly.SetState_PointCount(12);
    for x := 0 to 11 do begin
       th_poly.setstate_segments(x,segment[x]);
    end;
    th_poly.setstate_segments(12,segment[0]);                                                   // close it
    th_poly.SetState_PourOver(true);
    th_poly.SetState_PolyHatchStyle(ePolySolid);
    th_poly.SetState_BorderWidth(false);
    th_poly.SetState_Layer(eToppaste);
    th_poly.SetState_RemoveNarrowNecks(false);
    th_poly.SetState_RemoveIslandsByArea (false);
    th_poly.SetState_Removedead(false);
    th_Comp.AddPCBObject(th_poly);                                                              // inject the polygon in the component
    PCBServer.SendMessageToRobots(th_Comp.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_poly.I_ObjectAddress);
    th_Brd.AddPCBObject(th_poly);
     th_Comp.AddPCBObject(th_poly);
    th_poly.Rebuild                                                              // and add it to the board
 end;


// ---------------------------------------------------------------------------------------------------------------------------
// Thermal pad wizard
// ---------------------------------------------------------------------------------------------------------------------------

Procedure ThermalWizard;
Var
    th_pad          :ipcb_pad;
    th_pad_type2    :ipcb_pad2;
    boundarea            : tcoordrect;
    th_brd               : IPCB_Board;
    ViaCache             : TPadCache;
Begin
    getsettings;
    // Retrieve the current board
    th_brd := PCBServer.GetCurrentPCBBoard;
    If th_brd = Nil Then begin
       logmsg ('Thermalwizard : Not a PCB');
       Exit;
    end;
    // first let the user click somewhere
    th_brd.ChooseLocation(th_x,th_y, 'Choose pad');

    // see if we can find a pad at that location in the pile of objects there.
    // we do this by making a filter of ePadobject and asking the user if ambiguous
    th_pad := th_Brd.GetObjectAtXYAskUserIfAmbiguous(th_x,th_y,MkSet(ePadObject),AllLayers, eEditAction_Select);
    // if we don't have a pad now : that's it -> time to exit
    If Not Assigned(th_pad) Then begin
       logmsg ('Thermalwizard : Exit');
       Exit ;
    end;
    if th_pad.layer <> eTopLayer then begin
       logmsg ('Thermalwizard : Not a Surface mounted Pad');
       Exit ;
    end;

    // pad cleanup time

    th_pad.Plated := true;                                                                          // make sure it is plated
    th_pad.topshape := eRoundedRectangular;                                                         // set style to rounded rectangular
    viacache := th_pad.GetState_Cache;                                                              // get the pad cache to do some wizardry
    th_pad.SolderMaskExpansionValid := eCacheManual;                                              // force soldermask expansion
    viacache.pasteMaskExpansionValid  := eCacheManual;                                              // force paste mask expansion
    viacache.SolderMaskExpansion := settings_soldermask_smt;
    th_pad.SetState_Cache := Viacache;
    th_pad_type2 := th_pad ;
    th_pad_type2.SetState_StackCRPctOnLayer (etoplayer, 10);
    th_pad := th_pad_type2;


                      boundarea := th_pad.BoundingRectangle;
                      boundarea.left := boundarea.left + settings_soldermask_smt;
                      boundarea.right := boundarea.right - settings_soldermask_smt;
                      boundarea.top := boundarea.top - settings_soldermask_smt;
                      boundarea.bottom := boundarea.bottom + settings_soldermask_smt;


End;
procedure TForm1.Button7Click(Sender: TObject);
begin
     Thermalwizard;
end;


Procedure IteratePolygons2;
Var
    Board      : IPCB_Board;
    Polygon    : IPCB_region;
    Iterator   : IPCB_BoardIterator;
    PolygonRpt : TStringList;
    FileName   : TPCBString;
    Document   : IServerDocument;
    PolyNo     : Integer;
    I          : Integer;
    q : Pwidechar;
    p : WideString;
Begin
    // Retrieve the current board
    Board := PCBServer.GetCurrentPCBBoard;
    If Board = Nil Then Exit;

    // Search for Polygons and for each polygon found
    // get its attributes and put them in a TStringList object
    // to be saved as a text file.
    Iterator        := Board.BoardIterator_Create;
    Iterator.AddFilter_ObjectSet(MkSet(eRegionObject));
    Iterator.AddFilter_LayerSet(AllLayers);
    Iterator.AddFilter_Method(eProcessAll);

    PolyNo     := 0;
    PolygonRpt := TStringList.Create;
    q := p[1];
    Polygon := Iterator.FirstPCBObject;
    While (Polygon <> Nil) Do
    Begin
        Inc(PolyNo);
        PolygonRpt.Add('Polygon No : '           + IntToStr(PolyNo));
        //Check if Net exists before getting the Name property.
        If Polygon.Net <> Nil Then
            PolygonRpt.Add(' Polygon Net : '     + Polygon.Net.Name);

Polygon.Export_ToParameters(q);
p := WideCharToString(q);

        // Segments of a polygon
//        For I := 0 To Polygon.PointCount - 1 Do
//        Begin
//            If Polygon.Segments[I].Kind = ePolySegmentLine Then
//            Begin
//                PolygonRpt.Add(' Polygon Segment Line at X: ' + IntToStr(Polygon.Segments[I].vx));
//                PolygonRpt.Add(' Polygon Segment Line at Y: ' + IntToStr(Polygon.Segments[I].vy));
//            End
//            Else
//            Begin
//                PolygonRpt.Add(' Polygon Segment Arc 1  : ' + FloatToStr(Polygon.Segments[I].Angle1));
//                PolygonRpt.Add(' Polygon Segment Arc 2  : ' + FloatToStr(Polygon.Segments[I].Angle2));
//                PolygonRpt.Add(' Polygon Segment Radius : ' + FloatToStr(Polygon.Segments[I].Radius));
//            End;
//        End;
        PolygonRpt.Add('');
        Polygon := Iterator.NextPCBObject;
    End;
    Board.BoardIterator_Destroy(Iterator);

    // The TStringList contains Polygon data and is saved as
    // a text file.
    FileName := ChangeFileExt(Board.FileName,'.pol');
    PolygonRpt.SaveToFile(Filename);
    PolygonRpt.Free;

    // Display the Polygons report
    Document  := Client.OpenDocument('Text', FileName);
    If Document <> Nil Then
        Client.ShowDocument(Document);
End;


procedure TForm1.Button15Click(Sender: TObject);
begin
test;
end;




procedure TForm1.Schlib_Extract(Sender: TObject);
Var
    CurrentLib      : ISch_Lib;
    LibraryIterator : ISch_Iterator;
    AnIndex         : Integer;
    i               : integer;
    LibComp         : ISch_Component;
    S               : TDynamicString;
    ReportInfo      : TStringList;
    names : tstring;
Begin
     If SchServer = Nil Then Exit;
    CurrentLib := SchServer.GetCurrentSchDocument;
    If CurrentLib = Nil Then Exit;

    // check if the document is a schematic library and if not
    // exit.
    If CurrentLib.ObjectID <> eSchLib Then
    Begin
         ShowError('Please open schematic library.');
         Exit;
    End;

    // get the library object for the library iterator.
    LibraryIterator := CurrentLib.SchLibIterator_Create;

    // Note MkSet function to create a set compatible with the
    // Scripting engine since sets not supported.
    LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));
    names :='';

     Try
        LibComp := LibraryIterator.FirstSchObject;
        While LibComp <> Nil Do
        Begin
            names := names + LibComp.LibReference + '| ' + LibComp.ComponentDescription + #13#10;

            //AnIndex := LibComp.AliasCount;
            ////If AnIndex = 0 Then
            ////    ReportInfo.Add('No Aliases found...')
            ///Else
            //For i := 0 to AnIndex - 1 do
            //    ReportInfo.Add('Aliasname= ' + LibComp.Alias[i]);

            //ReportInfo.Add('');
            // obtain the next schematic symbol in the library
            LibComp := LibraryIterator.NextSchObject;
        End;

    Finally
        CurrentLib.SchIterator_Destroy(LibraryIterator);
    End;
   Clipboard.AsText :=names;

end;
var
    se_CurrentLib       : ISch_Lib;
    se_LibraryIterator : ISch_Iterator;
    se_AnIndex         : Integer;
    se_i               : integer;
    se_LibComp         : ISch_Component;
    se_S               : TDynamicString;
    se_ReportInfo      : TStringList;
    se_names           : tstring;

procedure TForm1.Button17Click(Sender: TObject);
begin
   button17.Visible :=false ;
   button16.Visible :=false ;
   button18.Visible :=true  ;
   EDIT1.Visible :=TRUE;
   EDIT2.Visible :=TRUE;
   LABEL32.VISIBLE :=TRUE;
   LABEL33.Visible :=TRUE;
   If SchServer = Nil Then Exit;
    se_CurrentLib := SchServer.GetCurrentSchDocument;
    If se_CurrentLib = Nil Then Exit;

    // check if the document is a schematic library and if not
    // exit.
    If se_CurrentLib.ObjectID <> eSchLib Then
    Begin
         ShowError('Please open schematic library.');
         Exit;
    End;

    // get the library object for the library iterator.
    se_LibraryIterator := se_CurrentLib.SchLibIterator_Create;

    // Note MkSet function to create a set compatible with the
    // Scripting engine since sets not supported.
    se_LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));


     Try
        se_LibComp := se_LibraryIterator.FirstSchObject;
        edit1.Text   :=se_LibComp.LibReference;
        edit2.Text   :=se_LibComp.ComponentDescription;
     finally
     end;
end;



procedure TForm1.Button18Click(Sender: TObject);
begin
     se_libcomp.Comment.Text :='=SAP';
     se_libcomp.Designator.text :='J?';
     se_LibComp.ComponentDescription :=edit2.Text;
     se_LibComp := se_LibraryIterator.NextSchObject;
     if se_LibComp = Nil then begin
        button17.Visible :=true ;
        button16.Visible :=true ;
        button18.Visible :=false;
        EDIT1.Visible :=false;
        EDIT2.Visible :=false;
        LABEL32.VISIBLE :=false;
        LABEL33.Visible :=false;

        se_CurrentLib.SchIterator_Destroy(se_LibraryIterator);
     end
     else begin
        edit1.Text   :=se_LibComp.LibReference;
        edit2.Text   :=se_LibComp.ComponentDescription;
     end;

end;


procedure TForm1.Button19Click(Sender: TObject);
Var
    CurrentLib      : ISch_Lib;
    LibraryIterator : ISch_Iterator;
    AnIndex         : Integer;
    i               : integer;
    LibComp         : ISch_Component;
    S               : TDynamicString;
    ReportInfo      : TStringList;
    names : tstring;
Begin
If SchServer = Nil Then Exit;
    CurrentLib := SchServer.GetCurrentSchDocument;
    If CurrentLib = Nil Then Exit;
    If CurrentLib.ObjectID <> eSchLib Then
    Begin
         ShowError('Please open schematic library.');
         Exit;
    End;
    LibraryIterator := CurrentLib.SchLibIterator_Create;
    LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));
    Try
        LibComp := LibraryIterator.FirstSchObject;
        While LibComp <> Nil Do
        Begin
           libcomp.Comment.Text :=EDIT4.TEXT;
          // libcomp.comment.visible :=false;
           libcomp.Designator.text :=EDIT3.Text;
            LibComp := LibraryIterator.NextSchObject;
        End;
    Finally
        CurrentLib.SchIterator_Destroy(LibraryIterator);
    End;
end;


procedure TForm1.Button20Click(Sender: TObject);

Var
    CurrentLib      : ISch_Lib;
    LibraryIterator : ISch_Iterator;
    PinIterator     : ISch_Iterator;
     Pin           : ISch_Pin;
    AnIndex         : Integer;
    i               : integer;
    LibComp         : ISch_Component;
    S               : TDynamicString;
    ReportInfo      : TStringList;
    names : tstring;

Begin
  ReportInfo := TStringList.Create;
    ReportInfo.Clear;
If SchServer = Nil Then Exit;
    CurrentLib := SchServer.GetCurrentSchDocument;
    If CurrentLib = Nil Then Exit;
    If CurrentLib.ObjectID <> eSchLib Then
    Begin
         ShowError('Please open schematic library.');
         Exit;
    End;



    LibraryIterator := CurrentLib.SchLibIterator_Create;
    LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));
    Try
        LibComp := LibraryIterator.FirstSchObject;
        While LibComp <> Nil Do
        Begin
            PinIterator := LibComp.SchIterator_Create;
            PinIterator.AddFilter_ObjectSet(MkSet(ePin));
            Try
                Pin := PinIterator.FirstSchObject;
                While Pin <> Nil Do
                Begin
                  //  ReportInfo.Add(' The Pin Designator: ' + Pin.Designator);
                   IF pin.selection =true then begin
                     PIN.Name_PositionMode := 1;
                     PIN.Name_CustomPosition_RotationRelative := eRotate90;
                     Pin.Name_CustomPosition_Margin :=100000;
                      i:= Pin.Name_CustomPosition_Margin;
                   end;
                   Pin := PinIterator.NextSchObject;
                End;
            Finally
                LibComp.SchIterator_Destroy(PinIterator);
            End;
            LibComp := LibraryIterator.NextSchObject;
        End;
    Finally
        CurrentLib.SchIterator_Destroy(LibraryIterator);
    End;

end;

procedure TForm1.Button21Click(Sender: TObject);

Var
    CurrentLib      : ISch_Lib;
    LibraryIterator : ISch_Iterator;
    PinIterator     : ISch_Iterator;
     Pin           : ISch_Pin;
    AnIndex         : Integer;
    i               : integer;
    LibComp         : ISch_Component;
    S               : TDynamicString;
    ReportInfo      : TStringList;
    names           : tstring;
    body            : ISch_Rectangle;
    SCH_LINE        : ISch_Line;

Begin
  ReportInfo := TStringList.Create;
  ReportInfo.Clear;
  If SchServer = Nil Then Exit;
     SchClearLog;
     CurrentLib := SchServer.GetCurrentSchDocument;
     If CurrentLib = Nil Then Exit;
     If CurrentLib.ObjectID <> eSchLib Then
     Begin
         SchLogMSG('Please open schematic library.');
         Exit;
     End;
     LibraryIterator := CurrentLib.SchLibIterator_Create;
     LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));
     Try
        LibComp := LibraryIterator.FirstSchObject;
        While LibComp <> Nil Do
        Begin
            // uppercase name
            LibComp.LibReference := uppercase(LibComp.LibReference);
            // uppercase description
            LibComp.ComponentDescription := uppercase (LibComp.ComponentDescription);
            SchLogMSG( '*** ' +LibComp.LibReference );
            schlogmsg( '    ' +LibComp.ComponentDescription );
            // set comment
            if libcomp.Comment.Text <> uppercase(EDIT4.TEXT) then begin
               libcomp.Comment.Text := uppercase(EDIT4.TEXT);
               SchLogMSG('    - COMMENT Fix : set to ' + libcomp.Comment.Text);
            end;
            // set designator
            if libcomp.Designator.text <> uppercase(EDIT3.TEXT) then begin
               libcomp.Designator.text :=uppercase(EDIT3.Text);
               SchLogMSG('    - DESIGNATOR Fix : set to ' + libcomp.Designator.Text);
            end;
            // fix illegal characters
            IF POS('/',LibComp.LibReference) >0 THEN BEGIN
               LibComp.LibReference := StringReplace(LibComp.LibReference,'/','-',rfReplaceAll);
               SchLogMSG('    - NAME Fix : / replaced by - ');
            END;
            IF POS(' ',LibComp.LibReference) >0 THEN BEGIN
               LibComp.LibReference := StringReplace(LibComp.LibReference,' ','-',rfReplaceAll);
               SchLogMSG('    - NAME Fix : [ ] replaced by - ');
            END;
            IF POS('_',LibComp.LibReference) >0 THEN BEGIN
               LibComp.LibReference := StringReplace(LibComp.LibReference,'_','-',rfReplaceAll);
               SchLogMSG('    - NAME Fix : _ replaced by - ');
            END;
            IF POS(',',LibComp.LibReference) >0 THEN BEGIN
               LibComp.LibReference := StringReplace(LibComp.LibReference,'_','-',rfReplaceAll);
               SchLogMSG('    - NAME Fix : , replaced by - ');
            END;
            // fix empty description
            IF  LibComp.ComponentDescription ='' THEN LibComp.ComponentDescription :=LIBCOMP.LIBREFERENCE;

            PinIterator := LibComp.SchIterator_Create;
            PinIterator.AddFilter_ObjectSet(MkSet(ePin));
            Try
                Pin := PinIterator.FirstSchObject;
                While Pin <> Nil Do
                Begin
                  //  ReportInfo.Add(' The Pin Designator: ' + Pin.Designator);
                   if pin.Name <> UpperCase(pin.name) then begin
                      pin.Name := UpperCase(pin.name);
                      SchLogMSG('    - PIN Case Fix : ' +pin.name);
                   end;
                   if ((pin.name = 'VCC') or (pin.name = 'VCCA') or (pin.name = 'VEE') or (pin.name = 'VSS')or (pin.name = 'VDD')or (pin.name = 'VSSA')or (pin.name = 'VDDA')  or (pin.name = 'GND') or (pin.name = 'GNDA')) then begin
                        if pin.Electrical <> eElectricPower then begin
                           pin.Electrical := eElectricPower;
                           SchLogMSG('    - PIN Type Fix : ' + pin.name + ' Set to POWER');
                      end;
                   end;
                   IF PIN.Name_PositionMode = 1  then begin
                      PIN.Name_CustomPosition_RotationRelative := eRotate90;
                      Pin.Name_CustomPosition_Margin :=-100000;
                   end;
                   Pin := PinIterator.NextSchObject;
                End;
            Finally
                LibComp.SchIterator_Destroy(PinIterator);
            End;

            PinIterator := LibComp.SchIterator_Create;
            PinIterator.AddFilter_ObjectSet(MkSet(eRectangle));
            Try
                body := PinIterator.FirstSchObject;
                While body <> Nil Do
                Begin
                   body.Color :=0;
                   body.areaColor :=11599871;
                   body.LineWidth :=eSmall;

                   body := PinIterator.NextSchObject;
                end;
            Finally
                LibComp.SchIterator_Destroy(PinIterator);
            End;

            PinIterator := LibComp.SchIterator_Create;
            PinIterator.AddFilter_ObjectSet(MkSet(eLINE,ePolyline));
            Try
                SCH_LINE := PinIterator.FirstSchObject;
                While SCH_LINE <> Nil Do
                Begin
                   SCH_LINE.Color :=0;
            //     body.areaColor :=11599871;
            //     body.LineWidth :=eSmall;

                   SCH_LINE := PinIterator.NextSchObject;
                end;
            Finally
                LibComp.SchIterator_Destroy(PinIterator);
            End;

            PinIterator := LibComp.SchIterator_Create;
            PinIterator.AddFilter_ObjectSet(MkSet(eArc));
            Try
                body := PinIterator.FirstSchObject;
                While body <> Nil Do
                Begin
                   body.Color :=0;
            //     body.areaColor :=11599871;
            //     body.LineWidth :=eSmall;

                   body := PinIterator.NextSchObject;
                end;
            Finally
                LibComp.SchIterator_Destroy(PinIterator);
            End;


            SchLogMSG( '-------------------------------------------------'  ) ;
            LibComp := LibraryIterator.NextSchObject;
        End;
    Finally
        CurrentLib.SchIterator_Destroy(LibraryIterator);
    End;

end;
// =============================================================================
// Menu events
// =============================================================================

procedure TForm1.MNU_ImportMechLayerFromFile(Sender: TObject);
begin
     PCB_ImportMechLayerInfo_FromFile   ;
end;
procedure TForm1.MNU_ImportMechLayerDefault(Sender: TObject);
begin
     PCB_ImportMechLayerDefault;
end;

procedure TForm1.MNU_Options(Sender: TObject);
begin
     TabSheet4.Show;
end;

procedure TForm1.MNU_Resetstyle(Sender: TObject);
begin
     ResetStyle;
end;

procedure TForm1.MNU_UnlockProcesses(Sender: TObject);
begin
     memo1.lines.clear;
     unlock_process;
     logmsg ('Altium::PCBserver Processes Unlocked');
end;

procedure TForm1.MNU_GrabAllPads(Sender: TObject);
begin
     graballpads;
end;

procedure TForm1.MNU_FixthermalPad(Sender: TObject);
begin
     CleanThermalPad;
end;

procedure TForm1.MNU_Setpin1Square(Sender: TObject);
begin
  setpin1square;
end;

procedure TForm1.MNU_UnbindMechLayers(Sender: TObject);
begin
     PCB_ResetA11MechLayerPairs;
end;

procedure TForm1.MNU_RemoveUnusedLayers(Sender: TObject);
begin
     PCB_HideUnusedMechLayers;
end;

procedure TForm1.endscript(Sender: TObject);
begin
     // Application.Terminate; this kills altium !
    //close;

end;

// =============================================================================
// Button events
// =============================================================================

procedure TForm1.RUN_ApplyDefaultStackClick(Sender: TObject);
begin
     PCB_ImportMechLayerDefault;
end;

procedure TForm1.RUN_RemoveUnusedMechClick(Sender: TObject);
begin
     PCB_HideUnusedMechLayers;
end;

procedure TForm1.RUN_ResetGridStyleClick(Sender: TObject);
begin
     ResetStyle;
end;

