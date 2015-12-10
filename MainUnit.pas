unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RegExpr;

type
  TValue = Record
     local : boolean;
     nameValue : string;
     count : integer;
  end;
  TGlobal = class(TForm)
    MemoCode: TMemo;
    ButtonLoadFromFileCode: TButton;
    OpenDialogCode: TOpenDialog;
    ButtonMake: TButton;
    MemoResult: TMemo;
    procedure ButtonLoadFromFileCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonMakeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
   types = '(long int|float|long float|double|bool|short int|unsigned int|char|int|void)';
var
  Global: TGlobal;
  RegExpro : TRegExpr;
  global_values : array of TValue;

implementation

{$R *.dfm}



procedure DeleteElement( Var sourceCode:string);
begin
  regExpro.Expression:='"(/\*)|(\*/)"';
  sourceCode:=regExpro.Replace(sourceCode,'"___"');
end;

procedure DeleteComments( var sourceCode: string) ;
begin
  regExpro.ModifierM:= True;
  regExpro.Expression:='//.*?$';
  sourceCode:= regExpro.Replace(sourceCode,'');
  regExpro.ModifierS:= True;
  regExpro.Expression:='/\*.*?\*/';
  sourceCode:= regExpro.Replace(sourceCode,'');
  regExpro.ModifierS:= False;
end;

procedure DeleteString(var sourceCode: string) ;
begin
  regExpro.Expression:='''.?''';
  sourceCode:= regExpro.Replace(sourceCode,'''''');
  regExpro.Expression:='".*?"';
  sourceCode:= regExpro.Replace(sourceCode,'""');
end;

procedure TGlobal.ButtonLoadFromFileCodeClick(Sender: TObject);
begin
   if OpenDialogCode.Execute then
      MemoCode.Lines.LoadFromFile(OpenDialogCode.FileName)
   else
      showmessage('Error');
end;

procedure SearchValue(code : string; NUMBER_VALUES : integer);
var
   i : integer;
begin
   for i := 0 to NUMBER_VALUES - 1 do
   begin
      RegExpro.Expression := '(\W|\[)' + global_values[i].nameValue + '(\W|\])';
      if ( RegExpro.Exec(code) ) then
         if global_values[i].local = false then
            inc(global_values[i].count);
   end;
end;

procedure PrintData(var Aup : integer; module : string; NUMBER_VALUES : integer);
var
   i : integer;
begin
   with Global do
   begin
      MemoResult.Lines.Add(module);
      if NUMBER_VALUES <> 0 then
         for i := 0 to NUMBER_VALUES - 1 do
         begin
            if global_values[i].count > 0 then
            begin
               inc(Aup);
               MemoResult.Lines.Add('   ' + global_values[i].nameValue + '  using');
            end
            else
               MemoResult.Lines.Add('   ' + global_values[i].nameValue + '  not using');
            global_values[i].local := false;
            global_values[i].count := 0;
         end;
   end;
end;

procedure TGlobal.FormCreate(Sender: TObject);
begin
   RegExpro := TRegExpr.create;
end;

procedure TGlobal.ButtonMakeClick(Sender: TObject);
var
   counter : byte;
   i, Pup, Aup : integer;
   NUMBER_VALUES, j : byte;
   module, code : string;
begin
   MemoResult.Lines.Clear;
   Pup := 0;
   Aup := 0;
   counter := 0;
   module := '';
   number_values := 0;
   code := MemoCode.Lines.text;
   DeleteElement(code);
   deleteComments(code);
   DeleteComments(code);
   MemoCode.Lines.Text := code;
   // пройтись циклом и удалить все строки
   // удалить все многострочные комментарии
   // удалить все однострочные комментарии
   i := 0;
   if length(MemoCode.Text) > 0 then
   begin
   repeat
      if length(MemoCode.Lines[i]) <> 0 then
      begin
      RegExpro.Expression := ' *' + types + ' +([a-zA-Z]+)\(.*\)';
      if RegExpro.Exec(MemoCode.Lines[i]) then
      begin
         Pup := Pup + NUMBER_VALUES;
         module := Trim(RegExpro.Match[2]);
         inc(i);
      end;
      RegExpro.Expression := '{';
      if RegExpro.Exec(MemoCode.Lines[i]) then
      begin
         inc(counter);
      end;
      RegExpro.Expression := '}';
      if RegExpro.Exec(MemoCode.Lines[i]) then
      begin
         dec(counter);
         if counter = 0 then
         begin
            PrintData(Aup, module, NUMBER_VALUES);
            module := '';
         end;
      end;

         RegExpro.Expression := types + ' +\W*([a-zA-Z_]+)\W';
         if RegExpro.Exec(MemoCode.Lines[i]) then
         begin
            RegExpro.Expression := '(\W)* *([a-zA-Z]+)\W';
            repeat
               if module <> '' then
               begin
                  if NUMBER_VALUES <> 0 then
                     for j := 0 to NUMBER_VALUES - 1 do
                        if Trim(RegExpro.Match[2]) = global_values[j].nameValue then
                            global_values[j].local := true;
               end
               else
               begin
                  inc(NUMBER_VALUES);
                  setLength(global_values, NUMBER_VALUES);
                  global_values[NUMBER_VALUES - 1].nameValue := Trim(RegExpro.Match[2]);
                  global_values[NUMBER_VALUES - 1].local := false;
                  global_values[NUMBER_VALUES - 1].count := -1;
               end;
            until not RegExpro.ExecNext();


      end;
      SearchValue(MemoCode.Lines[i],NUMBER_VALUES);
      end;
      inc(i);
   until (i = MemoCode.Lines.Count);
   if Pup <> 0 then
      MemoResult.Lines.Add('Aup = ' + inttostr(Aup) + '  Pup = ' + inttostr(Pup) + '  Rup = ' + FloatToStr(Aup / Pup))
   else
      MemoResult.Lines.Add('Нет глобальных переменных');
   end;
   MemoResult.Lines.Add(IntToStr(NUMBER_VALUES));

end;

end.
