unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edtPlain: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    EdtResult: TEdit;
    edtKey: TEdit;
    Label3: TLabel;
    Button4: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    cbSpace: TCheckBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function EncryptVigenere(text, key: string): string;
var
  i, textI, keyI, keyLen, keyCounter: Integer;
  s: String;
begin
  s := 'јЅ¬√ƒ≈®∆«»… ЋћЌќѕ–—“”‘’÷„ЎўЏџ№Ёёя';
  Result := '';
  keyLen := Length(key);

  if keyLen = 0 then
    Exit;

  text := AnsiUpperCase(text);
  key := AnsiUpperCase(key);
  keyCounter := 0;

  for i := 1 to Length(text) do
  begin
    if Pos(text[i], s) <> 0 then
    begin
      textI := Pos(text[i], s);
      keyI := Pos(key[(keyCounter mod keyLen) + 1], s);
      Result := Result + s[(textI + keyI - 2) mod 33 + 1];
      keyCounter := keyCounter + 1;
    end
    else
      Result := Result + text[i];
  end;
end;

function DecryptRailFence(const text: string; key: Integer): string;
var
  rail: array of array of Char;
  down: Boolean;
  row, col, i, index: Integer;
begin
  if key <= 1 then
  begin
    Result := text;
    Exit;
  end;

  SetLength(rail, key, Length(text));
  down := False;
  row := 0;
  col := 0;

  for i := 0 to Length(text) - 1 do
  begin
    rail[row, col] := '*';
    Inc(col);
    if (row = 0) or (row = key - 1) then
      down := not down;

    if down then
      Inc(row)
    else
      Dec(row);
  end;

  index := 1;
  for row := 0 to key - 1 do
    for col := 0 to Length(text) - 1 do
      if (rail[row, col] = '*') and (index <= Length(text)) then
      begin
        rail[row, col] := text[index];
        Inc(index);
      end;

  Result := '';
  row := 0;
  col := 0;
  down := False;

  for i := 0 to Length(text) - 1 do
  begin
    Result := Result + rail[row, col];
    Inc(col);

    if (row = 0) or (row = key - 1) then
      down := not down;

    if down then
      Inc(row)
    else
      Dec(row);
  end;
end;

function DecryptVigenere(text, key: string): string;
var
  i, textI, keyI, keyLen, keyCounter: Integer;
  s: String;
begin
  s := 'јЅ¬√ƒ≈®∆«»… ЋћЌќѕ–—“”‘’÷„ЎўЏџ№Ёёя';
  Result := '';
  keyLen := Length(key);

  if keyLen = 0 then
    Exit;

  text := AnsiUpperCase(text);
  key := AnsiUpperCase(key);
  keyCounter := 0;

  for i := 1 to Length(text) do
  begin
    if Pos(text[i], s) <> 0 then
    begin
      textI := Pos(text[i], s);
      keyI := Pos(key[(keyCounter mod keyLen) + 1], s);
      Result := Result + s[(textI - keyI + 33) mod 33 + 1];
      keyCounter := keyCounter + 1;
    end
    else
      Result := Result + text[i];
  end;
end;

function RemoveSpaces(const text: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(text) do
    if text[i] <> ' ' then
      Result := Result + text[i];
end;

function EncryptRailFence(const text: string; key: Integer): string;
var
  rails: array of string;
  period, row, i, remainder: Integer;
  ch: Char;
begin

  if key = 1 then
  begin
    result := text;
    exit;
  end;
  SetLength(rails, key);

  period := 2 * (key - 1);

  for i := 1 to Length(text) do
  begin
    remainder := (i - 1) mod period;
    row := key - 1 - Abs(key - 1 - remainder);
    rails[row] := rails[row] + text[i];
  end;

  Result := '';
  for i := 0 to key - 1 do
    Result := Result + rails[i];
end;

function ValidateInput(text, key: string; isRailFence: Boolean): Boolean;
var
  keyInt, i: Integer;
begin
  if (text = '') or (key = '') then
  begin
    ShowMessage('ѕол€ дл€ ввода ключа и текста должны быть заполнены');
    Result := False;
    Exit;
  end;

  text := AnsiUpperCase(text);
  key := AnsiUpperCase(key);

  if isRailFence then
  begin
    if not TryStrToInt(key, keyInt) or (keyInt < 1) then
    begin
      ShowMessage(' люч должен быть положительным числом');
      Result := False;
      Exit;
    end;

    for i := 1 to Length(text) do
      if (text[i] >= 'ј') and (text[i] <= 'я') or (text[i] = '®') then
      begin
        ShowMessage('“екст должен быть на английском €зыке');
        Result := False;
        Exit;
      end;
  end
  else
  begin
    for i := 1 to Length(key) do
      if (key[i] >= 'A') and (key[i] <= 'Z') then
      begin
        ShowMessage('“екст ключа должен быть на русском €зыке');
        Result := False;
        Exit;
      end;

    for i := 1 to Length(key) do
      if not ((key[i] >= 'ј') and (key[i] <= 'я')) and (key[i] <> '®') then
      begin
        ShowMessage('“екст ключа не должен содержать спецсимволы');
        Result := False;
        Exit;
      end;

    for i := 1 to Length(text) do
      if (text[i] >= 'A') and (text[i] <= 'Z') then
      begin
        ShowMessage('“екст должен быть на русском €зыке');
        Result := False;
        Exit;
      end;
  end;

  Result := True;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  keyInt: integer;
  inputText, encryptedText: string;
begin
  If ValidateInput(edtPlain.Text, edtKey.Text, RadioButton1.Checked) then
  begin
  inputText := edtPlain.Text;
  if cbSpace.Checked then
    inputText := RemoveSpaces(inputText);

  if RadioButton1.Checked then
    encryptedText := EncryptRailFence(inputText, StrToInt(edtKey.Text))
  else
    encryptedText := EncryptVigenere(inputText, edtKey.Text);

  edtResult.Text := encryptedText;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  encryptedText, decryptedText: string;
  keyInt: integer;
begin
  If ValidateInput(edtPlain.Text, edtKey.Text, RadioButton1.Checked) then
  begin
  encryptedText := edtPlain.Text;

  if RadioButton1.Checked then
    decryptedText := DecryptRailFence(encryptedText, StrToInt(edtKey.Text))
  else
    decryptedText := DecryptVigenere(encryptedText, AnsiUpperCase(edtKey.Text));


  edtResult.Text := decryptedText;
  end;
end;


procedure TForm1.Button4Click(Sender: TObject);
var
  fileContents: TStringList;
begin
  if OpenDialog1.Execute then
  begin
    fileContents := TStringList.Create;
    try
      fileContents.LoadFromFile(OpenDialog1.FileName);
      edtPlain.Text := fileContents.Text;
    finally
      fileContents.Free;
    end;
  end;
end;



procedure TForm1.Button3Click(Sender: TObject);
begin
    edtKey.Text := '';
    edtPlain.Text := '';
    edtResult.Text := '';
end;

end.
