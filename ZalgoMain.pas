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
    Button1: TButton;
    TrackBar1: TTrackBar;
    ckAbove: TCheckBox;
    ckBelow: TCheckBox;
    TrackBar2: TTrackBar;
    procedure Button1Click(Sender: TObject);
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
  TGlitchType = set of (gtAbove, gtBelow);

const
  CombiningAbove: array[0 .. 30] of Char = (#$0300, #$0301, #$0302, #$0303,
    #$0304, #$0305, #$0306, #$0307, #$0308, #$0309, #$030A, #$030B, #$030C,
    #$030D, #$030E, #$030F, #$0310, #$0311, #$0312, #$0313, #$0314, #$033D,
    #$033E, #$033F, #$0340, #$0341, #$0342, #$0343, #$0344,  #$031A, #$031B);
  CombiningBelow: array [0 .. 21] of Char = (#$0316, #$031E, #$0317, #$0318,
    #$0319, #$031C, #$031D, #$031F, #$0320, #$0321, #$0322, #$0323, #$0324,
    #$0325, #$0326, #$0327, #$0328, #$0329, #$032A, #$032B, #$032C, #$032D);

function ZalgoText(const InputText: string;
  Intensity: Integer = 8; GlitchType:
  TGlitchType = [gtAbove, gtBelow]): string;
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

    Insert(CharsToAdd, Result, i + Offset);
    Inc(Offset, Length(CharsToAdd));  // Adjust offset for each insertion
  end;
end;

procedure TForm16.Button1Click(Sender: TObject);
begin
  Randomize;
  FSeed := RandSeed;
  Label1.Text := ZalgoText(Edit1.Text, 8);
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

  ListBox3.ItemHeight := 30;
  for var i := 1 to Length(CombiningBelow) do
  begin
    var idx := ListBox3.Items.Add('-'+CombiningBelow[Pred(i)]);
    ListBox3.ListItems[idx].StyledSettings := [];
    ListBox3.ListItems[idx].Font.Size := 20;
    ListBox3.ListItems[idx].IsChecked := True;
  end;

  ListBox1.ItemIndex := 0;
  ListBox3.ItemIndex := 0;

  Label1.Text := ZalgoText(Edit1.Text, 8);
end;

procedure TForm16.TrackBar1Change(Sender: TObject);
begin
  var levels: TGlitchType;
  if ckAbove.IsChecked then
    levels := [gtAbove];
  if ckBelow.IsChecked then
    levels := levels + [gtBelow];

  Label1.Text := ZalgoText(Edit1.Text, Trunc(TrackBar1.Value), levels);
end;

procedure TForm16.TrackBar2Change(Sender: TObject);
begin
  Label1.Font.Size := Round(TrackBar2.Value);
end;

end.
