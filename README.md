# Codificador y Decodificador de Anto

> Hecho en 2010. Compatible con Turbo Pascal.

Este programa en **Pascal** permite codificar texto en **14 métodos clásicos y modernos** de codificación y cifrado. Ideal para aprender y experimentar con diferentes formas de representación de datos.

---

## Métodos de codificación incluidos

1. **Base64**  
2. **Hexadecimal (Hex)**  
3. **Binario**  
4. **ROT13**  
5. **URL Encoding**  
6. **ASCII Decimal**  
7. **Morse**  
8. **HTML Entities**  
9. **Base32**  
10. **Base58**  
11. **Base85**  
12. **UUEncode**  
13. **Caesar Cipher** (shift por defecto = 3)  
14. **Binary-Coded Decimal (BCD)**  

---

## Ejemplo de uso

```pascal
var
  texto: string;
begin
  texto := 'INSERTA TU MENSAJE AQUI';
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
end;
```

---

## Cómo compilar y ejecutar

Se recomienda **Free Pascal Compiler (FPC)** o **Lazarus**.

### Compilación con FPC

```bash
fpc codificador_anto_final.pas
```

### Ejecutar el programa

```bash
./codificador_anto_final
```

Deberías ver la salida con todos los métodos de codificación aplicados al texto definido en el programa.

---

## Personalización

- Cambia la variable `texto` para probar otros valores.  
- En el **Caesar Cipher**, puedes cambiar el shift pasando un valor distinto a `EncodeCaesar(texto, shift)`.  
- Las funciones están listas para reutilizar en otros programas Pascal.

---

## Licencia

Este proyecto es **libre de uso**, hecho con fines educativos y experimentales.

---

## Autor

**Antonela E. Arenas** – Codificador y Decodificador de Anto, 2010.
