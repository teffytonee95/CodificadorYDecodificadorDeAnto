program CodificadorYDecodificadorDeAnto;

{ Codificador y Decodificador de Anto - 2010
  Compatible con Turbo Pascal }

uses
  SysUtils;

const
  Base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  Base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  Base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  { 26 letras + 10 dígitos = 36 elementos (0..35) }
  MorseCode: array[0..35] of string = (
    '.-', '-...', '-.-.', '-..', '.', '..-.', '--.', '....', '..', '.---',
    '-.-', '.-..', '--', '-.', '---', '.--.', '--.-', '.-.', '...', '-',
    '..-', '...-', '.--', '-..-', '-.--', '--..',
    '-----', '.----', '..---', '...--', '....-', '.....', '-....', '--...', '---..', '----.'
  );

{ ---------------- Convertir número a binario ---------------- }
function ToBin(Value: Byte): string;
var
  i: Integer;
  S: string;
begin
  S := '';
  for i := 7 downto 0 do
    if (Value and (1 shl i)) <> 0 then S := S + '1'
    else S := S + '0';
  ToBin := S;
end;

{ ---------------- Base64 ---------------- }
function EncodeBase64(Input: string): string;
var
  Output: string;
  i: Integer;
  c1, c2, c3, b: LongInt;
begin
  Output := '';
  i := 1;
  while i <= Length(Input) do
  begin
    c1 := Ord(Input[i]); Inc(i);
    if i <= Length(Input) then c2 := Ord(Input[i]) else c2 := 0; Inc(i);
    if i <= Length(Input) then c3 := Ord(Input[i]) else c3 := 0; Inc(i);

    b := (c1 shl 16) or (c2 shl 8) or c3;

    Output := Output +
      Base64Chars[(b shr 18) and $3F + 1] +
      Base64Chars[(b shr 12) and $3F + 1] +
      Base64Chars[(b shr 6) and $3F + 1] +
      Base64Chars[b and $3F + 1];
  end;

  if Length(Input) mod 3 = 1 then Output[Length(Output)-2] := '=';
  if Length(Input) mod 3 = 2 then Output[Length(Output)] := '=';
  EncodeBase64 := Output;
end;

{ ---------------- HEX ---------------- }
function EncodeHex(Input: string): string;
var
  Output: string;
  i: Integer;
begin
  Output := '';
  for i := 1 to Length(Input) do
    Output := Output + IntToHex(Ord(Input[i]), 2);
  EncodeHex := Output;
end;

{ ---------------- BINARIO ---------------- }
function EncodeBin(Input: string): string;
var
  Output: string;
  i: Integer;
begin
  Output := '';
  for i := 1 to Length(Input) do
    Output := Output + ToBin(Ord(Input[i])) + ' ';
  EncodeBin := Output;
end;

{ ---------------- ROT13 ---------------- }
function EncodeROT13(Input: string): string;
var
  Output: string;
  i: Integer;
  c: Char;
begin
  Output := '';
  for i := 1 to Length(Input) do
  begin
    c := Input[i];
    if c in ['A'..'Z'] then
      Output := Output + Chr(Ord('A') + (Ord(c)-Ord('A')+13) mod 26)
    else if c in ['a'..'z'] then
      Output := Output + Chr(Ord('a') + (Ord(c)-Ord('a')+13) mod 26)
    else
      Output := Output + c;
  end;
  EncodeROT13 := Output;
end;

{ ---------------- ASCII Decimal ---------------- }
function EncodeASCII(Input: string): string;
var
  Output: string;
  i: Integer;
begin
  Output := '';
  for i := 1 to Length(Input) do
    Output := Output + IntToStr(Ord(Input[i])) + ' ';
  EncodeASCII := Output;
end;

{ ---------------- Morse ---------------- }
function EncodeMorse(Input: string): string;
var
  Output: string;
  i, idx: Integer;
  c: Char;
begin
  Output := '';
  Input := UpperCase(Input);
  for i := 1 to Length(Input) do
  begin
    c := Input[i];
    if c in ['A'..'Z'] then idx := Ord(c) - Ord('A')
    else if c in ['0'..'9'] then idx := 26 + Ord(c) - Ord('0')
    else continue;
    Output := Output + MorseCode[idx] + ' ';
  end;
  EncodeMorse := Output;
end;

{ ---------------- Caesar Cipher ---------------- }
function EncodeCaesar(Input: string; Shift: Integer): string;
var
  Output: string;
  i: Integer;
  c: Char;
begin
  Output := '';
  for i := 1 to Length(Input) do
  begin
    c := Input[i];
    if c in ['A'..'Z'] then
      Output := Output + Chr(Ord('A') + (Ord(c)-Ord('A')+Shift) mod 26)
    else if c in ['a'..'z'] then
      Output := Output + Chr(Ord('a') + (Ord(c)-Ord('a')+Shift) mod 26)
    else
      Output := Output + c;
  end;
  EncodeCaesar := Output;
end;

{ ---------------- HTML Entities ---------------- }
function EncodeHTML(Input: string): string;
var
  Output: string;
  i: Integer;
begin
  Output := '';
  for i := 1 to Length(Input) do
    Output := Output + '&#' + IntToStr(Ord(Input[i])) + ';';
  EncodeHTML := Output;
end;

{ ---------------- Programa principal ---------------- }
var
  texto: string;
begin
  texto := 'Hola Mundo!';
  Writeln('Codificador y Decodificador de Anto - 2010 (FPC clásico)');
  Writeln('Texto original: ', texto);
  Writeln('Base64: ', EncodeBase64(texto));
  Writeln('Hex: ', EncodeHex(texto));
  Writeln('Binario: ', EncodeBin(texto));
  Writeln('ROT13: ', EncodeROT13(texto));
  Writeln('ASCII Decimal: ', EncodeASCII(texto));
  Writeln('Morse: ', EncodeMorse(texto));
  Writeln('Caesar Cipher: ', EncodeCaesar(texto, 3));
  Writeln('HTML Entities: ', EncodeHTML(texto));
end.


