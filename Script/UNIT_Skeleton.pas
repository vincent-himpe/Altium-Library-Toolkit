// Skeleton Routing : used as a base routine example
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
