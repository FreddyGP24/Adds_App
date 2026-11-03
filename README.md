# Mesa · Cocina de casa

App escolar de restaurante en Flutter con un único formato de AdMob: **número 7, intersticial recompensado**. Usa el ID Android de la imagen: `ca-app-pub-3940256099942544/5354046379`.

## Funciones

- Menú de cuatro productos con fotografías locales y filtros por categoría.
- Pedido con cantidades, eliminación de productos y total en MXN.
- Introducción al anuncio en la transición entre pedido y confirmación. Explica la recompensa y ofrece omitir; si el anuncio está listo comienza automáticamente después de 8 segundos.
- Un brownie virtual de cortesía por pedido, únicamente si AdMob ejecuta `onUserEarnedReward`. Cerrar antes, omitir o fallar no da recompensa.
- Precarga, reintento de carga, liberación de anuncios usados y manejo de plataformas no compatibles.
- Datos de demostración en memoria. No hay servidor, compras ni cobros reales.

## Ejecutar en Android

```powershell
flutter pub get
flutter emulators --launch flutter_emulator
flutter devices
flutter run -d emulator-5554
```

Se necesita Flutter, Android SDK y conexión a Internet para el anuncio. Los emuladores Android son dispositivos de prueba. El menú funciona con imágenes locales. AdMob solo se muestra en Android o iOS; en web/escritorio la app permite continuar sin anuncio y sin premio. La integración iOS incluye IDs de prueba, pero esta entrega fue compilada y probada en Android.

## Recorrido para exponer

1. Agregar la Burger de la casa y abrir **Ver mi pedido**.
2. Revisar el total y pulsar **Continuar con mi pedido**.
3. Leer la introducción. Esperar la cuenta regresiva o pulsar **Continuar ahora**.
4. Completar el anuncio oficial de prueba y cerrarlo con su control de cierre. No hace falta instalar ni tocar el contenido del anuncio.
5. Ver **¡Recompensa obtenida!** con un brownie a $0.00.
6. Volver al menú y repetir usando **Omitir anuncio y confirmar pedido**. El pedido se confirma sin recompensa.

## Entregables y evidencias

- `output/pdf/reporte_mesa_ads.pdf`: reporte con pasos, capturas y explicación técnica.
- `docs/capturas/`: capturas PNG originales del emulador, sin edición.
- `docs/analisis.txt`, `docs/pruebas.txt`, `docs/compilacion.txt`: resultados reales de las verificaciones.
- `docs/eventos-admob.txt`: eventos de la prueba del SDK.
- `docs/commits.txt`: registro de los dos commits de desarrollo.
- `build/app/outputs/flutter-apk/app-debug.apk`: APK Android de depuración, firmado con la clave de pruebas.

## Código principal

- `lib/main.dart`: menú, pedido y confirmación.
- `lib/models/order.dart`: cantidades y cálculo del total.
- `lib/ads/rewarded_ads.dart`: único formato publicitario y callbacks del SDK.
- `lib/ads/ad_intro_page.dart`: introducción, cuenta regresiva y omisión.
- `android/app/src/main/AndroidManifest.xml`: permiso de Internet y App ID de prueba (con `~`, distinto del ID de unidad con `/`).

## Validaciones y compilación

```powershell
flutter analyze
flutter test --concurrency=1
flutter build apk --debug
```

Las pruebas de interfaz usan un proveedor de anuncios simulado para comprobar resultados sin red. Las capturas del anuncio y los eventos del SDK provienen de una ejecución real de AdMob en el emulador Android 15/API 35.

## Tomar nuevas capturas

```powershell
.\scripts\capturar.ps1 -Nombre nueva-captura
```

El script solo captura la pantalla actual mediante ADB. Acepta `-Dispositivo` y `-Adb` si se usa otro dispositivo o ubicación del SDK.

## Fuentes

- [Intersticial recompensado en Flutter](https://developers.google.com/admob/flutter/rewarded-interstitial)
- [Configuración oficial del plugin](https://developers.google.com/admob/flutter/quick-start)
- [Unidades Android de demostración](https://developers.google.com/admob/android/test-ads?hl=es-419)
- [Paquete oficial google_mobile_ads](https://pub.dev/packages/google_mobile_ads)

Fotografías de Unsplash guardadas localmente. IDs: burger `photo-1568901346375-23c9450c58cd`; pizza `photo-1579751626657-72bc17010498`; ensalada `photo-1546069901-ba9599a7e63c`; bebida `photo-1544145945-f90425340c7e`.
