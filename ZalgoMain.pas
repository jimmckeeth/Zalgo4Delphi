unit ZalgoMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Layouts, FMX.ListBox;

type
  TForm16 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    ListBox1: TListBox;
    ListBox3: TListBox;
    TrackBar1: TTrackBar;
    ckAbove: TCheckBox;
    ckBelow: TCheckBox;
    TrackBar2: TTrackBar;
    ckWithin: TCheckBox;
    Layout1: TLayout;
    ListBox2: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form16: TForm16;
  FSeed: Integer;

implementation

{$R *.fmx}

type
  TGlitchType = set of (gtAbove, gtBelow, gtWithin);

const
  CombiningAbove: array of Char = [
  #$030d, { Ì   } #$030e, { ÌŽ } #$0304, { Ì„ } #$0305, { Ì… }
  #$033f, { Ì¿  } #$0311, { Ì‘ } #$0306, { Ì† } #$0310, { Ì  }
  #$0352, { Í’  } #$0357, { Í— } #$0351, { Í‘ } #$0307, { Ì‡ }
  #$0308, { Ìˆ  } #$030a, { ÌŠ } #$0342, { Í‚ } #$0343, { Ì“ }
  #$0344, { ÌˆÌ } #$034a, { ÍŠ } #$034b, { Í‹ } #$034c, { ÍŒ }
  #$0303, { Ìƒ  } #$0302, { Ì‚ } #$030c, { ÌŒ } #$0350, { Í  }
  #$0300, { Ì€  } #$0301, { Ì  } #$030b, { Ì‹ } #$030f, { Ì  }
  #$0312, { Ì’  } #$0313, { Ì“ } #$0314, { Ì” } #$033d, { Ì½ }
  #$0309, { Ì‰  } #$0363, { Í£ } #$0364, { Í¤ } #$0365, { Í¥ }
  #$0366, { Í¦  } #$0367, { Í§ } #$0368, { Í¨ } #$0369, { Í© }
  #$036a, { Íª  } #$036b, { Í« } #$036c, { Í¬ } #$036d, { Í­ }
  #$036e, { Í®  } #$036f, { Í¯ } #$033e, { Ì¾ } #$035b, { Í› }
  #$0346, { Í†  } #$031a  { Ìš }];
  CombiningBelow: array of Char = [
  #$0316, { Ì– } #$0317, { Ì— }  #$0318, { Ì˜ } #$0319, { Ì™ }
  #$031c, { Ìœ } #$031d, { Ì  }  #$031e, { Ìž } #$031f, { ÌŸ }
  #$0320, { Ì  } #$0324, { Ì¤ }  #$0325, { Ì¥ } #$0326, { Ì¦ }
  #$0329, { Ì© } #$032a, { Ìª }  #$032b, { Ì« } #$032c, { Ì¬ }
  #$032d, { Ì­ } #$032e, { Ì® }  #$032f, { Ì¯ } #$0330, { Ì° }
  #$0331, { Ì± } #$0332, { Ì² }  #$0333, { Ì³ } #$0339, { Ì¹ }
  #$033a, { Ìº } #$033b, { Ì» }  #$033c, { Ì¼ } #$0345, { Í… }
  #$0347, { Í‡ } #$0348, { Íˆ }  #$0349, { Í‰ } #$034d, { Í  }
  #$034e, { ÍŽ } #$0353, { Í“ }  #$0354, { Í” } #$0355, { Í• }
  #$0356, { Í– } #$0359, { Í™ }  #$035a, { Íš } #$0323  { Ì£ }];
  CombiningWithin: array of Char = [
  #$0315, { Ì• } #$031b, { Ì› } #$0340, { Ì€  } #$0341, { Ì  }
  #$0358, { Í˜ } #$0321, { Ì¡ } #$0322, { Ì¢  } #$0327, { Ì§ }
  #$0328, { Ì¨ } #$0334, { Ì´ } #$0335, { Ìµ  } #$0336, { Ì¶ }
  #$034f, { Í  } #$035c, { Íœ } #$035d, { Í   } #$035e, { Íž }
  #$035f, { ÍŸ } #$0360, { Í  } #$0362, { Í¢  } #$0338, { Ì¸ }
  #$0337, { Ì· } #$0361, { Í¡ } #$0489  { Ò‰_ }];

function ZalgoText(const InputText: string;
  Intensity: Integer = 8; GlitchType:
  TGlitchType = [gtAbove, gtBelow, gtWithin]): string;
begin
  Result := InputText + ' ';
  RandSeed := FSeed;
  var Offset := 0;

  for var i := 1 to Length(Result) do
  begin
    var CharsToAdd := '';
    if gtAbove in GlitchType then
      for var j := 1 to (Intensity) do
        CharsToAdd := CharsToAdd + CombiningAbove[Random(Length(CombiningAbove))];

    if gtBelow in GlitchType then
      for var j := 1 to (Intensity) do
        CharsToAdd := CharsToAdd + CombiningBelow[Random(Length(CombiningBelow))];

    if gtWithin in GlitchType then
      for var j := 1 to Intensity do
        CharsToAdd := CharsToAdd + CombiningWithin[Random(Length(CombiningWithin))];

    Insert(CharsToAdd, Result, i + Offset);
    Inc(Offset, Length(CharsToAdd));  // Adjust offset for each insertion
  end;
end;

procedure TForm16.FormCreate(Sender: TObject);
begin
  for var i := 1 to Length(CombiningAbove) do
  begin
    var idx := ListBox1.Items.Add('-'+CombiningAbove[Pred(i)]);
    ListBox1.ListItems[idx].StyledSettings := [];
    ListBox1.ListItems[idx].Font.Size := 20;
    ListBox1.ListItems[idx].IsChecked := True;
  end;

  for var i := 1 to Length(CombiningWithin) do
  begin
    var idx := ListBox2.Items.Add('-'+CombiningWithin[Pred(i)]);
    ListBox2.ListItems[idx].StyledSettings := [];
    ListBox2.ListItems[idx].Font.Size := 20;
    ListBox2.ListItems[idx].IsChecked := True;
  end;

  ListBox3.ItemHeight := 30;
  for var i := 1 to Length(CombiningBelow) do
  begin
    var idx := ListBox3.Items.Add('-'+CombiningBelow[Pred(i)]);
    ListBox3.ListItems[idx].StyledSettings := [];
    ListBox3.ListItems[idx].Font.Size := 20;
    ListBox3.ListItems[idx].IsChecked := True;
  end;

  ListBox1.ItemIndex := 0;
  ListBox2.ItemIndex := 0;
  ListBox3.ItemIndex := 0;

  Label1.Text := ZalgoText(Edit1.Text, 8);
end;

procedure TForm16.TrackBar1Change(Sender: TObject);
begin
  var levels: TGlitchType := [];
  if ckAbove.IsChecked then
    levels := [gtAbove];
  if ckBelow.IsChecked then
    levels := levels + [gtBelow];
  if ckWithin.IsChecked then
    levels := levels + [gtWithin];

  Label1.Text := ZalgoText(Edit1.Text, Trunc(TrackBar1.Value), levels);
end;

procedure TForm16.TrackBar2Change(Sender: TObject);
begin
  Label1.Font.Size := Round(TrackBar2.Value);
end;

end.
