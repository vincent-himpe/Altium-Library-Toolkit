{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Support Functions                                                            }
{ -----------------------------------------------------------------------------}

const
      SmallGrid = 0.025;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Helper : roundup to 1 decimal  2.1 = 2.1, 2.11 = 2.12
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Roundup_1Decimal(X: double): double;
begin
    if ((X*10) - Trunc(X*10) <> 0) then // there is a decimal...
       Result := (Trunc(X*10) + 1)/10   // ...so we round up
else // there is no decimal...
       Result := (Trunc(X*10))/10;      // ...so we just return X
end;
Procedure refresh_screen;
begin
       ResetParameters;
       AddStringParameter('Action', 'Redraw');
       RunProcess('PCB:Zoom');
end;

procedure youshouldntbehere;
begin
  LogMSG('+++ Divide By Cucumber Error At 1450 North First Street. Please install new Goat And Reboot Universe +++');
  Exit;
end;
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Helper : roundup to 2 decimal  2.11 = 2.2, 2.19 = 2.2
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Roundup_2Decimal(X: double): double;
begin
    if ((X*100) - Trunc(X*100) <> 0) then // there is a decimal...
       Result := (Trunc(X*100) + 1)/100   // ...so we round up
else // there is no decimal...
       Result := (Trunc(X*100))/100;      // ...so we just return X
end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// warning !! this does not do what you think it does !
//            read it again !
//            altium 0:0 is bottom left of screen.
//            part 0:0 is actually a positive x and y location
//            to figure out which way we need to round (negative/positive)
//            we need to know the reference axis 0 location (ref)
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RoundupToQuarterMMCoord(x:integer,ref:integer) : integer;
var
   a,b,c,d : double;
begin
 //  a :=(CoordToMMs(x)) / 0.025;
 //  b :=Int(a);
 //  c := b * 0.025;

  // if x>ref then begin  // positive number
 //     if (MMsToCoord(c) <> x) then c:= (b+1)*0.025  // add 1
 //  end
 //  else begin        // negative number
 //     if (MMsToCoord(c) <> x) then c:= (b-1)*0.025  // do NOT subtract as we rounded DOWN ! (effect of rounding down is subtracting 1)
 //  end;

   a :=(CoordToMMs(x));   // get it in millimeters
   b := a / 0.025;
   c := b * 0.025;
   d := int(b);

     if x>ref then begin  // positive number
        if b <> int(b) then c:= (int(b)+1)*0.025  // add 1
     end ;
     if x<ref then begin  // negative number
        if b <> int(b) then  c:= (int(b))*0.025  // dont subtract !!!! we already rounded 'down'
     end  ;


   Result :=MMsToCoord(c);
end;


function RoundupToQuarterMM(x:double) : double;
var
   a,b,c : double;
begin
   a :=x / 0.025;
   b :=Int(a);
   c := b * 0.025;

   if x>0 then begin  // positive number
      if (c <> x) then c:= (b+1)*0.025
   end
   else begin        // negative number
      if (c <> x) then c:= (b-1)*0.025
   end;
   Result :=c;
       youshouldntbehere  ;

end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Unlock stuck processes
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure unlock_process;
begin
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
     PCBServer.PostProcess;
end;


 // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : Reset Drawing Style in the library
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure ResetStyle;
var
   tt : tunit;
   tcc : integer;
   PCBDoc : IPCB_Board;
   PCBSysOpts : IPCB_SystemOptions;
   a,b : widestring;

    Board : IPCB_Board;
    Gridmgr : IPCB_GridManagerPCBlib;
    PlcmGrid : IPCB_PlacementGrid;
    S        : String;

begin
     PCBServer.PreProcess;
     //Clearlog;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;                                                             // Grab the library
     Board := PCBServer.GetCurrentPCBBoard;


     If CurrentLib = Nil Then
     Begin
        LogMSG('ERR : This is not a PCB library document');
        Exit;
     End;
     if board = nil then
     begin
        LogMSG('ERR : This is not a PCB library document');
        exit;
     end;

     LogMSG('RUN : Grid Style Reset');

     Gridmgr := Board.GetState_GridManager;
     PlcmGrid := Gridmgr.FindApplicableGridByXY(0,0);
     plcmgrid.DrawMode :=0;                         // 0 = line , 1 = dot , 2 = hide
     plcmgrid.DrawModeLarge :=0;


  //   logmsg('Color:' + ColorToString(PlcmGrid.Color));
  //   logmsg('ColorLarge:' + ColorToString(PlcmGrid.ColorLarge));
     PlcmGrid.Color : = StringToColor('$005C4D4D');
     PlcmGrid.ColorLarge := StringToColor('$00908D91');
     //currentlib.Board.DrawDotGrid :=false;                                                                     // Switch to line grid

     currentlib.Board.ComponentGridSize := MMsToCoord(SmallGrid);                                              // set grid to 0.025mm

     currentlib.board.DisplayUnit := eImperial;                                                                // switch to metric ... YES it IS a bug. eImperial means metric in altium speak ...

     currentlib.board.DrawMode(eArcObject) :=eDrawFull;                                                        // Dset drawing mode
     currentlib.board.DrawMode(eFillObject) :=eDrawFull;
     currentlib.board.DrawMode(ePadObject) :=eDrawFull;
     currentlib.board.DrawMode(ePolyObject) :=eDrawFull;
     currentlib.board.DrawMode(eDimensionObject) :=eDrawFull;
     currentlib.board.DrawMode(eTextObject) :=eDrawFull;
     currentlib.board.DrawMode(eTrackObject) :=eDrawFull;
     currentlib.board.DrawMode(eViaObject) :=eDrawFull;
     currentlib.board.DrawMode(eCoordinateObject) :=eDrawFull;
     currentlib.board.DrawMode(eArcObject) :=eDrawFull;
     currentlib.board.DrawMode(eRegionObject) :=eDrawFull;
     currentlib.board.DrawMode(eComponentBodyObject) :=eDrawFull;

     currentlib.Board.BigVisibleGridMultFactor :=10        ;
     currentlib.Board.BigVisibleGridSize := MMsToCoord(SmallGrid);
     currentlib.Board.BigVisibleGridUnit := eMetric;

     currentlib.Board.SnapGridSize := MMsToCoord(SmallGrid);
     currentlib.Board.SnapGridUnit :=eMetric        ;

     currentlib.Board.VisibleGridSize:= MMsToCoord(SmallGrid);
     currentlib.Board.VisibleGridUnit :=eMetric;
     currentlib.Board.VisibleGridMultFactor :=10;

     unlock_process;
     refresh_screen;
     LogMSG('RUN : Completed');
end;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : Grab All Pads
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure GrabAllPads;
Begin
     PCBServer.PreProcess;
     Clearlog;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;                                                             // Grab the library
     If CurrentLib = Nil Then
     Begin
        LogMSG('This is not a PCB library document');
        Exit;
     End;                                                                                                      // run any hanging commands first and cleanup the command stack
   //  FootprintIterator := CurrentLib.LibraryIterator_Create;
   //  FootprintIterator.SetState_FilterAll;
     Try
   //     Footprint := FootprintIterator.FirstPCBObject; // IPCB_LibComponent
   //     While Footprint <> Nil Do
   //     Begin
           footprint := currentlib.CurrentComponent;
           ObjIterator := Footprint.GroupIterator_Create;
           ObjIterator.SetState_FilterAll;
           APrimitive := ObjIterator.FirstPCBObject;
           While (APrimitive <> Nil) Do
           Begin
                 if (APrimitive.objectid = ePadObject) then
                 begin
                     aprimitive.selected :=true;
                 end;
                 APrimitive := ObjIterator.NextPCBObject;
           end;
           Footprint.GroupIterator_Destroy(ObjIterator);
           //Footprint := FootprintIterator.NextPCBObject;
       // End;
    Finally
        //CurrentLib.LibraryIterator_Destroy(FootprintIterator);
    End;
    PCBServer.PostProcess;
    refresh_screen;
End;


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Process : Set Pin 1 Square
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Procedure SetCurrentPin1Square;
begin
     ObjIterator := global_currentfootprint.GroupIterator_Create;
     ObjIterator.SetState_FilterAll;
     APrimitive := ObjIterator.FirstPCBObject;
     While (APrimitive <> Nil) Do
        Begin
           if (APrimitive.objectid = ePadObject) then begin
              if APrimitive.Name = '1' then begin
                 APrimitive.stackShapeOnLayer(etoplayer) := eRectangular;
                 APrimitive.topshape := eRectangular;
              end;
          end;
          APrimitive := ObjIterator.NextPCBObject;
        end;
        global_currentfootprint.GroupIterator_Destroy(ObjIterator);
end;

Procedure SetPin1Square;
var
     CurrentLib           : IPCB_Library;
     FootprintIterator    : IPCB_LibraryIterator;
Begin
     PCBServer.PreProcess;
     GetSettings;
     Clearlog;
     CurrentLib := PCBServer.GetCurrentPCBLibrary;                                                             // Grab the library
     If CurrentLib = Nil Then
     Begin
        LogMSG('This is not a PCB library document');
        Exit;
     End;                                                                                                      // run any hanging commands first and cleanup the command stack
     FootprintIterator := CurrentLib.LibraryIterator_Create;
     FootprintIterator.SetState_FilterAll;
     Try
         if settings_processall = true then begin
            Footprint := FootprintIterator.FirstPCBObject; // IPCB_LibComponent
            While Footprint <> Nil Do
            Begin
               currentlib.CurrentComponent := footprint;
               global_currentfootprint := footprint;
               Setcurrentpin1square;
               Footprint := FootprintIterator.NextPCBObject;
            End;
           CurrentLib.LibraryIterator_Destroy(FootprintIterator);
           logmsg ('Made ALL pin 1 in library rectangular');
         end
         else begin
            footprint := currentlib.CurrentComponent;
            global_currentfootprint := footprint;
            Setcurrentpin1square;
            logmsg ('Made pin 1 rectangular');
         end;
    Finally

    End;
    PCBServer.PostProcess;
    refresh_screen;
End;



// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Fix Thermal pad
// grabs the highest numbered pad and sets its corner rounding to 10%
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   procedure CleanThermalPad;
   var
      padcount : integer;
      CurrentLib           : IPCB_Library;
      Footprint            : IPCB_LibComponent;
      ObjIterator          : IPCB_GroupIterator;
      APrimitive           : IPCB_Primitive;
      APad2                : IPCB_Pad2;                                          // a pad2 type object (altium has 3 pad types : Pad, Pad2 and Pad3)
      ViaCache             : TPadCache;
   begin
        PCBServer.PreProcess;
        GetSettings;
        padcount:=0;
        Clearlog;
        CurrentLib := PCBServer.GetCurrentPCBLibrary;
        If CurrentLib = Nil Then
        Begin
            LogMSG('This is not a PCB library document');
            Exit;
        End;
        Try
           footprint := currentlib.CurrentComponent;
           ObjIterator := Footprint.GroupIterator_Create;
           ObjIterator.SetState_FilterAll;
           APrimitive := ObjIterator.FirstPCBObject;
           While (APrimitive <> Nil) Do
           Begin
                if  (APrimitive.objectid = ePadObject) then begin               // we must first test for a pad . other objects may not have all properties we check for next
                    if (StrToIntDef(APrimitive.Name,0) > padcount)
                    and (aprimitive.Layer = eTopLayer)
                    and (aprimitive.plated = true)
                    then begin
                        padcount :=  StrToIntdef(APrimitive.Name,0);
                    end;
                end;
                APrimitive := ObjIterator.NextPCBObject;
           end;
           Footprint.GroupIterator_Destroy(ObjIterator);
        Finally
        End;
        Begin
            ObjIterator := Footprint.GroupIterator_Create;
            ObjIterator.SetState_FilterAll;
            APrimitive := ObjIterator.FirstPCBObject;
            While (APrimitive <> Nil) Do Begin
               if (APrimitive.objectid = ePadObject) then begin
                  if StrToIntdef(APrimitive.Name,0) = padcount then begin
                     APrimitive.topshape := eRoundedRectangular;
                     viacache := APrimitive.GetState_Cache;
                     viacache.SolderMaskExpansion := settings_soldermask_smt;
                     Viacache.SolderMaskExpansionValid := eCacheManual;
                     APrimitive.SetState_Cache := Viacache;
                     // cast the pad as type ipcb_pad2 to get to the cornerradius
                     APAD2 := APrimitive ;
                     apad2.SetState_StackCRPctOnLayer (etoplayer, 10);

                  end;
               end;
               APrimitive := ObjIterator.NextPCBObject;
            end;
            Footprint.GroupIterator_Destroy(ObjIterator);
        end;
        PCBServer.PostProcess;
        refresh_screen;
   end;
