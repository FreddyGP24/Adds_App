"""Genera el reporte PDF a partir de capturas originales y evidencias locales."""
from pathlib import Path
from html import escape
import re
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'output/pdf/reporte_mesa_ads.pdf'
OUT.parent.mkdir(parents=True, exist_ok=True)
CAP = ROOT / 'docs/capturas'
FONT = Path('C:/Windows/Fonts')
for name, file in [('Body','arial.ttf'),('Bold','arialbd.ttf'),('Serif','georgia.ttf')]:
    pdfmetrics.registerFont(TTFont(name, str(FONT / file)))
pdfmetrics.registerFontFamily('Body', normal='Body', bold='Bold', italic='Body', boldItalic='Bold')
W,H=A4
INK=colors.HexColor('#29251F'); ACC=colors.HexColor('#B54D32')
MUTED=colors.HexColor('#82796D'); PAPER=colors.HexColor('#F8F5EF')
SAND=colors.HexColor('#EDE5D8'); GREEN=colors.HexColor('#496340')
c=canvas.Canvas(str(OUT), pagesize=A4)
c.setTitle('Mesa - Reporte de implementación del anuncio 7')
c.setAuthor('Proyecto Mesa')

def para(text,x,y,w,size=11,color=INK,leading=None,font='Body'):
    style=ParagraphStyle('p',fontName=font,fontSize=size,leading=leading or size*1.48,textColor=color,spaceAfter=0)
    p=Paragraph(text,style); _,h=p.wrap(w,H)
    p.drawOn(c,x,y-h)
    return y-h

def label(text,x,y):
    c.setFillColor(ACC);c.setFont('Bold',9);c.drawString(x,y,text.upper())

def page(num,title,subtitle=''):
    c.setFillColor(PAPER);c.rect(0,0,W,H,fill=1,stroke=0)
    c.setFillColor(ACC);c.roundRect(36,H-63,35,30,8,fill=1,stroke=0)
    c.setFillColor(colors.white);c.setFont('Serif',19);c.drawCentredString(53.5,H-54,'m')
    c.setFillColor(INK);c.setFont('Bold',11);c.drawString(81,H-49,'mesa / cocina de casa')
    c.setFillColor(MUTED);c.setFont('Body',8);c.drawRightString(W-36,H-48,'PRÁCTICA ADS · 03 NOV 2026')
    c.setStrokeColor(SAND);c.line(36,51,W-36,51)
    c.setFont('Body',8);c.drawString(36,34,'Flutter + Google Mobile Ads | Restaurante de demostración')
    c.drawRightString(W-36,34,f'{num:02d} / 07')
    y=para(title,36,H-95,W-72,27,font='Serif',leading=32)
    if subtitle: y=para(subtitle,36,y-12,W-72,10.5,MUTED)
    return y-22

def shot(filename,x,y,w,h,caption=None):
    path=CAP/filename
    with Image.open(path) as im: iw,ih=im.size
    scale=min(w/iw,h/ih);dw,dh=iw*scale,ih*scale
    dx=x+(w-dw)/2;dy=y+(h-dh)/2
    c.setFillColor(colors.white);c.setStrokeColor(SAND)
    c.roundRect(dx-4,dy-4,dw+8,dh+8,8,fill=1,stroke=1)
    c.drawImage(str(path),dx,dy,width=dw,height=dh,mask='auto')
    if caption: para(caption,x,y-13,w,9,MUTED)

def box(text,x,y,w,h,color=SAND,size=11):
    c.setFillColor(color);c.roundRect(x,y-h,w,h,12,fill=1,stroke=0)
    para(text,x+16,y-15,w-32,size)

def code(text,x,y,w,size=9):
    lines=text.splitlines();h=len(lines)*(size*1.5)+26
    c.setFillColor(INK);c.roundRect(x,y-h,w,h,10,fill=1,stroke=0)
    c.setFillColor(colors.HexColor('#F8F5EF'));c.setFont('Courier',size)
    for i,line in enumerate(lines): c.drawString(x+14,y-21-i*size*1.5,line)
    return y-h

def finish(): c.showPage()

# 1. Portada y alcance.
y=page(1,'Una app de restaurante.\nUna recompensa bien integrada.'.replace('\n','<br/>'),'Reporte de actividades y evidencias de ejecución en Android')
label('Proyecto',36,y-5)
para('Mesa',36,y-25,220,42,font='Serif')
para('Cocina de casa',38,y-78,220,14,MUTED)
para('Menú con categorías, pedido con cantidades y confirmación para recoger.',36,y-125,220,12)
box('<b>Formato implementado: 7</b><br/>Intersticial recompensado de AdMob.<br/><br/>Recompensa de la demo: <b>1 brownie de cortesía</b> al completar el anuncio.',36,y-220,220,145,size=11)
para('Se utiliza el SDK real con IDs oficiales de prueba. Los pedidos y el postre son virtuales; no hay cobros ni servicio de restaurante real.',36,165,220,10,MUTED)
shot('01-menu.png',290,177,263,468,'Captura original del menú, tomada en el emulador Android.')
finish()

# 2. Investigación y configuración.
y=page(2,'01 / Identificar el anuncio correcto','El séptimo renglón de la consigna corresponde a un intersticial recompensado.')
y=para('Este formato ocupa la pantalla completa durante una transición de la app y puede otorgar una recompensa. En Mesa, la transición ocurre después de revisar el pedido y antes de mostrar la confirmación.',36,y,W-72,12)
y-=25
label('Unidad oficial de demostración para Android',36,y)
y=code('ca-app-pub-3940256099942544/5354046379',36,y-15,W-72,11)
y=para('Es el mismo ID que aparece en la imagen de la actividad. Solo se implementó este formato publicitario.',36,y-15,W-72,11,MUTED)
y-=27
label('Configurar el proyecto',36,y)
y=para('<b>1.</b> Agregar el paquete oficial <b>google_mobile_ads 9.2.0</b>.<br/><b>2.</b> Declarar Internet y el App ID de prueba en AndroidManifest.xml.<br/><b>3.</b> Inicializar MobileAds y precargar RewardedInterstitialAd.',36,y-15,W-72,11.5)
y=code('android.permission.INTERNET\ncom.google.android.gms.ads.APPLICATION_ID\nca-app-pub-3940256099942544~3347511713',36,y-19,W-72,9.5)
y=para('El App ID usa <b>~</b> y configura la aplicación. La unidad de anuncios usa <b>/</b> y selecciona el formato. No son intercambiables.',36,y-18,W-72,11)
box('<b>Decisión de interacción</b><br/>Antes de mostrar el anuncio se explica la recompensa y se ofrece omitirlo. Al estar listo, comienza después de 8 segundos; también se puede continuar de inmediato.',36,206,W-72,103,size=11)
para('Fuente: Google for Developers, guía de intersticiales recompensados y configuración de Flutter. Enlaces completos en la página 7.',36,85,W-72,8.5,MUTED)
finish()

# 3. App inicial y primer commit.
y=page(3,'02 / Crear la app inicial','Menú, cantidades y cálculo del total antes de conectar el flujo del anuncio.')
shot('02-platillo-agregado.png',38,228,249,443,'Se agrega una Burger de la casa. El botón del pedido refleja 1 producto y $145.00.')
shot('03-resumen-pedido.png',308,228,249,443,'El resumen permite editar cantidades y verificar el total antes de continuar.')
para('<b>Primer commit:</b> f140e2e<br/>feat: crear app inicial de restaurante con menu y pedidos',36,163,W-72,11)
para('La base incluye cuatro productos, fotografías locales y filtros Todo, Platos y Bebidas. El pedido se mantiene en memoria durante la sesión y se limpia al confirmarse.',36,108,W-72,10.5,MUTED)
finish()

# 4. Integración técnica.
y=page(4,'03 / Integrar el ciclo del anuncio','La lógica de anuncios se concentra en lib/ads/rewarded_ads.dart.')
steps=[('Inicializar y cargar','MobileAds.instance.initialize() prepara el SDK. RewardedInterstitialAd.load solicita únicamente el formato 7.'),('Mostrar en una transición','La pantalla AdIntroPage explica el brownie y permite omitir. show() abre el anuncio nativo fuera del árbol de widgets.'),('Confirmar la recompensa','onUserEarnedReward marca el anuncio como completado. Cerrar, omitir o fallar no activa la recompensa.'),('Liberar y preparar el siguiente','Al cerrar o fallar se ejecuta dispose(). Cada anuncio se utiliza una sola vez y después se solicita uno nuevo.')]
for i,(title,body) in enumerate(steps,1):
    c.setFillColor(ACC);c.circle(50,y-13,13,fill=1,stroke=0)
    c.setFillColor(colors.white);c.setFont('Bold',10);c.drawCentredString(50,y-16,str(i))
    yy=para(title,77,y,W-113,12,font='Bold')
    yy=para(body,77,yy-5,W-113,10.5,MUTED)
    y=yy-23
label('Fragmento del código implementado',36,y)
source=(ROOT/'lib/ads/rewarded_ads.dart').read_text(encoding='utf-8-sig')
start=source.index('await ad.show(')
end=source.index('\n    } catch',start)
snippet=source[start:end]
# Para el reporte se omite solo el comentario; se conserva el fragmento de lógica.
snippet='\n'.join(line for line in snippet.splitlines() if not line.lstrip().startswith('//'))
y=code(snippet,36,y-16,W-72,9)
para('La creatividad de prueba puede reportar una recompensa como "10 Coins". Mesa convierte el evento de finalización en un único brownie virtual por pedido; no interpreta esas monedas como dinero.',36,y-17,W-72,10.5,MUTED)
finish()

# 5. Intro y anuncio.
y=page(5,'04 / Ejecutar el anuncio de prueba','Evidencias tomadas del emulador Android, usando el SDK de Google Mobile Ads.')
shot('04-introduccion-recompensa.png',38,207,249,443,'Introducción: recompensa explícita, cuenta regresiva y opción de omitir el anuncio.')
shot('05-anuncio-prueba.png',308,207,249,443,'Anuncio nativo de pantalla completa con etiqueta Test Ad. La creatividad puede variar.')
para('El anuncio se presenta después de la cuenta regresiva. El control de cierre pertenece al SDK. La recompensa depende del evento de AdMob, no del temporizador de introducción ni de tocar el contenido del anuncio.',36,139,W-72,11)
para('Registro real del SDK: [ADS #7] Pantalla completa. La ejecución y la recompensa se conservan en docs/eventos-admob.txt.',36,83,W-72,9,MUTED)
finish()

# 6. Resultados comparados.
y=page(6,'05 / Comprobar ambos resultados','El pedido puede completarse con recompensa o sin ella.')
shot('06-recompensa-obtenida.png',38,208,249,443,'Anuncio completado: aparece el brownie virtual a $0.00 junto con la confirmación del pedido.')
shot('08-pedido-sin-recompensa.png',308,208,249,443,'Anuncio omitido: el pedido se confirma y no se agrega un postre.')
para('<b>Resultado esperado:</b> omitir el anuncio nunca bloquea el pedido. Si no hay conexión o falla la carga, se ofrece reintentar o continuar; tampoco se entrega recompensa por un fallo.',36,141,W-72,11)
para('Las siete pruebas automatizadas cubren cálculos del pedido, navegación, recompensa, cierre sin recompensa, fallo, omisión y regreso a la introducción.',36,85,W-72,9.5,MUTED)
finish()

# 7. Evidencias, commits, reproducción y fuentes.
y=page(7,'06 / Validar y documentar','Código versionado, pruebas reproducibles y capturas originales para la exposición.')
box('<b>Verificaciones</b><br/>flutter analyze: sin observaciones.<br/>flutter test: 7 pruebas aprobadas.<br/>flutter build apk --debug: compilación Android correcta.<br/>Prueba manual: anuncio real de prueba, recompensa y omisión.',36,y,W-72,112,size=11)
y-=137
label('Control de versiones',36,y)
commits=(ROOT/'docs/commits.txt').read_text(encoding='utf-8-sig').strip()
y=para(escape(commits).replace('\n','<br/>'),36,y-14,W-72,10.5)
y-=23
label('Reproducir la demostración',36,y)
y=code('flutter pub get\nflutter devices\nflutter run -d emulator-5554',36,y-15,W-72,10)
y=para('APK: build/app/outputs/flutter-apk/app-debug.apk<br/>Capturas originales: docs/capturas/<br/>Guía y recorrido para exponer: README.md',36,y-15,W-72,10)
y-=24
label('Fuentes consultadas',36,y)
links=[('Intersticial recompensado en Flutter','https://developers.google.com/admob/flutter/rewarded-interstitial'),('Configuración oficial de Google Mobile Ads','https://developers.google.com/admob/flutter/quick-start'),('Unidades Android de demostración','https://developers.google.com/admob/android/test-ads?hl=es-419'),('Paquete oficial google_mobile_ads','https://pub.dev/packages/google_mobile_ads')]
for title,url in links:
    y=para(f'<link href="{escape(url)}" color="#B54D32">{title}</link>',36,y-12,W-72,9.5)
para('Alcance: demostración escolar en Android 15 / API 35, Flutter 3.47.4. La interfaz usa datos en memoria. iOS está configurado en el código, pero no fue ejecutado en esta entrega. Fotografías: Unsplash, referencias en README.md.',36,108,W-72,9,MUTED)
finish()
c.save()
print(OUT)

