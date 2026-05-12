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
          title: 'Sample Multi-page Document',
          author: 'Public Domain',
          url: 'https://pdfobject.com/pdf/sample.pdf',
        ),

        PdfDocument(
          id: '4',
          title: 'W3C XML Specification',
          author: 'World Wide Web Consortium',
          url: 'https://www.w3.org/TR/2008/REC-xml-20081126/xml.pdf',
        ),

        PdfDocument(
          id: '5',
          title: 'U.S. Constitution',
          author: 'United States Government',
          url:
              'https://www.govinfo.gov/content/pkg/GPO-CONAN-2002/pdf/GPO-CONAN-2002-9.pdf',
        ),
        PdfDocument(
          id: '6',
          title: 'WHO - COVID-19 Situation Report',
          author: 'World Health Organization',
          url:
              'https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200202-sitrep-13-ncov-v3.pdf',
        ),
        PdfDocument(
          id: '7',
          title: 'Attention Is All You Need',
          author: 'Vaswani et al. — Google Brain',
          url: 'https://arxiv.org/pdf/1706.03762',
        ),
        PdfDocument(
          id: '8',
          title: 'Android Open Source Project Overview',
          author: 'Google LLC',
          url: 'https://source.android.com/docs/setup/about/faqs',
        ),
        PdfDocument(
          id: '9',
          title: 'RFC 2616 – HTTP/1.1',
          author: 'IETF – Fielding et al.',
          url: 'https://www.rfc-editor.org/rfc/pdfrfc/rfc2616.txt.pdf',
        ),
        PdfDocument(
          id: '10',
          title: 'A Brief History of Time – Excerpt',
          author: 'Stephen Hawking',
          url:
              'https://www.brynmawr.edu/sites/default/files/2021-11/hawkingbriefhistory.pdf',
        ),
        PdfDocument(
          id: '11',
          title: 'Introduction to Algorithms – Sample',
          author: 'MIT OpenCourseWare',
          url:
              'https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/readings/',
        ),
      ];
    } catch (e) {
      _errorMessage = 'Falha ao carregar documentos. Tente novamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Alterna o status de favorito de um documento pelo seu [id].
  /// Notifica os ouvintes para que a UI seja atualizada imediatamente.
  void toggleFavorite(String id) {
    final index = _documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      _documents[index].isFavorite = !_documents[index].isFavorite;
      notifyListeners();
    }
  }
}
