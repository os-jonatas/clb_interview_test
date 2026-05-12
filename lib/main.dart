import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/pdf_provider.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MiniPdfReaderApp());
}

/// Ponto de entrada da aplicação.
/// O ChangeNotifierProvider disponibiliza o PdfProvider para toda a árvore de widgets.
class MiniPdfReaderApp extends StatelessWidget {
  const MiniPdfReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // PdfProvider é criado aqui e inicia o carregamento dos dados automaticamente.
      create: (_) => PdfProvider(),
      child: MaterialApp(
        title: 'Mini PDF Reader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey,
            primary: Colors.black45,
          ),
          useMaterial3: true,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
