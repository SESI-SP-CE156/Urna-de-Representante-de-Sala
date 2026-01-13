import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/router/app_router.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Inicializa banco de dados
  await DatabaseHelper.instance.database;

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    skipTaskbar: false,
    title: "Urna Eletrônica",
    size: Size(1280, 720),
    minimumSize: Size(1024, 768),
    backgroundColor: Colors.transparent, // Ajuda visualmente na transição
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(1024, 768));
    await windowManager.setFullScreen(true);
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDA251D); // Vermelho SESI
    const backgroundColor = Color(0xFFF3F3F3); // Cinza Fundo
    const surfaceColor = Colors.white;
    const borderColor = Color(0xFFE0E0E0);
    const textColor = Color(0xFF242424);

    return Sizer(
      builder: (context, orientation, deviceType) {
        // --- CORREÇÃO DE SEGURANÇA (LINUX/DESKTOP) ---
        // Se a largura ou altura forem minúsculas (ex: 1px na inicialização),
        // retornamos um container vazio para não quebrar o layout.
        // O layout real só carrega quando a janela tiver tamanho "decente".
        if (100.w < 200 || 100.h < 200) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        // ----------------------------------------------

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Urna Eletrônica',
          theme: ThemeData(
            useMaterial3: true,
            visualDensity: VisualDensity.compact,

            // 1. Cores
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              surface: surfaceColor,
              onSurface: textColor,
              surfaceContainerLow: backgroundColor,
              outline: borderColor,
            ),

            // 2. Fundo
            scaffoldBackgroundColor: backgroundColor,

            // 3. Tipografia
            textTheme: GoogleFonts.openSansTextTheme().copyWith(
              displayLarge: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: -0.5,
              ),
              titleLarge: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              bodyLarge: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF424242),
              ),
              bodyMedium: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF424242),
              ),
            ),

            // 4. Cartões (Estilo Fluent)
            cardTheme: CardThemeData(
              color: surfaceColor,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: borderColor, width: 1),
              ),
              margin: EdgeInsets.all(4.sp),
            ),

            // 5. Inputs (Caixas de Texto)
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: surfaceColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.sp,
                vertical: 11.sp,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              labelStyle: GoogleFonts.openSans(
                color: Colors.grey[700],
                fontSize: 11.sp,
              ),
              floatingLabelStyle: GoogleFonts.openSans(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            // 6. Botões Elevados
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                // ALTERADO: Usamos valores fixos ou menores para caber no SizedBox(height: 50)
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: GoogleFonts.openSans(fontWeight: FontWeight.w600),
              ),
            ),

            // 7. Botões Contorno (CORREÇÃO AQUI)
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: const BorderSide(color: borderColor),
                // ALTERADO: Padding reduzido para evitar corte
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // 8. AppBar
            appBarTheme: AppBarTheme(
              backgroundColor: surfaceColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: const Border(bottom: BorderSide(color: borderColor)),
              iconTheme: const IconThemeData(color: textColor),
              titleTextStyle: GoogleFonts.openSans(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
