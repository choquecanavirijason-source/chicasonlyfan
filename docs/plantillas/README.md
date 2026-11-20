# Plantillas de presentación — Coder Blend

Para presentar una app móvil a un cliente en A4, con el membrete de la empresa.
Lo que hay acá se usó para el caso de estudio de Hot Spot y sirve igual para
cualquier otro proyecto: se cambian siete variables de color, se reemplazan las
capturas y listo.

## Archivos

| Archivo | Qué es |
|---|---|
| `caso-de-estudio.html` | La plantilla. Siete bloques de página listos para copiar, reordenar o borrar. |
| `estilos.css` | Todo el diseño. Arriba de todo están las variables de marca. |
| `fuentes/` | Playfair Display y Jost. Se pueden cambiar sin tocar el resto. |
| `img/logo.png` | El membrete de Coder Blend, recortado para la barra oscura. |

## Cómo armar una presentación nueva

1. **Copiar la carpeta** al proyecto: `cp -r docs/plantillas docs/presentacion-<cliente>`.

2. **Sacar las capturas** del celular o del emulador, y recortarles la barra de
   estado de Android (los primeros 90 píxeles) para que el teléfono de la
   plantilla no muestre la hora ni la señal:

   ```bash
   ffmpeg -i captura.png -vf "crop=1080:2310:0:90,scale=540:-2" img/01-principal.jpg
   ```

3. **Recortar los detalles.** Los paneles ampliados son lo que más impresiona:
   un pedazo de la interfaz mostrado grande, no la pantalla entera. Se saca del
   mismo PNG eligiendo el alto y desde dónde empieza:

   ```bash
   ffmpeg -i captura.png -vf "crop=1080:620:0:420,scale=820:-2" img/det-uno.jpg
   ```

4. **Reemplazar lo que está entre ⟦corchetes⟧** en el HTML y borrar las páginas
   que no se usen. Al borrar o mover una página hay que renumerar el
   `<span class="num">` del pie.

5. **Cambiar el color del proyecto** en `estilos.css`: `--acento`,
   `--acento-suave` y `--tinta`. Las tres sombras doradas del archivo
   (`.tel`, `.panel`, `.brillo`) llevan el valor escrito en `rgba(...)`;
   si el acento cambia mucho, conviene actualizarlas también.

6. **Generar el PDF**:

   ```bash
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf=salida.pdf caso-de-estudio.html
   ```

   Para revisar una página sin abrir el PDF, Chrome también saca la foto de todo
   el documento de una vez (cada página mide 1124 px de alto a 794 de ancho):

   ```bash
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --screenshot=todo.png --window-size=794,7868 --hide-scrollbars caso-de-estudio.html
   ```

## Lo que hace que se vea bien

- **La captura no lleva transparencia.** El brillo va detrás, en `.brillo`, o por
  fuera del marco, en la sombra de `.tel`. Una captura con opacidad parece un
  mockup mal hecho.
- **El resplandor señala, no decora.** Un halo por página, detrás de lo que
  importa.
- **Un panel ampliado por página, como mucho.** Es el recurso más fuerte; dos
  juntos se anulan.
- **El texto sobre el acento va en tinta, nunca blanco.** Blanco sobre dorado no
  llega al contraste mínimo y se nota impreso.
- **Ojo con el alto.** Teléfonos con pie de foto en fila de tres o cuatro
  necesitan la clase `.con-pie`, o el pie se corta contra el pie de página.
  Después de cada cambio conviene mirar la foto del documento entero.
- **Nada de inventar datos.** Si no hay números reales, no se ponen números.

## Variantes

- **Para el cliente**: todo en positivo, como está la plantilla.
- **Interna o para portafolio**: el bloque 3 se convierte en
  "Problemas & Soluciones" cambiando el texto de las dos `.tag` y el titular.
