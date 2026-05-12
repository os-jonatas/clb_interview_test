import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/pdf_document.dart';
import '../providers/pdf_provider.dart';

/// Tela de visualização de um documento PDF individual.
/// Exibe o PDF a partir de uma URL e oferece controles de navegação por página.
class PdfViewerScreen extends StatefulWidget {
  final PdfDocument document;

  const PdfViewerScreen({super.key, required this.document});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  /// Controlador do Syncfusion PDF Viewer para navegação programática de páginas.
  final PdfViewerController _pdfViewerController = PdfViewerController();

  /// Número total de páginas do documento (atualizado quando o PDF é carregado).
  int _totalPages = 0;

  /// Número da página atual exibida.
  int _currentPage = 1;

  /// Indica se o documento foi carregado com sucesso.
  bool _isDocumentLoaded = false;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  /// Navega para a página anterior, se não estiver na primeira página.
  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  /// Navega para a próxima página, se não estiver na última página.
  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer envolve o Scaffold para que o ícone de favorito no AppBar
    // reflita as mudanças em tempo real (tanto aqui quanto na HomeScreen).
    return Consumer<PdfProvider>(
      builder: (context, provider, _) {
        // Busca o estado atualizado do documento a partir do provider
        // para garantir que as mudanças de favorito sejam refletidas corretamente.
        final currentDoc = provider.documents.firstWhere(
          (d) => d.id == widget.document.id,
          orElse: () => widget.document,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(currentDoc.title, overflow: TextOverflow.ellipsis),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            actions: [
              // Botão de favorito no AppBar que lê e atualiza o estado global
              IconButton(
                icon: Icon(
                  currentDoc.isFavorite ? Icons.star : Icons.star_border,
                  color: currentDoc.isFavorite ? Colors.amber : Colors.white,
                ),
                tooltip:
                    currentDoc.isFavorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                onPressed: () {
                  context.read<PdfProvider>().toggleFavorite(currentDoc.id);
                },
              ),
            ],
          ),
          body: SfPdfViewer.network(
            currentDoc.url,
            controller: _pdfViewerController,
            // Callback disparado quando o documento termina de carregar
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _totalPages = details.document.pages.count;
                _currentPage = 1;
                _isDocumentLoaded = true;
              });
            },
            // Callback disparado quando a página muda
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                _currentPage = details.newPageNumber;
              });
            },
            // Exibe erro caso o PDF não possa ser carregado
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao carregar PDF: ${details.description}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
          // Barra inferior com controles de navegação de página
          bottomNavigationBar: _buildNavigationBar(),
        );
      },
    );
  }

  /// Constrói a barra de navegação com botões "Anterior" e "Próxima".
  Widget _buildNavigationBar() {
    // Os botões são desabilitados (null) quando não há ação válida,
    // prevenindo erros de Index Out of Bounds.
    final bool canGoPrevious = _isDocumentLoaded && _currentPage > 1;
    final bool canGoNext = _isDocumentLoaded && _currentPage < _totalPages;

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão "Página Anterior"
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              label: const Text('Anterior'),
              // Desabilitado na primeira página (onPressed = null)
              onPressed: canGoPrevious ? _goToPreviousPage : null,
            ),

            // Indicador de página atual / total
            Text(
              _isDocumentLoaded ? 'Pág. $_currentPage / $_totalPages' : '...',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            // Botão "Próxima Página"
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              label: const Text('Próxima'),
              // Desabilitado na última página (onPressed = null)
              onPressed: canGoNext ? _goToNextPage : null,
              iconAlignment: IconAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
