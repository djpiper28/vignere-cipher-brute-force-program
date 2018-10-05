program bruteforcerhc;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { VignereCipherBruteForcer }
  freqAnalysisArray = array[1..26] of integer;
  VignereCipherBruteForcer = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
  end;
var
  _cipherText,_plainText,_key,continueTMP,tmp: String;
  continue: Boolean;
  counter: integer;
  letterCounter,maxNum,maxChrNum:integer;
  arrayThing:freqAnalysisArray;
  i:integer;
  keyCounter,textCounter:integer;
  plainText:string;
  tempTXT:integer;
  inputText, outputText, keyInput:string;
  positives:integer;
  input:string;
{ VignereCipherBruteForcer }
function newKey(oldkey : string):string; begin
    counter:=0;
    if(oldkey[length(oldkey)-1]='-') then begin
      if( oldkey[length(oldkey)]='Z') then begin
        oldkey[length(oldkey)]:='A';
        oldkey[length(oldkey)-1]:='A';
        result:= '-'+oldkey;
      end else begin
        oldkey[length(oldkey)]:=chr(integer(ord(oldkey[length(oldkey)-counter]))+1);
        result:= oldkey;
      end;
    end else begin

    repeat
      if(oldkey[length(oldkey)-counter] ='-')then begin
        break;
      end;
      if(integer(ord(oldkey[length(oldkey)-counter]))>=90) then begin
        if(oldkey[length(oldkey)-counter-1]='-') then begin
          oldkey[length(oldkey)-counter-1]:='A';
          oldkey:='-'+oldkey;
        end else oldkey[length(oldkey)-counter-1]:=chr(integer(ord(oldkey[length(oldkey)-counter-1]))+1);
        oldkey[length(oldkey)-counter]:='A';
        if ( (oldkey[length(oldkey)-counter-1] <>'Z') and (integer(ord(oldkey[length(oldkey)-counter-1]))<90) ) then break;

      end else begin
        oldkey[length(oldkey)-counter]:=chr(integer(ord(oldkey[length(oldkey)-counter]))+1);
        if ( (oldkey[length(oldkey)-counter-1] <>'Z') and (integer(ord(oldkey[length(oldkey)-counter-1]))<90) ) then break;
      end;
      counter:=counter+1;
    until counter> length(oldkey);
    result:=oldkey;

    end;

  //returns a new key that has increased by one
end;

function frequencyAnalysis(Text:string):char; begin
  i:=1;
  while(i<=26) do begin
    arrayThing[i]:=0;
    i:=i+1;
  end;
  letterCounter:=1;
  Text:=UpperCase(Text);
  while(letterCounter<=length( Text )) do begin
    arrayThing[Integer(ord(Text[letterCounter]))-64]:= arrayThing[Integer(ord(Text[letterCounter]))-64]+1;
    letterCounter:=letterCounter+1;
  end;
  maxNum:=0;
  letterCounter:=1;
   while(letterCounter<26) do begin
     if(arrayThing[letterCounter]>=maxNum) then begin
       maxChrNum:=Integer(ord(letterCounter+64));
       maxnum:=arrayThing[letterCounter];
     end;
     letterCounter:=letterCounter+1;
   end;
   result:=chr(maxChrNum);
  //returns the most common char (e in the english langauge)
end;

function decrypt(CipherText:string;key:string):string; begin
  plainText:='';
  textCounter:=1;
  keyCounter:=1;
  CipherText:=UpperCase(CipherText);
  while(textCounter<=length(CipherText)) do begin
    //DECRYPT CHAR AND ADD TO PLAINTEXT
    while(key[keyCounter]='-') do begin
      keyCounter:=keyCounter+1;
    end;
    tempTXT:=integer(ord(CipherText[textCounter]))-(integer(ord(key[keyCounter]))-65 );
    while(tempTXT>90) do begin
      tempTXT:=tempTXT-26;//minus one alphabet at a time
    end;
    while(tempTXT<65) do begin
      tempTXT:=tempTXT+26;//plus one alphabet at a time
    end;

    plainText:=plainText+chr(tempTXT);

    if(keyCounter>=length(key)) then begin
      keyCounter:=1;
    end else begin
      keyCounter:=keyCounter+1;
    end;

    textCounter:=textCounter+1;
  end;
  //returns plain text
  result:=plainText;
end;
function encrypt(CipherText:string;key:string):string; begin
  plainText:='';
  textCounter:=1;
  keyCounter:=1;
  while(textCounter<=length(CipherText)) do begin
    //DECRYPT CHAR AND ADD TO PLAINTEXT
    while(key[keyCounter]='-') do begin
      keyCounter:=keyCounter+1;
    end;
    tempTXT:=integer(ord(CipherText[textCounter]))+(integer(ord(key[keyCounter]))-65 );
    while(tempTXT>90) do begin
      tempTXT:=tempTXT-26;//minus one alphabet at a time
    end;
    while(tempTXT<65) do begin
      tempTXT:=tempTXT+26;//plus one alphabet at a time
    end;

    plainText:=plainText+chr(tempTXT);

    if(keyCounter>=length(key)) then begin
      keyCounter:=1;
    end else begin
      keyCounter:=keyCounter+1;
    end;

    textCounter:=textCounter+1;
  end;
  //returns plain text
  result:=plainText;
end;

function letterPairAnalysis (plaintext:string):Boolean; begin
  //'TH HE AN RE ER IN ON AT ND ST ES EN OF TE ED OR TI HI AS TO'
  // 20 PAIRS
  positives:=0;
  if plaintext.Contains('TH') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('HE') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('AN') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('RE') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ER') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('IN') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ON') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('AT') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ND') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ST') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ES') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('EN') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('OF') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('TE') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ED') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('OR') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('TI') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('HI') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('AS') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('TO') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ENT') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ION') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('TIO') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('FOR') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('ARE') then begin
    positives:=positives+1;
  end;
  if plaintext.Contains('THE') and plaintext.Contains('AND') then begin
    positives:=positives+1;
    if (positives>20) then begin
      result:=True;
    end;
  end else begin
    result:=False;
  end;
end;

procedure EncryptInterface(); begin
  writeln('-- What is the plain text?');
  readln(inputText);
  if( inputText='LONG')then begin
    writeln('-- keep inserting text until none is left, at that point put in blank input');
    inputText:='';
    repeat
      readln(tmp);
      inputText:=inputText+tmp;
    until tmp='';
  end;
  writeln('-- What is the key (alphabet only)');
  readln(keyInput);
  writeln('The Cipher Text is:');
  writeln(encrypt(inputText,keyInput));
  writeln('Hit enter to close');
  readln();
end;
procedure DecryptInterface(); begin
  writeln('-- What is the cipher text?');
  readln(inputText);
  if( inputText='LONG')then begin
    writeln('-- keep inserting text until none is left, at that point put in blank input');
    inputText:='';
    repeat
      readln(tmp);
      inputText:=inputText+tmp;
    until tmp='';
  end;
  writeln('-- What is the key (alphabet only)');
  readln(keyInput);
  writeln('The Plain Text is:');
  writeln(decrypt(inputText,keyInput));
  writeln('Hit enter to close');
  readln();
end;
procedure BruteForce(); begin
  { add your program here }
  writeln('-- Works best on longer texts (the exe has a char length so type LONG now to remove this limit)');
  writeln('-- What is the cipher text?');
  readln(_cipherText);
  if( _cipherText='LONG')then begin
    writeln('-- keep inserting text until none is left, at that point put in blank input');
    _cipherText:='';
    repeat
      readln(tmp);
      _cipherText:=_cipherText+tmp;
    until tmp='';
  end;
  _cipherText:=UpperCase(_cipherText);
  _key:='---------A';
  continue:=True;
  repeat
    _plainText:=decrypt(_cipherText,_key);
    writeln('KEY:     ',_key);
    if(frequencyAnalysis(_plainText)='E') and (letterPairAnalysis(_plainText)) then begin
      writeln('PLAINTXT:',_plainText);
      writeln('-- Potential Solution Found:');
      writeln('-- Do you wish to continue? (Y OR N)');
      readln(continueTMP);
      continueTMP:= UpperCase(continueTMP);
      if(continueTMP='Y') or(continueTMP='') then begin
        continue:=True;
      end else begin
        continue:=False;
        writeln('Hit enter twice to exit');
        readln();
        writeln('Hit enter once more to exit');
        readln();
      end;
    end;
    _key:=newKey(_key);
  until continue=False;
  // stop program loop
end;
procedure VignereCipherBruteForcer.DoRun;

begin
  writeln('Please select an option');
  writeln('B      | BRUTE FORCE ATTACK');
  writeln('E      | ENCRYPT PLAIN TEXT');
  writeln('D      | DECRYPT (KNOWN KEY)');
  readln(input);
  input:=UpperCase(input);
  case input of
    'B' : BruteForce();
    'E' : EncryptInterface();
    'D' : DecryptInterface();
  end; 
  Terminate;
end;

var
  Application: VignereCipherBruteForcer;
begin
  Application:=VignereCipherBruteForcer.Create(nil);
  Application.Title:='Vignere_Cipher_Brute_Forcer';
  Application.Run;
  Application.Free;
end.

