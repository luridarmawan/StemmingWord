unit main;

{$mode objfpc}{$H+}

interface

uses
  fpjson,
  stemmingnazief_lib, logutil_lib,
  Classes, SysUtils, fpcgi, HTTPDefs, fastplaz_handler, html_lib, database_lib;

type
  TMainModule = class(TMyCustomWebModule)
  private
    Stemming: TStemmingNazief;
    procedure BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses json_lib, common;

constructor TMainModule.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  BeforeRequest := @BeforeRequestHandler;

  Stemming := TStemmingNazief.Create;
  Stemming.StandardWordCheck := True;
  Stemming.LoadDictionaryFromFile(Config.GetValue(
    'stemming/dictionary_file', STEMMINGNAZIEF_DICTIONARY_FILE));
  Stemming.LoadNonStandardWordFromFile(Config.GetValue(
    'stemming/nonstandardword_file', WORD_NONSTANDARD_FILE));
end;

destructor TMainModule.Destroy;
begin
  Stemming.Free;
  inherited Destroy;
end;

// Init First
procedure TMainModule.BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
begin
  Response.ContentType := 'application/json';
end;

// GET Method Handler
procedure TMainModule.Get;
begin
  //---
  Response.Content := '{}';
end;

// POST Method Handler
// CURL example:
//   curl -X POST -H "Authorization: Basic dW5hbWU6cGFzc3dvcmQ=" "yourtargeturl"
procedure TMainModule.Post;
var
  authstring: string;
  body: string;
  Text, stemmed_text: string;
  Result: TStringList;
begin
  Result := TStringList.Create;

  body := Request.Content;

  Text := _POST['text'];
  stemmed_text := Stemming.ParseSentence(Text);
  stemmed_text := StringReplace(stemmed_text, #13, '', [rfReplaceAll]);
  stemmed_text := StringReplace(stemmed_text, #10, '', [rfReplaceAll]);

  authstring := Header['Authorization'];


  Result.Add('{');
  Result.Add('"code": 0,');
  Result.Add('"response": {');
  Result.Add('"word_count": ' + i2s(Stemming.WordCount) + ',');
  Result.Add('"nonstandardword_count": ' + i2s(Stemming.NonStandardWordCount) + ',');
  Result.Add('"unknownword_count": ' + i2s(Stemming.UnknownWordCount) + ',');
  Result.Add('"text": ' + stemmed_text + ',');
  Result.Add('"time":"' + i2s(TimeUsage) + 'ms"');
  Result.Add('}');
  Result.Add('}');

  with TLogUtil.Create do
  begin
    Add(Text, 'stemming');
    Free;
  end;
  //---
  CustomHeader['stemming_token'] := 'tototo';
  Response.Content := JsonFormatter(Result.Text);
  Result.Free;
end;



end.
