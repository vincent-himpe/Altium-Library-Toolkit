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
