program CodificadorYDecodificadorDeAnto;

{ Codificador y Decodificador de Anto
  Hecho en 2010
  Compatible con Turbo Pascal }

uses
  SysUtils, Classes;

const
  Base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  Base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  Base58Chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  MorseCode: array[0..36] of string = (
    '.-', '-...', '-.-.', '-..', '.', '..-.', '--.', '....', '..', '.---', 
    '-.-', '.-..', '--', '-.', '---', '.--.', '--.-', '.-.', '...', '-', 
    '..-', '...-', '.--', '-..-', '-.--', '--..', '-----', '.----', '..---', 
    '...--', '....-', '.....', '-....', '--...', '---..', '----.'
  );

// ---------------- Base64 ----------------
function EncodeBase64(const Input: string): string;
var
  bytes: TBytes;
  i, b, len: Integer;
begin
  Result := '';
  bytes := TEncoding.UTF8.GetBytes(Input);
  len := Length(bytes);
  i := 0;
  while i < len do
  begin
    b := bytes[i]; Inc(i);
    b := b shl 8;
    if i < len then b := b + bytes[i] else b := b + 0;
    Inc(i);
    b := b shl 8;
    if i < len then b := b + bytes[i] else b := b + 0;
    Inc(i);

    Result := Result +
      Base64Chars[(b shr 18) and $3F + 1] +
      Base64Chars[(b shr 12) and $3F + 1] +
      Base64Chars[(b shr 6) and $3F + 1] +
      Base64Chars[b and $3F + 1];
  end;

  case len mod 3 of
    1: Result[Length(Result)-2] := '=';
    2: Result[Length(Result)] := '=';
  end;
end;

// ---------------- HEX ----------------
function EncodeHex(const Input: string): string;
var b: Byte;
begin
  Result := '';
  for b in TEncoding.UTF8.GetBytes(Input) do
    Result := Result + IntToHex(b, 2);
end;

// ---------------- BINARIO ----------------
function EncodeBin(const Input: string): string;
var b: Byte;
begin
  Result := '';
  for b in TEncoding.UTF8.GetBytes(Input) do
    Result := Result + IntToBin(b, 8) + ' ';
  Result := Trim(Result);
end;

// ---------------- ROT13 ----------------
function EncodeROT13(const Input: string): string;
var c: Char;
begin
  Result := '';
  for c in Input do
  begin
    if c in ['A'..'Z'] then
      Result := Result + Chr(Ord('A') + (Ord(c)-Ord('A')+13) mod 26)
    else if c in ['a'..'z'] then
      Result := Result + Chr(Ord('a') + (Ord(c)-Ord('a')+13) mod 26)
    else
      Result := Result + c;
  end;
end;

// ---------------- URL Encoding ----------------
function EncodeURL(const Input: string): string;
var i: Integer;
begin
  Result := '';
  for i := 1 to Length(Input) do
    case Input[i] of
      'A'..'Z','a'..'z','0'..'9','-','_','.','~': Result := Result + Input[i];
    else
      Result := Result + '%' + IntToHex(Ord(Input[i]),2);
    end;
end;

// ---------------- ASCII Decimal ----------------
function EncodeASCII(const Input: string): string;
var b: Byte;
begin
  Result := '';
  for b in TEncoding.UTF8.GetBytes(Input) do
    Result := Result + IntToStr(b) + ' ';
  Result := Trim(Result);
end;

// ---------------- Morse ----------------
function EncodeMorse(const Input: string): string;
var
  c: Char;
  i: Integer;
begin
  Result := '';
  for c in UpperCase(Input) do
  begin
    if c in ['A'..'Z'] then i := Ord(c)-Ord('A')
    else if c in ['0'..'9'] then i := 26 + Ord(c)-Ord('0')
    else continue;
    Result := Result + MorseCode[i] + ' ';
  end;
  Result := Trim(Result);
end;

// ---------------- HTML Entities ----------------
function EncodeHTML(const Input: string): string;
var i: Integer;
begin
  Result := '';
  for i := 1 to Length(Input) do
    Result := Result + '&#' + IntToStr(Ord(Input[i])) + ';';
end;

// ---------------- Placeholders ----------------
function EncodeBase32(const Input: string): string;
begin
  Result := '[Base32 placeholder]';
end;

function EncodeBase58(const Input: string): string;
begin
  Result := '[Base58 placeholder]';
end;

function EncodeBase85(const Input: string): string;
begin
  Result := '[Base85 placeholder]';
end;

function EncodeUU(const Input: string): string;
begin
  Result := '[UUEncode placeholder]';
end;

// ---------------- Programa principal ----------------
var
  texto: string;
begin
  texto := 'Hola Mundo!';
  Writeln('Codificador y Decodificador de Anto - 2010');
  Writeln('Texto original: ', texto);
  Writeln('Base64: ', EncodeBase64(texto));
  Writeln('Hex: ', EncodeHex(texto));
  Writeln('Binario: ', EncodeBin(texto));
  Writeln('ROT13: ', EncodeROT13(texto));
  Writeln('URL Encoding: ', EncodeURL(texto));
  Writeln('ASCII Decimal: ', EncodeASCII(texto));
  Writeln('Morse: ', EncodeMorse(texto));
  Writeln('HTML Entities: ', EncodeHTML(texto));
  Writeln('Base32: ', EncodeBase32(texto));
  Writeln('Base58: ', EncodeBase58(texto));
  Writeln('Base85: ', EncodeBase85(texto));
  Writeln('UUEncode: ', EncodeUU(texto));
end.
