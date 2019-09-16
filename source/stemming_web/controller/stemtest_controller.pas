unit stemtest_controller;

{$mode objfpc}{$H+}
{$DEFINE STEMMING_WITH_REDISx}

interface

uses
  {$IFDEF STEMMING_WITH_REDIS}
  stemmingnaziefredis_lib,
  {$ELSE}
  stemmingnazief_lib,
  {$ENDIF}
  Classes, SysUtils, fpcgi, fpjson, HTTPDefs, fastplaz_handler, database_lib;

type

  { TStemtestModule }

  TStemtestModule = class(TMyCustomWebModule)
  private
    {$IFDEF STEMMING_WITH_REDIS}
    Stemming: TStemmingNaziefRedis;
    {$ELSE}
    Stemming: TStemmingNazief;
    {$ENDIF}
    function assertWord(TestWord, ComparisonWord: string): boolean;
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses common, json_lib;

function TStemtestModule.assertWord(TestWord, ComparisonWord: string): boolean;
var
  stemmed_word: string;
begin
  Result := False;
  stemmed_word := Stemming.ParseWord(TestWord);
  if stemmed_word <> ComparisonWord then
  begin
    echo('<div class="failed">');
    //echo(' <span style="color:red">--> failed (' + ComparisonWord + ')</span>');
  end
  else
  begin
    echo('<div>');
  end;
  echo(TestWord + ' >> ' + stemmed_word);
  if stemmed_word <> ComparisonWord then
  begin
    echo(' <span style="color:red">--> failed (' + ComparisonWord + ')</span>');
  end;
  echo('</div>');

end;

constructor TStemtestModule.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  {$IFDEF STEMMING_WITH_REDIS}
  Stemming := TStemmingNaziefRedis.Create;
  Stemming.LoadDictionaryFromRedis();
  {$ELSE}
  Stemming := TStemmingNazief.Create;
  Stemming.LoadDictionaryFromFile( string(Config.GetValue( 'stemming/dictionary_file','dictionary.csv')));
  {$ENDIF}
end;

destructor TStemtestModule.Destroy;
begin
  Stemming.Free;
  inherited Destroy;
end;

// GET Method Handler
procedure TStemtestModule.Get;
var
  wordtest: TStringList;
  i: integer;
begin

  if not FileExists( 'wordtest.txt') then
  begin
    die( 'file "wordtest.txt" not exists.');
  end;
  wordtest := TStringList.Create;
  wordtest.LoadFromFile('wordtest.txt');

  echo('<html>');
  echo('<style>');
  echo('div {padding:1px 10px;}');
  echo('#container { font-family: "Lucida Console", Courier, monospace;}');
  echo('.failed { color: red; background:yellow;}');
  echo('</style>');
  echo('<body><div id="container">');

  echo('<h3>Stemming Test</h3>');
  echo('<pre>');
  for i := 0 to wordtest.Count - 1 do
  begin
    if wordtest.Names[i] = '' then
      echo(#13#13 + wordtest.ValueFromIndex[i])
    else
      assertWord(wordtest.Names[i], wordtest.ValueFromIndex[i]);

  end;
  echo('</pre>');
  echo('</div>');
  echo('</body>');
  echo('</html>');

  //Response.Content := wordtest.Text;
  wordtest.Free;
end;

// POST Method Handler
procedure TStemtestModule.Post;
begin
  Response.Content := '';
end;




initialization
  // -> http://yourdomainname/stemtest
  // The following line should be moved to a file "routes.pas"
  Route.Add('test', TStemtestModule);

end.

