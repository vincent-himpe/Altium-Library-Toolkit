{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Thermal Wizard                                                               }
{ -----------------------------------------------------------------------------}


procedure Thermal_BuildSimpleTile;
begin
end;



 {
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
   settings_thermalfarm_holesize   : integer;
   settings_thermalfarm_backpadsize : integer;
   settings_thermalfarm_toppadsize : integer;
   settings_thermalfarm_midpadsize : integer;
   settings_thermalfarm_pitch      : integer;
   settings_soldermask_smt         : integer;
   settings_soldermask_mech        : integer;
   settings_soldermask_viahole     : integer;
   settings_soldermask_th          : integer;
   settings_wipe_silkscreen        : boolean;
   settings_courtyard_pin1style    : integer;
   settings_processall             : boolean;

   settings_thermal_holesize       : integer;
   settings_thermal_TopPad         : integer;
   settings_thermal_MidPad         : integer;
   settings_thermal_BottomPad      : integer;
   settings_thermal_pitch          : integer;
   settings_thermal_tilesize       : integer;
   settings_thermal_minimumtile    : integer;
   settings_thermal_masktype       : integer;
   thermalpad                      : ipcb_pad;

   Pin1Pad                         : IPCb_PAD;                                           // storage for the object holding pin1
   Pin1Bound                       : tcoordrect;                                         // a spatial entity storing the boundary of pin 1
   SMTPin1Found                    : boolean;
   Pin1Found                       : boolean;

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
     }




  procedure oldthermal;
  var
      Polygon      : IPCB_Polygon;
    Iterator     : IPCB_BoardIterator;
    PolygonRpt   : TStringList;
    FileName     : TPCBString;
    Document     : IServerDocument;
    PolyNo       : Integer;
    I            : Integer;
    contour      : ipcb_countour;
    boardx       : integer;
    boardy       : integer;
    apoly        : IPCB_Region;
    comp         : IPCB_Component;
    th_x         : integer;
    th_y         : integer;
    th_pad       : IPCB_Pad;
    xloop        : integer;
    yloop        : integer;
    thermalpitch : double;
    xoffs        : double ;
    yoffs        : double;
    xcount       : integer;
    ycount       : integer;
    tname        : tstring;
    s1           : double;
    s2           : double;
    s3           : double;
      begin


    if th_pad.topxsize > th_pad.topysize then begin                                                 // find largest size of x and y
        Viacache.PasteMaskExpansion  := 0-th_pad.topxsize;                                          // contract pastemask and soldermask according to largest dimension
        viacache.SolderMaskExpansion := 0-th_pad.topxsize;
    end
    else begin
        Viacache.PasteMaskExpansion  := 0-th_pad.topysize;
        viacache.SolderMaskExpansion := 0-th_pad.topysize;
    end;

    thermalpitch :=1.1;
    boardx :=th_brd.xorigin;
    boardy :=th_brd.yorigin;


    if tw_openmask.Checked = true then                                                              // if we are in full open mode: undo the soldermask
       viacache.SolderMaskExpansion := mmstocoord(smtsoldermask);

    th_pad.SetState_Cache := Viacache;                                                              // throw the cache back

    APAD2 :=th_pad ;                                                                                // cast the pad as type ipcb_pad2 to get to the cornerradius
    apad2.SetState_StackCRPctOnLayer (etoplayer, 10);                                               // set corner radius to 10%

    if th_pad.Component <> nil then                                                                 // if the pad is associated with a component :
       tname := th_pad.Component.Name.Text                                                          //    get the deisgnator of that thing
    else                                                                                            // if not :
       tname := 'Free';                                                                             //    it is a free pad

    if th_pad.net <> nil then th_net := th_pad.Net else th_net:= nil;                               // and grab the net

    // make a new component
    PCBServer.PreProcess;
    th_Comp := PCBServer.PCBObjectFactory(eComponentObject, eNoDimension, eCreate_Default);         // Make a component to hold our structure
    If th_Comp = Nil Then Exit;                                                                     // if that failed -> exit
    th_Comp.X := th_pad.x;                                                                          // set component origin equal to pad center
    th_Comp.Y := th_pad.Y;                                                                          // set component origin equal to pad center
    th_Comp.Layer := eTopLayer;                                                                     // set the component on the top layer
    th_Comp.PrimitiveLock := true;                                                                  // lock primitives
    th_Comp.Moveable := false;                                                                      // freeze it in place
    th_Comp.NameOn       := false;                                                                  // hide designator
    th_Comp.Name.Text    := tname +'_Pastewindow';                                                  // we assign the designator + _Pastewindow for sorting
    th_Comp.CommentOn    := False;                                                                  // hide comment
    th_Comp.Comment.Text := 'PasteWindow '+tname;                                                   // comment is 'Pastewindow '+Designator
    th_Comp.ComponentKind := eComponentKind_Graphical;                                              // mark this thing as a graphical object so it does not appear in a BOM
    PCBServer.SendMessageToRobots(th_Brd.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,th_Comp.I_ObjectAddress);    // register the new component
    th_brd.AddPCBObject(th_Comp);                                                                   // add the component to the board
    PCBServer.PostProcess;
    // now we will add elements

    // to establish how many vias we can place :
    //    - take dimension of pad
    //    - subtract one via diameter to make sure vias do not protrude over edge
    //    - divide by thermalpitch.
    //    - convert to integer.
    xloop := int((coordtomms(th_pad.topxsize)-0.508) / thermalpitch);
    yloop := int((CoordToMMs(th_pad.topysize)-0.508) / thermalpitch);

    // to establish the offset :
    //    - take center of pad (0)
    //    - subtract half padwidth
    //    - add half the space remainder.
    //        - the space remainder is pad width - (loopcount * thermalpitch)
    //       0 - [      half padwidth        ] + [ (   padwidth                - (loopcount x thermalpitch)  /2 ]

    xoffs := 0 - coordtomms(th_pad.topxsize/2) + ((coordtomms(th_pad.topxsize) - (xloop * thermalpitch))/2);
    yoffs := 0 - coordtomms(th_pad.topysize/2) + ((coordtomms(th_pad.topysize) - (yloop * thermalpitch))/2);

    for ycount := 0 to yloop  do
    begin
        // for each y : insert horizontal keepout lane
        AddCutSpoke(xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch),0.15,CoordToMMs(th_pad.topxsize),eTopPaste);
        if tw_waffle.Checked = true then AddCutSpoke(xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch),0.1,CoordToMMs(th_pad.topxsize),eTopSolder);
        for xcount := 0 to xloop do begin
           AddviaAt(xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch));
           AddPasteCutoutCircle (xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch), paste_cutout_via);

           if tw_openmask.Checked = false then begin
              AddSolderCutoutCircle (xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch), solder_cutout_via);
           end;
           if ycount = 0 then begin  // if ycount is zero : then inject a vertical stripe for each x position
              AddCutSpoke(xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch),CoordToMMs(th_pad.topysize),0.15,eTopPaste);
              if tw_waffle.Checked = true then AddCutSpoke(xoffs + (xcount * thermalpitch),yoffs +(ycount*thermalpitch),CoordToMMs(th_pad.topysize),0.10,eTopsolder);
           end;
        end;
    end;

    Addmasks (CoordToMMs(th_pad.x),CoordToMMs(th_pad.y),CoordToMMs(th_pad.topxsize),CoordToMMs(th_pad.topysize));


    refresh_screen;


    // -------------------------------------

  //   apoly := pcbserver.PCBObjectFactory(eRegionObject,eNoDimension,eCreate_Default);
  //   apoly.Kind :=1;
  //   apoly.Layer := 37;
  //   apoly.Board := th_brd;
  //   apoly.Name := 'Vincent1';

  //   apoly.maincontour.clear;
  //   apoly.maincontour.AddPoint(MMsToCoord(19+10)+boardx,MMsToCoord(31+10)+boardy);

  //   apoly.maincontour.AddPoint(MMsToCoord(19+10)+boardx,MMsToCoord(25+10)+boardy);
  //   apoly.maincontour.AddPoint(MMsToCoord(19.2+10)+boardx,MMsToCoord(25+10)+boardy);
  //   apoly.maincontour.AddPoint(MMsToCoord(19.2+10)+boardx,MMsToCoord(31+10)+boardy);

  //   th_brd.addpcbobject(apoly);
  //              PCBServer.SendMessageToRobots(th_brd.I_ObjectAddress,c_Broadcast,PCBM_BoardRegisteration,apoly.I_ObjectAddress);
  //              pcbserver.PostProcess;
  //              pcbserver.Preprocess;
  end;
