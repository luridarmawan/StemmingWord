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

  Stemming:= TStemmingNazief.Create;
  Stemming.LoadDictionaryFromFile( Config.GetValue( 'stemming/dictionary_file','dictionary.csv'));
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
  text, stemmed_text: string;
  result : TStringList;
begin
  result := TStringList.Create;

  body := Request.Content;

  text := _POST['text'];
  stemmed_text:= Stemming.ParseSentence( text);
  stemmed_text:= StringReplace(stemmed_text,#13,'',[rfReplaceAll]);
  stemmed_text:= StringReplace(stemmed_text,#10,'',[rfReplaceAll]);

  authstring := Header['Authorization'];


  result.Add('{');
  result.Add('"code": 0,');
  result.Add('"response": {');
  result.Add('"text": '+stemmed_text+',');
  result.Add('"time":"'+i2s(TimeUsage)+'ms"');
  result.Add('}');
  result.Add('}');

  with TLogUtil.Create do
  begin
    Add( text, 'stemming');
    Free;
  end;
  //---
  CustomHeader['stemming_token'] := 'tototo';
  Response.Content:= JsonFormatter( result.Text);
  result.Free;
end;



end.

