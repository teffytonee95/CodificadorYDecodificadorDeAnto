program CodificadorYDecodificadorDeAnto;

{ Codificador y Decodificador de Anto - 2010
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
    if c in ['A'..'Z'] then
      Result := Result + Chr(Ord('A') + (Ord(c)-Ord('A')+13) mod 26)
    else if c in ['a'..'z'] then
      Result := Result + Chr(Ord('a') + (Ord(c)-Ord('a')+13) mod 26)
    else
      Result := Result + c;
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

// ---------------- Base32 ----------------
function EncodeBase32(const Input: string): string;
var
  bytes: TBytes;
  buffer, i, index, bits: Integer;
begin
  Result := '';
  bytes := TEncoding.UTF8.GetBytes(Input);
  buffer := 0;
  bits := 0;
  for i := 0 to High(bytes) do
  begin
    buffer := (buffer shl 8) or bytes[i];
    bits := bits + 8;
    while bits >= 5 do
    begin
      index := (buffer shr (bits-5)) and $1F;
      Result := Result + Base32Chars[index+1];
      bits := bits - 5;
    end;
  end;
  if bits > 0 then
    Result := Result + Base32Chars[(buffer shl (5-bits)) and $1F + 1];
end;

// ---------------- Base58 ----------------
function EncodeBase58(const Input: string): string;
var
  bytes: TBytes;
  i, j, carry: Integer;
  digits: array of Integer;
begin
  bytes := TEncoding.UTF8.GetBytes(Input);
  SetLength(digits, Length(bytes)*2);
  for i := 0 to High(bytes) do
  begin
    carry := bytes[i];
    j := 0;
    while (carry <> 0) or (j < Length(digits)) do
    begin
      if j < Length(digits) then carry := carry + digits[j] shl 8
      else carry := carry shl 8;
      digits[j] := carry mod 58;
      carry := carry div 58;
      Inc(j);
    end;
  end;
  Result := '';
  for i := High(digits) downto 0 do
    if (Result <> '') or (digits[i] <> 0) then
      Result := Result + Base58Chars[digits[i]+1];
end;

// ---------------- Base85 ----------------
function EncodeBase85(const Input: string): string;
var
  bytes: TBytes;
  i, value: LongInt;
  block: array[0..3] of Byte;
begin
  Result := '';
  bytes := TEncoding.UTF8.GetBytes(Input);
  i := 0;
  while i < Length(bytes) do
  begin
    FillChar(block, SizeOf(block), 0);
    for var j := 0 to 3 do
      if i+j < Length(bytes) then block[j] := bytes[i+j];
    value := (block[0] shl 24) or (block[1] shl 16) or (block[2] shl 8) or block[3];
    for var k := 4 downto 0 do
    begin
      Result := Result + Chr((value mod 85)+33);
      value := value div 85;
    end;
    i := i + 4;
  end;
end;

// ---------------- UUEncode ----------------
function EncodeUU(const Input: string): string;
var
  bytes: TBytes;
  i, j: Integer;
  line: string;
begin
  Result := '';
  bytes := TEncoding.UTF8.GetBytes(Input);
  i := 0;
  while i < Length(bytes) do
  begin
    line := Chr(Min(Length(bytes)-i, 45)+32);
    for j := 0 to Min(44, Length(bytes)-i-1) div 3 do
    begin
      line := line +
        Chr(((bytes[i+j*3] shr 2) and $3F)+32) +
        Chr((((bytes[i+j*3] shl 4) or ((bytes[i+j*3+1] shr 4) and $F)) and $3F)+32) +
        Chr((((bytes[i+j*3+1] shl 2) or ((bytes[i+j*3+2] shr 6) and $3)) and $3F)+32) +
        Chr((bytes[i+j*3+2] and $3F)+32);
    end;
    Result := Result + line + #10;
    i := i + 45;
  end;
end;

// ---------------- Caesar Cipher ----------------
function EncodeCaesar(const Input: string; Shift: Integer = 3): string;
var c: Char;
begin
  Result := '';
  for c in Input do
    if c in ['A'..'Z'] then
      Result := Result + Chr(Ord('A') + (Ord(c)-Ord('A')+Shift) mod 26)
    else if c in ['a'..'z'] then
      Result := Result + Chr(Ord('a') + (Ord(c)-Ord('a')+Shift) mod 26)
    else
      Result := Result + c;
end;

// ---------------- Binary-Coded Decimal ----------------
function EncodeBCD(const Input: string): string;
var
  b: Byte;
begin
  Result := '';
  for b in TEncoding.UTF8.GetBytes(Input) do
    Result := Result + IntToHex((b div 10) shl 4 or (b mod 10),2) + ' ';
  Result := Trim(Result);
end;

// ---------------- Programa principal ----------------
var
  texto: string;
begin
  texto := 'INSERTA TU TEXTO AQUI';
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
  Writeln('Caesar Cipher: ', EncodeCaesar(texto));
  Writeln('BCD: ', EncodeBCD(texto));
end.

