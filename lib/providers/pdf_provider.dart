import 'package:flutter/material.dart';

import '../models/pdf_document.dart';

/// Provider responsável por gerenciar a lista de documentos PDF e seus estados.
/// Simula o consumo de uma API com um atraso assíncrono.
class PdfProvider extends ChangeNotifier {
  List<PdfDocument> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;

  /// Lista de documentos carregados (somente leitura externa).
  List<PdfDocument> get documents => _documents;

  /// Indica se os dados estão sendo carregados.
  bool get isLoading => _isLoading;

  /// Mensagem de erro, caso ocorra algum problema no carregamento.
  String? get errorMessage => _errorMessage;

  PdfProvider() {
    // Inicia o carregamento dos dados ao instanciar o Provider.
    fetchDocuments();
  }

  /// Simula uma chamada de API com Future.delayed de 2 segundos
  /// e popula a lista com 12 documentos de mock (todos com mais de 5 páginas).
  Future<void> fetchDocuments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simula latência de rede
      await Future.delayed(const Duration(seconds: 3));

      // Mock de dados: PDFs públicos com mais de 5 páginas
      _documents = [
        PdfDocument(
          id: '1',
          title: 'Lorem Ipsum - Sample PDF',
          author: 'Neque Porro Quisquam',
          url: 'https://www.orimi.com/pdf-test.pdf',
        ),
        PdfDocument(
          id: '2',
          title: 'PDF Reference - Adobe Systems',
          author: 'Adobe Systems Incorporated',
          url:
              'https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_PDF.pdf',
        ),
        PdfDocument(
          id: '3',
          title: 'WHO - COVID-19 Situation Report',
          author: 'World Health Organization',
          url:
              'https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200202-sitrep-13-ncov-v3.pdf',
        ),
        PdfDocument(
          id: '4',
          title: 'Attention Is All You Need',
          author: 'Vaswani et al. — Google Brain',
          url: 'https://arxiv.org/pdf/1706.03762',
        ),
        PdfDocument(
          id: '5',
          title: 'RFC 2616 – HTTP/1.1',
          author: 'IETF – Fielding et al.',
          url: 'https://www.rfc-editor.org/rfc/pdfrfc/rfc2616.txt.pdf',
        ),
      ];
    } catch (e) {
      _errorMessage = 'Falha ao carregar documentos. Tente novamente.';
    }
  }

  //TODO: Implementar função de favoritar
  void toggleFavorite(String id) {}
}
