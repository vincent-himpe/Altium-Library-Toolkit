


{..............................................................................}
Procedure AddParameter(newparameter : string, hide:boolean);
Var
    CurrentLib      : ISch_Lib;
    LibraryIterator : ISch_Iterator;
    AnIndex         : Integer;
    i               : integer;
    LibComp         : ISch_Component;
    S               : TDynamicString;
    PIterator       : ISch_Iterator;
    Parameter       : ISch_Parameter;
    newParam        : ISch_Parameter;
    ReportInfo      : TstringList;
    found           : boolean;
    paramname       : string;
Begin
    If SchServer = Nil Then Exit;
    CurrentLib := SchServer.GetCurrentSchDocument;
    If CurrentLib = Nil Then Exit;

    // check if the document is a schematic library
    If CurrentLib.ObjectID <> eSchLib Then
    Begin
         ShowError('Please open schematic library.');
         Exit;
    End;


    // create a library iterator to look for
    // symbols in the currently focussed library.
    LibraryIterator := CurrentLib.SchLibIterator_Create;
    LibraryIterator.AddFilter_ObjectSet(MkSet(eSchComponent));
    Try
        // obtain the first symbol in the library
        LibComp := LibraryIterator.FirstSchObject;
        While LibComp <> Nil Do
        Begin
            // look for parameters associated with this symbol in a library.
            Try

                PIterator := LibComp.SchIterator_Create;
                PIterator.AddFilter_ObjectSet(MkSet(eParameter));
                Parameter := PIterator.FirstSchObject;
                found := false;
                While Parameter <> Nil Do
                   Begin
                   paramname := parameter.name;
                      if (UpperCase(ParamName) = UpperCase(newparameter)) then found :=true;
                      Parameter := PIterator.NextSchObject;
                   End;
                if found = false then
                begin

                //ISch_Component.Add_Parameter(
                newParam := SchServer.SchObjectFactory(eParameter, eCreate_Default);
                newParam.Name := newparameter;
                newParam.Text := '';
                newParam.ShowName := false;
                newParam.IsHidden := hide;
                // libcomp.Add_Parameter(newparam,'');
                libcomp.AddSchObject(newParam);
                //libcomp.AddSchParameter(Parameter);
                end;


            Finally
                LibComp.SchIterator_Destroy(PIterator);
            End;
            // obtain the next symbol in the library
            LibComp := LibraryIterator.NextSchObject;
        End;
    Finally
        // done with looking for symbols and parameters.
        // destroy the library iterator.
        CurrentLib.SchIterator_Destroy(LibraryIterator);
    End;
End;


Procedure AddParametersGeneric;
  Begin
    AddParameter('Location',true);
    AddParameter('LCSC',true);
    AddParameter('DIGIKEY',true);
    AddParameter('MOUSER',true);
    AddParameter('Manufacturer 1',true);
    AddParameter('Manufacturer Part Number 1',true);
    AddParameter('Package / Case',true);
  End;

Procedure AddParametersResistors;
  Begin
    AddParametersGeneric;
    AddParameter('Value',false);
    AddParameter('Tolerance',false);
    AddParameter('Power',false);
  End;

Procedure AddParametersCapacitors;
  Begin
     AddParametersGeneric;
    AddParameter('Capacitance',false);
    AddParameter('Voltage',false);
    AddParameter('Dielectric',false);
  End;

