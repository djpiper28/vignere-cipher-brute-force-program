program bruteforcer;

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

var tempa,tempb,counter: integer;
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
        if oldkey[length(oldkey)-counter-1] <>'Z' then break;

      end else begin
        oldkey[length(oldkey)-counter]:=chr(integer(ord(oldkey[length(oldkey)-counter]))+1);
        if(oldkey[length(oldkey)-counter]<>'Z') then break;
      end;
      counter:=counter+1;
    until counter> length(oldkey);
    result:=oldkey;

    end;

  //returns a new key that has increased by one
end;
var letterCounter,maxNum,maxChrNum:integer;
  arrayThing:freqAnalysisArray;
  i:integer;
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
   while(letterCounter<=length( Text )) do begin
     if(arrayThing[letterCounter]>=maxNum) then begin
       maxChrNum:=Integer(ord(letterCounter));
       maxnum:=arrayThing[letterCounter];
     end;
     letterCounter:=letterCounter+1;
   end;
   result:=chr(maxChrNum+65);
  //returns the most common char (e in the english langauge)
end;
var keyCounter,textCounter:integer;
  plainText:string;
  tempTXT:integer;
function decrypt(CipherText:string;key:string):string; begin
  plainText:='';
  textCounter:=0;
  keyCounter:=0;
  while(textCounter<=length(CipherText)) do begin
    //DECRYPT CHAR AND ADD TO PLAINTEXT
    while(key[keyCounter]='-') do begin
      keyCounter:=keyCounter+1;
    end;
    tempTXT:=integer(ord(CipherText[textCounter]))+(integer(ord(key[keyCounter]))-64 );
    while(tempTXT>90) do begin
      tempTXT:=tempTXT-25;//minus one alphabet at a time
    end;
    while(tempTXT<65) do begin
      tempTXT:=tempTXT+25;//plus one alphabet at a time
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

procedure VignereCipherBruteForcer.DoRun;
var
  _cipherText,_plainText,_key,continueTMP: String;
  continue: Boolean;
begin
  { add your program here }
  writeln('-- What is the cipher text?');
  readln(_cipherText);
  _cipherText:=UpperCase(_cipherText);
  _key:='---------A';
  continue:=True;
  repeat
    _plainText:=decrypt(_cipherText,_key);
    writeln('KEY:     ',_key);
    writeln('PLAINTXT:',_plainText);
    if(frequencyAnalysis(_plainText)='E') then begin
      writeln('-- Potential Solution Found:');
      writeln('-- Do you wish to continue? (Y OR N)');
      readln(continueTMP);
      continueTMP:= UpperCase(continueTMP);
      if(continueTMP='Y') then begin
        continue:=True;
      end else begin
        continue:=False;
        writeln('Hit enter twice to exit');
        readln();
      end;
    end;
    _key:=newKey(_key);
  until continue=False;
  // stop program loop
  readln();
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

