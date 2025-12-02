import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Criar ícone principal
  await createIcon(
    'assets/icon/app_icon.png',
    size: 1024,
    withPadding: true,
  );
  
  // Criar ícone foreground para adaptive icon
  await createIcon(
    'assets/icon/app_icon_foreground.png',
    size: 1024,
    withPadding: false,
  );
  
  debugPrint('✅ Ícones criados com sucesso!');
  exit(0);
}

Future<void> createIcon(String path, {required double size, required bool withPadding}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  final iconSize = withPadding ? size * 0.6 : size * 0.8;
  final offset = withPadding ? size * 0.2 : size * 0.1;
  
  // Desenhar fundo (apenas para ícone com padding)
  if (withPadding) {
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size, size),
        const [Color(0xFF42A5F5), Color(0xFF1976D2)],
      );
    
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size, size),
      const Radius.circular(0.2),
    );
    canvas.drawRRect(rrect, bgPaint);
  }
  
  // Desenhar ícone de fórum
  // Balão de conversa principal
  final mainBalloonRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      offset,
      offset,
      iconSize * 0.7,
      iconSize * 0.6,
    ),
    Radius.circular(iconSize * 0.1),
  );
  
  final iconPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  
  canvas.drawRRect(mainBalloonRect, iconPaint);
  
  // Triângulo do balão (pontinho)
  final trianglePath = Path();
  trianglePath.moveTo(offset + iconSize * 0.15, offset + iconSize * 0.6);
  trianglePath.lineTo(offset + iconSize * 0.05, offset + iconSize * 0.75);
  trianglePath.lineTo(offset + iconSize * 0.25, offset + iconSize * 0.6);
  trianglePath.close();
  canvas.drawPath(trianglePath, iconPaint);
  
  // Balão de conversa secundário (menor, atrás)
  final secondBalloonRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      offset + iconSize * 0.4,
      offset + iconSize * 0.25,
      iconSize * 0.55,
      iconSize * 0.5,
    ),
    Radius.circular(iconSize * 0.08),
  );
  
  final secondPaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..style = PaintingStyle.fill;
  
  canvas.drawRRect(secondBalloonRect, secondPaint);
  
  // Linhas de texto no balão principal
  final linePaint = Paint()
    ..color = const Color(0xFF1976D2)
    ..strokeWidth = iconSize * 0.02
    ..strokeCap = StrokeCap.round;
  
  // Linha 1
  canvas.drawLine(
    Offset(offset + iconSize * 0.15, offset + iconSize * 0.25),
    Offset(offset + iconSize * 0.55, offset + iconSize * 0.25),
    linePaint,
  );
  
  // Linha 2
  canvas.drawLine(
    Offset(offset + iconSize * 0.15, offset + iconSize * 0.38),
    Offset(offset + iconSize * 0.50, offset + iconSize * 0.38),
    linePaint,
  );
  
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();
  
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(buffer);
  
  debugPrint('✅ Criado: $path');
}
