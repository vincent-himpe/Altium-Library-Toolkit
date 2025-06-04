{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Altium Library Toolkit                                                       }
{ Created by:   Vincent Himpe                                                  }
{ - PUBLIC DOMAIN -                                                            }
{ -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
{ Library Cleaner                                                              }
{ -----------------------------------------------------------------------------}


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
        if currentheight <> footprint.Height then LogMSG('  -> Updated Height to '+ FloatToStr(CoordToMMs(footprint.Height)));
     end;
     if footprint.Height = 0 then  logmsg('   -> *** WARNING *** missing 3d model !');
     footprint.EndModify;
end;
