object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Librarian Toolkit'
  ClientHeight = 564
  ClientWidth = 924
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = Form1Create
  DesignSize = (
    924
    564)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 859
    Top = 0
    Width = 136
    Height = 488
    Anchors = [akTop, akRight]
    Caption = 'Tools'
    TabOrder = 0
    DesignSize = (
      136
      488)
    object Shape8: TShape
      Left = 8
      Top = 176
      Width = 120
      Height = 1
    end
    object Shape9: TShape
      Left = 8
      Top = 288
      Width = 120
      Height = 1
    end
    object Button5: TButton
      Left = 16
      Top = 184
      Width = 112
      Height = 32
      Hint = 'Set Pin 1 to Rectangle'
      Anchors = [akTop, akRight]
      Caption = 'Set Pin 1 rectangle'
      TabOrder = 0
      OnClick = Button5Click
    end
    object Button4: TButton
      Left = 16
      Top = 96
      Width = 112
      Height = 32
      Anchors = [akTop, akRight]
      Caption = 'Grab All Pads'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button3: TButton
      Left = 16
      Top = 56
      Width = 112
      Height = 32
      Anchors = [akTop, akRight]
      Caption = 'Unlock Processes'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 16
      Top = 16
      Width = 112
      Height = 32
      Anchors = [akTop, akRight]
      Caption = 'Reset Style'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button6: TButton
      Left = 16
      Top = 136
      Width = 112
      Height = 32
      Hint = 'Find highest numbered SMT pad and set corner radius'
      Anchors = [akTop, akRight]
      Caption = 'Fix Thermal Pad'
      TabOrder = 4
      OnClick = Button6Click
    end
    object Button15: TButton
      Left = 16
      Top = 376
      Width = 112
      Height = 64
      Anchors = [akTop, akRight]
      Caption = 'Experimental  Function'
      TabOrder = 5
      WordWrap = True
      OnClick = Button15Click
    end
    object chk_processall: TCheckBox
      Left = 16
      Top = 232
      Width = 96
      Height = 16
      Caption = 'Process All'
      TabOrder = 6
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 831
    Height = 520
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight]
    MultiLine = True
    TabHeight = 24
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Cleanup Footprint'
      ExplicitHeight = 458
      object Label53: TLabel
        Left = 521
        Top = 83
        Width = 27
        Height = 13
        Caption = 'Pads'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label54: TLabel
        Left = 521
        Top = 3
        Width = 38
        Height = 13
        Caption = 'Layers'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label55: TLabel
        Left = 521
        Top = 147
        Width = 90
        Height = 13
        Caption = 'Assembly Layer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label56: TLabel
        Left = 521
        Top = 243
        Width = 92
        Height = 13
        Caption = 'Courtyard Layer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label57: TLabel
        Left = 521
        Top = 323
        Width = 93
        Height = 13
        Caption = 'Silkscreen Layer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label58: TLabel
        Left = 521
        Top = 403
        Width = 79
        Height = 13
        Caption = 'Miscellaneous'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Memo1: TMemo
        Left = 0
        Top = -2
        Width = 468
        Height = 404
        Lines.Strings = (
          '>> Ready')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Button1: TButton
        Left = 344
        Top = 414
        Width = 128
        Height = 32
        Caption = 'Cleanup'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button13: TButton
        Left = 120
        Top = 414
        Width = 128
        Height = 32
        Caption = 'Clean + Silk 1'
        TabOrder = 2
        OnClick = Button13Click
      end
      object CHK_RebuildAssemblyLayer: TCheckBox
        Left = 536
        Top = 168
        Width = 196
        Height = 16
        Caption = 'Rebuild Assembly Layer'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CHK_ApplyIPC2221: TCheckBox
        Left = 536
        Top = 104
        Width = 196
        Height = 16
        Caption = 'Apply IPC2221 Pad sizing (Thru-Hole)'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object CHK_ResizeAssemblyLayer: TCheckBox
        Left = 536
        Top = 200
        Width = 196
        Height = 16
        Caption = 'Resize Assembly Layer'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object CHK_ResizeCourtyard: TCheckBox
        Left = 536
        Top = 296
        Width = 196
        Height = 16
        Caption = 'Resize Courtyard Layer'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object CHK_RebuildCourtyardLayer: TCheckBox
        Left = 536
        Top = 264
        Width = 196
        Height = 16
        Caption = 'Rebuild Courtyard Layer'
        Checked = True
        State = cbChecked
        TabOrder = 7
      end
      object CHK_ResizeSilkscreenLayer: TCheckBox
        Left = 536
        Top = 360
        Width = 196
        Height = 16
        Caption = 'Resize Silkscreen Layer'
        Checked = True
        State = cbChecked
        TabOrder = 8
      end
      object CHK_RebuildSilkscreenlayer: TCheckBox
        Left = 536
        Top = 344
        Width = 228
        Height = 16
        Caption = 'Rebuild Silkscreen Layer (experimental)'
        Checked = True
        State = cbChecked
        TabOrder = 9
      end
      object CHK_ApplyDefaultStack: TCheckBox
        Left = 536
        Top = 24
        Width = 196
        Height = 16
        Caption = 'Apply Default Stack'
        Checked = True
        State = cbChecked
        TabOrder = 10
      end
      object CHK_RemoveUnusedMech: TCheckBox
        Left = 536
        Top = 40
        Width = 196
        Height = 16
        Caption = 'Remove Unused Mechanicals'
        Checked = True
        State = cbChecked
        TabOrder = 11
      end
      object CHK_Fixup3D: TCheckBox
        Left = 536
        Top = 424
        Width = 196
        Height = 16
        Caption = 'Fixup 3D models and data'
        Checked = True
        State = cbChecked
        TabOrder = 12
      end
      object CHK_ProcessDesignator: TCheckBox
        Left = 536
        Top = 216
        Width = 196
        Height = 16
        Caption = 'Process DESIGNATOR string'
        Checked = True
        State = cbChecked
        TabOrder = 13
      end
      object CHK_MarkPin1Courtyard: TCheckBox
        Left = 560
        Top = 280
        Width = 172
        Height = 16
        Caption = 'Mark Pin1 on Courtyard'
        TabOrder = 14
      end
      object CHK_RemovePin1Dots: TCheckBox
        Left = 536
        Top = 376
        Width = 120
        Height = 16
        Caption = 'Remove Pin 1 Dots'
        Checked = True
        State = cbChecked
        TabOrder = 15
      end
      object CHK_MarkPin1Assembly: TCheckBox
        Left = 560
        Top = 184
        Width = 276
        Height = 16
        Caption = 'Mark Pin 1 on Assembly'
        Checked = True
        State = cbChecked
        TabOrder = 16
      end
      object ComboBox1: TComboBox
        Left = 696
        Top = 277
        Width = 116
        Height = 21
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 17
        Text = '1 - Arrow to edge'
        Items.Strings = (
          '0 - None'
          '1 - Arrow to edge'
          '2 - Arrow to Center'
          '3 - Box'
          '4 - Box + diagonal')
      end
      object CHK_ApplyRoundSMD: TCheckBox
        Left = 536
        Top = 120
        Width = 196
        Height = 16
        Caption = 'Round SMD Pads'
        Checked = True
        State = cbChecked
        TabOrder = 18
      end
      object CHK_RemoveUnusedCopper: TCheckBox
        Left = 536
        Top = 56
        Width = 196
        Height = 16
        Caption = 'Remove Unused Copper'
        Checked = True
        State = cbChecked
        TabOrder = 19
      end
      object RUN_ApplyDefaultStack: TButton
        Left = 496
        Top = 24
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 20
        OnClick = RUN_ApplyDefaultStackClick
      end
      object RUN_RemoveUnusedMech: TButton
        Left = 496
        Top = 40
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 21
        OnClick = RUN_RemoveUnusedMechClick
      end
      object RUN_RemoveUnusedCopper: TButton
        Left = 496
        Top = 56
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 22
      end
      object RUN_ApplyIPC2221: TButton
        Left = 496
        Top = 104
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 23
      end
      object RUN_ApplyRoundSMD: TButton
        Left = 496
        Top = 120
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 24
      end
      object RUN_RebuildAssemblyLayer: TButton
        Left = 496
        Top = 168
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 25
      end
      object RUN_MarkPin1Assembly: TButton
        Left = 496
        Top = 184
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 26
      end
      object RUN_ProcessDesignator: TButton
        Left = 496
        Top = 216
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 27
      end
      object RUN_ResizeAssemblyLayer: TButton
        Left = 496
        Top = 200
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 28
      end
      object RUN_ResizeCourtyard: TButton
        Left = 496
        Top = 296
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 29
      end
      object RUN_MarkPin1Courtyard: TButton
        Left = 496
        Top = 280
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 30
      end
      object RUN_RebuildCourtyardLayer: TButton
        Left = 496
        Top = 264
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 31
      end
      object RUN_RemovePin1Dots: TButton
        Left = 496
        Top = 376
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 32
      end
      object RUN_ResizeSilkscreenLayer: TButton
        Left = 496
        Top = 360
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 33
      end
      object RUN_RebuildSilkscreenlayer: TButton
        Left = 496
        Top = 344
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 34
      end
      object RUN_Fixup3D: TButton
        Left = 496
        Top = 424
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 35
      end
      object CHK_UnlockObjects: TCheckBox
        Left = 536
        Top = 440
        Width = 196
        Height = 16
        Caption = 'Unlock Objects'
        Checked = True
        State = cbChecked
        TabOrder = 36
      end
      object RUN_UnlockObjects: TButton
        Left = 496
        Top = 440
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 37
      end
      object CHK_ResetGridStyle: TCheckBox
        Left = 536
        Top = 456
        Width = 196
        Height = 16
        Caption = 'Reset Grid Style'
        Checked = True
        State = cbChecked
        TabOrder = 38
      end
      object RUN_ResetGridStyle: TButton
        Left = 496
        Top = 456
        Width = 24
        Height = 16
        Caption = '>'
        TabOrder = 39
        OnClick = RUN_ResetGridStyleClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Hole Wizard'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 8
        Top = 0
        Width = 444
        Height = 112
        Caption = 'Round'
        TabOrder = 0
        object lbl_holewiz10: TLabel
          Left = 281
          Top = 35
          Width = 43
          Height = 13
          Caption = 'Hole Size'
        end
        object lbl_holewiz1: TLabel
          Left = 17
          Top = 19
          Width = 95
          Height = 13
          Caption = 'Wire Diameter (mm)'
        end
        object Shape1: TShape
          Left = 120
          Top = 16
          Width = 88
          Height = 88
          Brush.Color = clSilver
          Shape = stCircle
        end
        object Shape2: TShape
          Left = 136
          Top = 32
          Width = 56
          Height = 56
          Brush.Color = clGray
          Shape = stCircle
        end
        object Shape3: TShape
          Left = 144
          Top = 40
          Width = 40
          Height = 40
          Brush.Color = clAqua
          Shape = stCircle
        end
        object lbl_holewiz11: TLabel
          Left = 281
          Top = 59
          Width = 40
          Height = 13
          Caption = 'Pad Size'
        end
        object lbl_holewiz_round_padsize: TLabel
          Left = 345
          Top = 59
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz_round_holesize: TLabel
          Left = 345
          Top = 35
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz16: TLabel
          Left = 401
          Top = 35
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz17: TLabel
          Left = 401
          Top = 59
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object txt_diameter: TEdit
          Left = 16
          Top = 35
          Width = 80
          Height = 21
          Alignment = taCenter
          TabOrder = 0
          Text = '0.6'
          OnChange = txt_diameterChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 112
        Width = 444
        Height = 114
        Caption = 'Square/Rectangle'
        TabOrder = 1
        object Shape4: TShape
          Left = 120
          Top = 16
          Width = 88
          Height = 88
          Brush.Color = clSilver
          Shape = stCircle
        end
        object Shape5: TShape
          Left = 136
          Top = 32
          Width = 56
          Height = 56
          Brush.Color = clGray
          Shape = stCircle
        end
        object Shape12: TShape
          Left = 146
          Top = 42
          Width = 36
          Height = 36
          Brush.Color = clAqua
        end
        object lbl_holewiz3: TLabel
          Left = 17
          Top = 59
          Width = 55
          Height = 13
          Caption = 'Width (mm)'
        end
        object lbl_holewiz2: TLabel
          Left = 17
          Top = 19
          Width = 60
          Height = 13
          Caption = 'Length (mm)'
        end
        object lbl_holewiz13: TLabel
          Left = 281
          Top = 67
          Width = 40
          Height = 13
          Caption = 'Pad Size'
        end
        object lbl_holewiz12: TLabel
          Left = 281
          Top = 43
          Width = 43
          Height = 13
          Caption = 'Hole Size'
        end
        object lbl_holewiz_square_holesize: TLabel
          Left = 345
          Top = 43
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz18: TLabel
          Left = 401
          Top = 43
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz_square_padsize: TLabel
          Left = 345
          Top = 67
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz19: TLabel
          Left = 401
          Top = 67
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object txt_sr_width: TEdit
          Left = 16
          Top = 75
          Width = 80
          Height = 21
          Alignment = taCenter
          TabOrder = 0
          Text = '0.7'
          OnChange = txt_sr_widthChange
        end
        object txt_sr_length: TEdit
          Left = 16
          Top = 35
          Width = 80
          Height = 21
          Alignment = taCenter
          TabOrder = 1
          Text = '1.5'
          OnChange = txt_sr_lengthChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 230
        Width = 444
        Height = 180
        Caption = 'Slotted'
        TabOrder = 2
        object Shape14: TShape
          Left = 104
          Top = 40
          Width = 88
          Height = 88
          Brush.Color = clSilver
          Shape = stCircle
        end
        object Shape15: TShape
          Left = 176
          Top = 40
          Width = 88
          Height = 88
          Brush.Color = clSilver
          Shape = stCircle
        end
        object Shape16: TShape
          Left = 144
          Top = 40
          Width = 80
          Height = 88
          Brush.Color = clSilver
        end
        object Shape17: TShape
          Left = 192
          Top = 56
          Width = 56
          Height = 56
          Brush.Color = clGray
          Shape = stCircle
        end
        object Shape18: TShape
          Left = 120
          Top = 56
          Width = 56
          Height = 56
          Brush.Color = clGray
          Shape = stCircle
        end
        object Shape19: TShape
          Left = 144
          Top = 56
          Width = 80
          Height = 56
          Brush.Color = clGray
        end
        object Shape20: TShape
          Left = 128
          Top = 64
          Width = 40
          Height = 40
          Brush.Color = clAqua
          Shape = stCircle
        end
        object Shape21: TShape
          Left = 200
          Top = 64
          Width = 40
          Height = 40
          Brush.Color = clAqua
          Shape = stCircle
        end
        object Shape22: TShape
          Left = 144
          Top = 64
          Width = 80
          Height = 40
          Brush.Color = clAqua
        end
        object lbl_holewiz5: TLabel
          Left = 9
          Top = 59
          Width = 55
          Height = 13
          Caption = 'Width (mm)'
        end
        object lbl_holewiz4: TLabel
          Left = 73
          Top = 11
          Width = 60
          Height = 13
          Caption = 'Length (mm)'
        end
        object lbl_holewiz14: TLabel
          Left = 281
          Top = 59
          Width = 50
          Height = 13
          Caption = 'Hole width'
        end
        object lbl_holewiz_slot_holelength: TLabel
          Left = 153
          Top = 131
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz15: TLabel
          Left = 281
          Top = 83
          Width = 47
          Height = 13
          Caption = 'Pad width'
        end
        object lbl_holewiz_slot_padwidth: TLabel
          Left = 345
          Top = 83
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz6: TLabel
          Left = 89
          Top = 131
          Width = 54
          Height = 13
          Caption = 'Hole length'
        end
        object lbl_holewiz7: TLabel
          Left = 89
          Top = 155
          Width = 51
          Height = 13
          Caption = 'Pad length'
        end
        object lbl_holewiz_slot_holewidth: TLabel
          Left = 345
          Top = 59
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz_slot_padlength: TLabel
          Left = 153
          Top = 155
          Width = 9
          Height = 19
          Alignment = taCenter
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz9: TLabel
          Left = 233
          Top = 155
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz21: TLabel
          Left = 401
          Top = 83
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz8: TLabel
          Left = 233
          Top = 131
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object lbl_holewiz20: TLabel
          Left = 401
          Top = 59
          Width = 28
          Height = 19
          Caption = 'mm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object txt_slot_width: TEdit
          Left = 8
          Top = 75
          Width = 80
          Height = 21
          TabOrder = 0
          Text = '0.7'
          OnChange = txt_slot_widthChange
        end
        object txt_slot_length: TEdit
          Left = 144
          Top = 11
          Width = 80
          Height = 21
          TabOrder = 1
          Text = '1.5'
          OnChange = txt_slot_lengthChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 410
        Width = 444
        Height = 40
        Caption = 'IPC-2221 Level'
        TabOrder = 3
        object rbt_holewiz_a: TRadioButton
          Left = 16
          Top = 16
          Width = 64
          Height = 16
          Caption = 'A'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbt_holewiz_aClick
        end
        object rbt_holewiz_b: TRadioButton
          Left = 56
          Top = 16
          Width = 64
          Height = 16
          Caption = 'B'
          TabOrder = 1
          OnClick = rbt_holewiz_bClick
        end
        object rbt_holewiz_c: TRadioButton
          Left = 96
          Top = 16
          Width = 64
          Height = 16
          Caption = 'C'
          TabOrder = 2
          OnClick = rbt_holewiz_cClick
        end
      end
      object btn_ApplyRoundToClicked: TButton
        Left = 456
        Top = 8
        Width = 140
        Height = 32
        Caption = 'Apply to Clicked'
        TabOrder = 4
      end
      object btn_ApplyRoundToCSelected: TButton
        Left = 456
        Top = 40
        Width = 140
        Height = 32
        Caption = 'Apply To Selected'
        TabOrder = 5
      end
      object btn_ApplyRoundToAll: TButton
        Left = 456
        Top = 72
        Width = 140
        Height = 32
        Caption = 'Apply To All'
        TabOrder = 6
      end
      object btn_ApplyRectToCSelected: TButton
        Left = 456
        Top = 152
        Width = 140
        Height = 32
        Caption = 'Apply To Selected'
        TabOrder = 7
      end
      object Button8: TButton
        Left = 456
        Top = 184
        Width = 140
        Height = 32
        Caption = 'Apply To All'
        TabOrder = 8
      end
      object btn_ApplyRectToClicked: TButton
        Left = 456
        Top = 120
        Width = 140
        Height = 32
        Caption = 'Apply to Clicked'
        TabOrder = 9
      end
      object Button10: TButton
        Left = 456
        Top = 272
        Width = 140
        Height = 32
        Caption = 'Apply To Selected'
        TabOrder = 10
      end
      object Button11: TButton
        Left = 456
        Top = 304
        Width = 140
        Height = 32
        Caption = 'Apply To All'
        TabOrder = 11
      end
      object Button12: TButton
        Left = 456
        Top = 240
        Width = 140
        Height = 32
        Caption = 'Apply to Clicked'
        TabOrder = 12
      end
      object CheckBox2: TCheckBox
        Left = 464
        Top = 416
        Width = 128
        Height = 24
        Caption = 'Entire library (All)'
        TabOrder = 13
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Thermal Wizard'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Shape70: TShape
        Left = 12
        Top = 194
        Width = 160
        Height = 160
        Brush.Color = clPurple
        Shape = stRoundRect
      end
      object Shape71: TShape
        Left = 20
        Top = 202
        Width = 144
        Height = 144
        Brush.Color = clRed
        Shape = stRoundRect
      end
      object Shape11: TShape
        Left = 28
        Top = 258
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape31: TShape
        Left = 76
        Top = 258
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape36: TShape
        Left = 83
        Top = 265
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape37: TShape
        Left = 35
        Top = 265
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape42: TShape
        Left = 52
        Top = 281
        Width = 32
        Height = 33
        Brush.Color = clGray
      end
      object Shape58: TShape
        Left = 99
        Top = 281
        Width = 33
        Height = 33
        Brush.Color = clGray
      end
      object Shape66: TShape
        Left = 124
        Top = 258
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape67: TShape
        Left = 131
        Top = 265
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape72: TShape
        Left = 28
        Top = 210
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape73: TShape
        Left = 35
        Top = 217
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape74: TShape
        Left = 76
        Top = 210
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape75: TShape
        Left = 83
        Top = 217
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape76: TShape
        Left = 124
        Top = 210
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape77: TShape
        Left = 131
        Top = 217
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape47: TShape
        Left = 52
        Top = 234
        Width = 32
        Height = 32
        Brush.Color = clGray
      end
      object Shape57: TShape
        Left = 99
        Top = 234
        Width = 33
        Height = 32
        Brush.Color = clGray
      end
      object Shape78: TShape
        Left = 28
        Top = 306
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape79: TShape
        Left = 35
        Top = 313
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape80: TShape
        Left = 76
        Top = 306
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape81: TShape
        Left = 83
        Top = 313
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape82: TShape
        Left = 124
        Top = 306
        Width = 30
        Height = 30
        Brush.Color = clSilver
        Shape = stCircle
      end
      object Shape83: TShape
        Left = 131
        Top = 313
        Width = 16
        Height = 16
        Brush.Color = clGreen
        Shape = stCircle
      end
      object Shape84: TShape
        Left = 52
        Top = 329
        Width = 32
        Height = 17
        Brush.Color = clGray
      end
      object Shape85: TShape
        Left = 99
        Top = 329
        Width = 33
        Height = 17
        Brush.Color = clGray
      end
      object Shape86: TShape
        Left = 99
        Top = 201
        Width = 33
        Height = 17
        Brush.Color = clGray
      end
      object Shape87: TShape
        Left = 52
        Top = 201
        Width = 32
        Height = 17
        Brush.Color = clGray
      end
      object Shape88: TShape
        Left = 147
        Top = 234
        Width = 17
        Height = 32
        Brush.Color = clGray
      end
      object Shape89: TShape
        Left = 147
        Top = 281
        Width = 17
        Height = 33
        Brush.Color = clGray
      end
      object Shape90: TShape
        Left = 147
        Top = 329
        Width = 17
        Height = 17
        Brush.Color = clGray
      end
      object Shape91: TShape
        Left = 147
        Top = 201
        Width = 17
        Height = 17
        Brush.Color = clGray
      end
      object Shape92: TShape
        Left = 19
        Top = 201
        Width = 17
        Height = 17
        Brush.Color = clGray
      end
      object Shape93: TShape
        Left = 19
        Top = 234
        Width = 17
        Height = 32
        Brush.Color = clGray
      end
      object Shape94: TShape
        Left = 19
        Top = 281
        Width = 17
        Height = 33
        Brush.Color = clGray
      end
      object Shape95: TShape
        Left = 19
        Top = 329
        Width = 17
        Height = 17
        Brush.Color = clGray
      end
      object Label2: TLabel
        Left = 312
        Top = 40
        Width = 60
        Height = 13
        Caption = 'Via Hole Size'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label3: TLabel
        Left = 312
        Top = 64
        Width = 84
        Height = 13
        Caption = 'Via Pad Size (top)'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label4: TLabel
        Left = 312
        Top = 200
        Width = 68
        Height = 13
        Caption = 'Paste Tile Size'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label6: TLabel
        Left = 312
        Top = 224
        Width = 88
        Height = 13
        Caption = 'Minimum Tile Sliver'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label7: TLabel
        Left = 312
        Top = 136
        Width = 54
        Height = 13
        Caption = 'Via Spacing'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Shape32: TShape
        Left = 308
        Top = 162
        Width = 296
        Height = 2
        Brush.Color = clGray
      end
      object Label8: TLabel
        Left = 312
        Top = 16
        Width = 67
        Height = 13
        Caption = 'Via Settings'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object Label9: TLabel
        Left = 312
        Top = 176
        Width = 105
        Height = 13
        Caption = 'Paste Tile Settings'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
      end
      object Label10: TLabel
        Left = 512
        Top = 64
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label11: TLabel
        Left = 512
        Top = 40
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label12: TLabel
        Left = 512
        Top = 136
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label13: TLabel
        Left = 512
        Top = 200
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label14: TLabel
        Left = 512
        Top = 224
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Shape34: TShape
        Left = 308
        Top = 258
        Width = 296
        Height = 2
        Brush.Color = clGray
      end
      object Label25: TLabel
        Left = 312
        Top = 88
        Width = 84
        Height = 13
        Caption = 'Via Pad Size (mid)'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label26: TLabel
        Left = 512
        Top = 88
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label27: TLabel
        Left = 312
        Top = 112
        Width = 90
        Height = 13
        Caption = 'Via Pad Size (back)'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object Label28: TLabel
        Left = 512
        Top = 112
        Width = 16
        Height = 13
        Caption = 'mm'
        Color = clWhite
        ParentColor = False
        Transparent = False
      end
      object txt_thermal_holesize: TEdit
        Left = 416
        Top = 40
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 0
        Text = '0.254'
      end
      object txt_thermal_toppad: TEdit
        Left = 416
        Top = 64
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 1
        Text = '0.508'
      end
      object txt_thermal_pastetile: TEdit
        Left = 416
        Top = 200
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 2
        Text = '0.9'
      end
      object txt_thermal_minimumtile: TEdit
        Left = 416
        Top = 224
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 3
        Text = '0.1'
      end
      object Button7: TButton
        Left = 464
        Top = 408
        Width = 140
        Height = 34
        Caption = 'Place'
        TabOrder = 4
        OnClick = Button7Click
      end
      object txt_thermal_pitch: TEdit
        Left = 416
        Top = 136
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 5
        Text = '1.1'
      end
      object GroupBox9: TGroupBox
        Left = 16
        Top = 34
        Width = 260
        Height = 136
        Caption = 'Soldermask Type'
        TabOrder = 6
        object tw_openmask: TRadioButton
          Left = 24
          Top = 56
          Width = 148
          Height = 16
          Caption = 'Open Soldermask'
          Enabled = False
          TabOrder = 0
        end
        object tw_ring: TRadioButton
          Left = 24
          Top = 80
          Width = 180
          Height = 16
          Caption = 'Via ring only'
          Enabled = False
          TabOrder = 1
        end
        object tw_waffle: TRadioButton
          Left = 24
          Top = 104
          Width = 180
          Height = 16
          Caption = 'Waffle structure'
          Enabled = False
          TabOrder = 2
        end
        object tw_simplestructure: TRadioButton
          Left = 24
          Top = 32
          Width = 104
          Height = 16
          Caption = 'Simple Structure'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
      end
      object Button9: TButton
        Left = 304
        Top = 408
        Width = 128
        Height = 32
        Caption = 'Realign all'
        TabOrder = 7
      end
      object txt_thermal_midpad: TEdit
        Left = 416
        Top = 88
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 8
        Text = '0.508'
      end
      object txt_thermal_backpad: TEdit
        Left = 416
        Top = 112
        Width = 88
        Height = 21
        Alignment = taCenter
        TabOrder = 9
        Text = '0.6'
      end
    end
    object Settings: TTabSheet
      Caption = 'QFN wizard'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 660
      ExplicitHeight = 0
      object Shape98: TShape
        Left = 220
        Top = 42
        Width = 40
        Height = 80
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape99: TShape
        Left = 220
        Top = 18
        Width = 40
        Height = 72
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape68: TShape
        Left = 172
        Top = 42
        Width = 40
        Height = 80
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape69: TShape
        Left = 172
        Top = 18
        Width = 40
        Height = 72
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape51: TShape
        Left = 60
        Top = 154
        Width = 48
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape56: TShape
        Left = 60
        Top = 202
        Width = 48
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape55: TShape
        Left = 20
        Top = 202
        Width = 72
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape50: TShape
        Left = 20
        Top = 154
        Width = 72
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape43: TShape
        Left = 124
        Top = 18
        Width = 40
        Height = 72
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape45: TShape
        Left = 124
        Top = 42
        Width = 40
        Height = 80
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape38: TShape
        Left = 20
        Top = 106
        Width = 72
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stRoundRect
      end
      object Shape39: TShape
        Left = 60
        Top = 106
        Width = 48
        Height = 40
        Brush.Color = clPurple
        Pen.Color = clPurple
        Shape = stCircle
      end
      object Shape40: TShape
        Left = 68
        Top = 114
        Width = 32
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape35: TShape
        Left = 28
        Top = 114
        Width = 56
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape41: TShape
        Left = 132
        Top = 26
        Width = 24
        Height = 56
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape44: TShape
        Left = 132
        Top = 66
        Width = 24
        Height = 32
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape49: TShape
        Left = 28
        Top = 162
        Width = 56
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape52: TShape
        Left = 68
        Top = 162
        Width = 32
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape54: TShape
        Left = 28
        Top = 210
        Width = 56
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape61: TShape
        Left = 68
        Top = 210
        Width = 32
        Height = 24
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape64: TShape
        Left = 180
        Top = 66
        Width = 24
        Height = 32
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape65: TShape
        Left = 180
        Top = 26
        Width = 24
        Height = 56
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape96: TShape
        Left = 228
        Top = 66
        Width = 24
        Height = 32
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stCircle
      end
      object Shape97: TShape
        Left = 228
        Top = 26
        Width = 24
        Height = 56
        Brush.Color = clRed
        Pen.Color = clRed
        Shape = stRoundRect
      end
      object Shape48: TShape
        Left = 192
        Top = 58
        Width = 1
        Height = 116
        Brush.Color = clGray
      end
      object Shape46: TShape
        Left = 60
        Top = 174
        Width = 132
        Height = 1
        Brush.Color = clGray
      end
      object GroupBox6: TGroupBox
        Left = 272
        Top = 128
        Width = 332
        Height = 210
        Caption = 'Geometry'
        TabOrder = 0
        object Label15: TLabel
          Left = 135
          Top = 49
          Width = 74
          Height = 13
          Caption = 'Horizontal pitch'
        end
        object Label16: TLabel
          Left = 136
          Top = 76
          Width = 61
          Height = 13
          Caption = 'Vertical pitch'
        end
        object Label17: TLabel
          Left = 303
          Top = 52
          Width = 16
          Height = 13
          Caption = 'mm'
        end
        object Label18: TLabel
          Left = 303
          Top = 73
          Width = 16
          Height = 13
          Caption = 'mm'
        end
        object Shape7: TShape
          Left = 12
          Top = 38
          Width = 310
          Height = 1
          Brush.Color = clGray
        end
        object RadioButton5: TRadioButton
          Left = 12
          Top = 16
          Width = 124
          Height = 16
          Caption = 'Use existing Geometry'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton6: TRadioButton
          Left = 12
          Top = 40
          Width = 104
          Height = 24
          Caption = 'New geometry'
          TabOrder = 1
        end
        object Edit6: TEdit
          Left = 212
          Top = 48
          Width = 80
          Height = 21
          TabOrder = 2
          Text = 'txt_qfn_newpadLength'
        end
        object Edit7: TEdit
          Left = 212
          Top = 73
          Width = 80
          Height = 21
          TabOrder = 3
          Text = 'Edit6'
        end
        object GroupBox8: TGroupBox
          Left = 56
          Top = 96
          Width = 272
          Height = 106
          Caption = 'Pitch Alignment'
          TabOrder = 4
          object Shape104: TShape
            Left = 124
            Top = 26
            Width = 48
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stCircle
          end
          object Shape101: TShape
            Left = 108
            Top = 26
            Width = 40
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stRoundRect
          end
          object Shape102: TShape
            Left = 116
            Top = 34
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stRoundRect
          end
          object Shape103: TShape
            Left = 132
            Top = 34
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stCircle
          end
          object Shape105: TShape
            Left = 220
            Top = 26
            Width = 40
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stRoundRect
          end
          object Shape106: TShape
            Left = 196
            Top = 26
            Width = 48
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stCircle
          end
          object Shape107: TShape
            Left = 204
            Top = 34
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stCircle
          end
          object Shape108: TShape
            Left = 220
            Top = 34
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stRoundRect
          end
          object Shape109: TShape
            Left = 132
            Top = 42
            Width = 100
            Height = 1
            Brush.Color = clGray
          end
          object Shape110: TShape
            Left = 108
            Top = 66
            Width = 40
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stRoundRect
          end
          object Shape111: TShape
            Left = 124
            Top = 66
            Width = 48
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stCircle
          end
          object Shape112: TShape
            Left = 132
            Top = 74
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stCircle
          end
          object Shape113: TShape
            Left = 116
            Top = 74
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stRoundRect
          end
          object Shape114: TShape
            Left = 196
            Top = 66
            Width = 48
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stCircle
          end
          object Shape115: TShape
            Left = 220
            Top = 66
            Width = 40
            Height = 32
            Brush.Color = clPurple
            Pen.Color = clPurple
            Shape = stRoundRect
          end
          object Shape116: TShape
            Left = 220
            Top = 74
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stRoundRect
          end
          object Shape117: TShape
            Left = 204
            Top = 74
            Width = 32
            Height = 16
            Brush.Color = clRed
            Pen.Color = clRed
            Shape = stCircle
          end
          object Shape118: TShape
            Left = 156
            Top = 82
            Width = 55
            Height = 1
            Brush.Color = clGray
          end
          object RadioButton7: TRadioButton
            Left = 16
            Top = 32
            Width = 84
            Height = 16
            Caption = 'Center'
            TabOrder = 0
          end
          object RadioButton8: TRadioButton
            Left = 16
            Top = 72
            Width = 56
            Height = 16
            Caption = 'Edge'
            TabOrder = 1
          end
        end
      end
      object GroupBox7: TGroupBox
        Left = 272
        Top = 10
        Width = 332
        Height = 112
        Caption = 'Pad definition'
        TabOrder = 1
        object lbl_qfn_newpadwidth: TLabel
          Left = 160
          Top = 76
          Width = 28
          Height = 13
          Caption = 'Width'
        end
        object lbl_qfn_newpadLength: TLabel
          Left = 159
          Top = 46
          Width = 33
          Height = 13
          Caption = 'Length'
        end
        object qfn_Label16: TLabel
          Left = 303
          Top = 46
          Width = 16
          Height = 13
          Caption = 'mm'
        end
        object qfn_Label18: TLabel
          Left = 303
          Top = 73
          Width = 16
          Height = 13
          Caption = 'mm'
        end
        object Shape6: TShape
          Left = 104
          Top = 54
          Width = 1
          Height = 48
          Brush.Color = clGray
        end
        object RadioButton3: TRadioButton
          Left = 12
          Top = 24
          Width = 124
          Height = 16
          Caption = 'Use existing padsize'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton4: TRadioButton
          Left = 12
          Top = 48
          Width = 84
          Height = 24
          Caption = 'New padsize'
          TabOrder = 1
        end
        object txt_qfn_newpadLength: TEdit
          Left = 212
          Top = 44
          Width = 80
          Height = 21
          TabOrder = 2
          Text = 'txt_qfn_newpadLength'
        end
        object txt_qfn_newpadwidth: TEdit
          Left = 212
          Top = 73
          Width = 80
          Height = 21
          TabOrder = 3
          Text = 'Edit6'
        end
      end
      object Button14: TButton
        Left = 468
        Top = 400
        Width = 132
        Height = 32
        Caption = 'Apply'
        TabOrder = 2
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Settings'
      ExplicitHeight = 454
      object GroupBox10: TGroupBox
        Left = 8
        Top = 8
        Width = 236
        Height = 74
        Caption = 'Designator (magic string)'
        TabOrder = 0
        object settings_rdio_adddesignator: TRadioButton
          Left = 16
          Top = 24
          Width = 132
          Height = 16
          Caption = 'Add if missing'
          TabOrder = 0
        end
        object settings_rdio_removedesignator: TRadioButton
          Left = 16
          Top = 48
          Width = 80
          Height = 16
          Caption = 'Remove'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
      end
      object GroupBox11: TGroupBox
        Left = 256
        Top = 200
        Width = 236
        Height = 106
        Caption = 'Assembly Layer'
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 24
          Width = 77
          Height = 13
          Caption = 'Line Width (mm)'
        end
        object Label22: TLabel
          Left = 88
          Top = 70
          Width = 77
          Height = 13
          Caption = 'Line Width (mm)'
        end
        object txt_assemblylinewidth: TEdit
          Left = 172
          Top = 24
          Width = 60
          Height = 21
          TabOrder = 0
          Text = '0.05'
        end
        object chk_rebuildassembly: TCheckBox
          Left = 8
          Top = 48
          Width = 128
          Height = 16
          Caption = 'Rebuild'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chk_markassemblypins: TCheckBox
          Left = 8
          Top = 70
          Width = 68
          Height = 16
          Caption = 'Mark Pins'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object txt_AssemblyPinLineWith: TEdit
          Left = 172
          Top = 70
          Width = 60
          Height = 21
          TabOrder = 3
          Text = '0.05'
        end
      end
      object GroupBox12: TGroupBox
        Left = 256
        Top = 8
        Width = 236
        Height = 74
        Caption = 'Courtyard'
        TabOrder = 2
        object Label19: TLabel
          Left = 8
          Top = 24
          Width = 77
          Height = 13
          Caption = 'Line Width (mm)'
        end
        object Label23: TLabel
          Left = 8
          Top = 48
          Width = 95
          Height = 13
          Caption = 'Boundary Gap (mm)'
        end
        object txt_courtyardwidth: TEdit
          Left = 172
          Top = 24
          Width = 60
          Height = 21
          TabOrder = 0
          Text = '0.05'
        end
        object txt_courtyardgap: TEdit
          Left = 172
          Top = 48
          Width = 60
          Height = 21
          TabOrder = 1
          Text = '0.25'
        end
      end
      object GroupBox13: TGroupBox
        Left = 256
        Top = 82
        Width = 236
        Height = 120
        Caption = 'Silkscreen'
        TabOrder = 3
        object Label21: TLabel
          Left = 8
          Top = 24
          Width = 77
          Height = 13
          Caption = 'Line Width (mm)'
        end
        object Label24: TLabel
          Left = 8
          Top = 96
          Width = 145
          Height = 13
          Caption = 'Silk-to Copper Clearance (mm)'
        end
        object txt_silkscreenwidth: TEdit
          Left = 172
          Top = 24
          Width = 60
          Height = 21
          TabOrder = 0
          Text = '0.15'
        end
        object chk_rebuildsilkscreen: TCheckBox
          Left = 8
          Top = 72
          Width = 128
          Height = 16
          Caption = 'Rebuild (Experimental)'
          TabOrder = 1
        end
        object txt_silktocopper: TEdit
          Left = 172
          Top = 96
          Width = 60
          Height = 21
          TabOrder = 2
          Text = '0.15'
        end
        object chk_wipesilkscreen: TCheckBox
          Left = 8
          Top = 48
          Width = 128
          Height = 16
          Caption = 'Wipe'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
      object GroupBox14: TGroupBox
        Left = 8
        Top = 304
        Width = 236
        Height = 130
        Caption = 'Pin 1 Indicator'
        TabOrder = 4
        object chk_pin1removedots: TCheckBox
          Left = 8
          Top = 24
          Width = 120
          Height = 16
          Caption = 'Remove Dots'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chk_pin1markoncourtyard: TCheckBox
          Left = 8
          Top = 48
          Width = 120
          Height = 16
          Caption = 'Mark on Courtyard'
          TabOrder = 1
        end
        object chk_pin1markonassembly: TCheckBox
          Left = 8
          Top = 72
          Width = 212
          Height = 16
          Caption = 'Mark on Assembly (if assembly enabled)'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cmb_pin1style: TComboBox
          Left = 8
          Top = 101
          Width = 168
          Height = 21
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 3
          Text = '1 - Arrow to edge'
          Items.Strings = (
            '0 - None'
            '1 - Arrow to edge'
            '2 - Arrow to Center'
            '3 - Box'
            '4 - Box + diagonal')
        end
      end
      object GroupBox15: TGroupBox
        Left = 8
        Top = 90
        Width = 236
        Height = 128
        Caption = 'Thru-Hole Pads'
        TabOrder = 5
        object Label36: TLabel
          Left = 16
          Top = 56
          Width = 56
          Height = 13
          Caption = 'Pin 1 Shape'
        end
        object chk_apply2221: TCheckBox
          Left = 16
          Top = 24
          Width = 196
          Height = 16
          Caption = 'Apply IPC2221 Pad sizing'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object settings_rdio_pin1_leave: TRadioButton
          Left = 88
          Top = 56
          Width = 136
          Height = 16
          Caption = 'Leave Shape As-Is'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object settings_rdio_pin1_square: TRadioButton
          Left = 88
          Top = 72
          Width = 136
          Height = 16
          Caption = 'Force Square'
          TabOrder = 2
        end
        object settings_rdio_pin1_round: TRadioButton
          Left = 88
          Top = 88
          Width = 136
          Height = 16
          Caption = 'Force Round'
          TabOrder = 3
        end
      end
      object GroupBox17: TGroupBox
        Left = 256
        Top = 306
        Width = 236
        Height = 128
        Caption = 'Soldermask Clearance'
        TabOrder = 6
        object Label29: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'to SMT pad (mm)'
        end
        object Label30: TLabel
          Left = 8
          Top = 72
          Width = 107
          Height = 13
          Caption = 'to Mounting hole (mm)'
        end
        object Label31: TLabel
          Left = 8
          Top = 96
          Width = 77
          Height = 13
          Caption = 'to via hole (mm)'
        end
        object Label20: TLabel
          Left = 8
          Top = 48
          Width = 74
          Height = 13
          Caption = 'to TH pad (mm)'
        end
        object txt_soldermask_to_smt: TEdit
          Left = 172
          Top = 24
          Width = 60
          Height = 21
          TabOrder = 0
          Text = '0.05'
        end
        object txt_soldermask_to_mech: TEdit
          Left = 172
          Top = 72
          Width = 60
          Height = 21
          TabOrder = 1
          Text = '0.1'
        end
        object txt_soldermask_to_via: TEdit
          Left = 172
          Top = 96
          Width = 60
          Height = 21
          TabOrder = 2
          Text = '0.075'
        end
        object txt_soldermask_to_th: TEdit
          Left = 172
          Top = 48
          Width = 60
          Height = 21
          TabOrder = 3
          Text = '0.075'
        end
      end
      object GroupBox16: TGroupBox
        Left = 504
        Top = 8
        Width = 236
        Height = 194
        Caption = 'SMT Pads'
        TabOrder = 7
        object Label5: TLabel
          Left = 8
          Top = 96
          Width = 108
          Height = 13
          Caption = 'Corner Rounding (mm)'
        end
        object RadioButton1: TRadioButton
          Left = 16
          Top = 24
          Width = 132
          Height = 16
          Caption = 'Round'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButton2: TRadioButton
          Left = 16
          Top = 48
          Width = 80
          Height = 16
          Caption = 'Leave As is'
          TabOrder = 1
        end
        object Edit5: TEdit
          Left = 172
          Top = 96
          Width = 60
          Height = 21
          TabOrder = 2
          Text = '0.05'
        end
      end
      object GroupBox18: TGroupBox
        Left = 504
        Top = 208
        Width = 236
        Height = 194
        Caption = 'Layer assignment'
        TabOrder = 8
        object Label48: TLabel
          Left = 8
          Top = 24
          Width = 40
          Height = 13
          Caption = '3D Body'
        end
        object Label49: TLabel
          Left = 8
          Top = 48
          Width = 45
          Height = 13
          Caption = 'Assembly'
        end
        object Label50: TLabel
          Left = 8
          Top = 72
          Width = 49
          Height = 13
          Caption = 'Courtyard'
        end
        object Label51: TLabel
          Left = 8
          Top = 96
          Width = 41
          Height = 13
          Caption = 'Centroid'
        end
        object Label52: TLabel
          Left = 8
          Top = 120
          Width = 52
          Height = 13
          Caption = 'Designator'
        end
        object Edit8: TEdit
          Left = 172
          Top = 24
          Width = 60
          Height = 21
          TabOrder = 0
          Text = '2'
        end
        object Edit9: TEdit
          Left = 172
          Top = 48
          Width = 60
          Height = 21
          TabOrder = 1
          Text = '5'
        end
        object Edit10: TEdit
          Left = 172
          Top = 72
          Width = 60
          Height = 21
          TabOrder = 2
          Text = '3'
        end
        object Edit11: TEdit
          Left = 172
          Top = 96
          Width = 60
          Height = 21
          TabOrder = 3
          Text = '3'
        end
        object Edit12: TEdit
          Left = 172
          Top = 120
          Width = 60
          Height = 21
          TabOrder = 4
          Text = '5'
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'SchLib PATCHER'
      ExplicitHeight = 454
      object Label32: TLabel
        Left = 16
        Top = 56
        Width = 27
        Height = 13
        Caption = 'Name'
        Visible = False
      end
      object Label33: TLabel
        Left = 16
        Top = 80
        Width = 53
        Height = 13
        Caption = 'Description'
        Visible = False
      end
      object Label34: TLabel
        Left = 136
        Top = 112
        Width = 52
        Height = 13
        Caption = 'Designator'
      end
      object Label35: TLabel
        Left = 248
        Top = 112
        Width = 45
        Height = 13
        Caption = 'Comment'
      end
      object Label37: TLabel
        Left = 488
        Top = 208
        Width = 121
        Height = 13
        Caption = '- Pin names to uppercase'
      end
      object Label38: TLabel
        Left = 488
        Top = 224
        Width = 166
        Height = 13
        Caption = '- Pin margin on rotated names to 1'
      end
      object Label39: TLabel
        Left = 488
        Top = 240
        Width = 96
        Height = 13
        Caption = '- Rectangle color fix'
      end
      object Shape10: TShape
        Left = 8
        Top = 104
        Width = 580
        Height = 1
      end
      object Label40: TLabel
        Left = 16
        Top = 112
        Width = 115
        Height = 13
        Caption = 'Symbol Library Cleanup '
        Visible = False
      end
      object Label41: TLabel
        Left = 487
        Top = 112
        Width = 76
        Height = 13
        Caption = '- Fix Designator'
      end
      object Label42: TLabel
        Left = 487
        Top = 128
        Width = 69
        Height = 13
        Caption = '- Fix Comment'
      end
      object Label43: TLabel
        Left = 487
        Top = 144
        Width = 114
        Height = 13
        Caption = '- Fix Missing Description'
      end
      object Label44: TLabel
        Left = 487
        Top = 160
        Width = 79
        Height = 13
        Caption = '- Fix illegal chars'
      end
      object Label45: TLabel
        Left = 487
        Top = 176
        Width = 113
        Height = 13
        Caption = '- Comment UPPERCASE'
      end
      object Label46: TLabel
        Left = 487
        Top = 192
        Width = 121
        Height = 13
        Caption = '- Description UPPERCASE'
      end
      object Label47: TLabel
        Left = 488
        Top = 256
        Width = 93
        Height = 13
        Caption = '- Line / Arc color fix'
      end
      object Button16: TButton
        Left = 8
        Top = 8
        Width = 140
        Height = 34
        Caption = 'Extract Symbol Names'
        TabOrder = 0
        OnClick = Schlib_Extract
      end
      object Button17: TButton
        Left = 152
        Top = 8
        Width = 104
        Height = 34
        Caption = 'Begin Edit'
        TabOrder = 1
        OnClick = Button17Click
      end
      object Button18: TButton
        Left = 508
        Top = 56
        Width = 92
        Height = 34
        Caption = 'Next'
        TabOrder = 2
        Visible = False
        OnClick = Button18Click
      end
      object Edit1: TEdit
        Left = 136
        Top = 48
        Width = 316
        Height = 21
        TabOrder = 3
        Text = 'Edit1'
        Visible = False
      end
      object Edit2: TEdit
        Left = 136
        Top = 72
        Width = 316
        Height = 21
        TabOrder = 4
        Text = 'Edit1'
        Visible = False
      end
      object Button19: TButton
        Left = 500
        Top = 384
        Width = 108
        Height = 18
        Caption = 'Set Fields'
        TabOrder = 5
        Visible = False
        OnClick = Button19Click
      end
      object Edit3: TEdit
        Left = 192
        Top = 112
        Width = 44
        Height = 21
        TabOrder = 6
        Text = 'U?'
      end
      object Edit4: TEdit
        Left = 304
        Top = 112
        Width = 76
        Height = 21
        TabOrder = 7
        Text = '=SAP'
      end
      object Button20: TButton
        Left = 500
        Top = 328
        Width = 109
        Height = 26
        Caption = 'Set PINNAME Rotation to 90'
        TabOrder = 8
        OnClick = Button20Click
      end
      object Memo2: TMemo
        Left = 12
        Top = 138
        Width = 464
        Height = 312
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Consolas'
        Font.Style = []
        Lines.Strings = (
          '>> Ready')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 9
      end
      object Button21: TButton
        Left = 500
        Top = 410
        Width = 108
        Height = 38
        Caption = 'Process Library'
        TabOrder = 10
        OnClick = Button21Click
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 689
    Top = 520
    object NFile2: TMenuItem
      Caption = 'File'
      object NQuit1: TMenuItem
        Caption = 'Quit'
        OnClick = endscript
      end
    end
    object NSystemTools1: TMenuItem
      Caption = 'Footprint'
      object NUnlockProcesses1: TMenuItem
        Caption = 'Full Cleanup'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object NSelectAllPads1: TMenuItem
        Caption = 'Select All Pads'
        OnClick = MNU_GrabAllPads
      end
      object NSetPin1rectangle1: TMenuItem
        Caption = 'Set Pin 1 rectangle'
        OnClick = MNU_Setpin1Square
      end
      object NRoundSMDPads1: TMenuItem
        Caption = 'Round SMD Pads'
      end
      object NFixThermalPad1: TMenuItem
        Caption = 'Fix Thermal Pad'
        OnClick = MNU_FixthermalPad
      end
      object NMakeSoldermaskDefined1: TMenuItem
        Caption = 'Make Soldermask Defined'
      end
    end
    object NLayerTools1: TMenuItem
      Caption = 'Tools'
      object NExport1: TMenuItem
        Caption = 'Export LayerStack'
      end
      object NImport1: TMenuItem
        Caption = 'Import Layerstack'
        OnClick = MNU_ImportMechLayerFromFile
      end
      object NImportDefaultLayerstack1: TMenuItem
        Caption = 'Import Default Layerstack'
        OnClick = MNU_ImportMechLayerDefault
      end
      object NUnBind1: TMenuItem
        Caption = 'UnBind Mechanical Layers'
        OnClick = MNU_UnbindMechLayers
      end
      object NRemoveUnusedMechLayers1: TMenuItem
        Caption = 'Remove Unused Mech Layers'
        OnClick = MNU_RemoveUnusedLayers
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object NUnlockAllProcesses1: TMenuItem
        Caption = 'Unlock All Processes'
        OnClick = MNU_UnlockProcesses
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object NDeCrapify1: TMenuItem
        Caption = 'Reset View Style'
        OnClick = MNU_Resetstyle
      end
    end
    object NOptions1: TMenuItem
      Caption = 'Options'
      OnClick = MNU_Options
    end
  end
end
