import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pdf_document.dart';
import '../providers/pdf_provider.dart';
import 'pdf_viewer_screen.dart';

/// Tela principal que exibe a lista de documentos PDF disponíveis.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLB PDF Reader'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<PdfProvider>(
        builder: (context, provider, _) {
          // Exibe indicador de carregamento enquanto os dados chegam
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando documentos...'),
                ],
              ),
            );
          }

          // Exibe mensagem de erro com opção de recarregar
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchDocuments(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Exibe a lista de documentos após o carregamento
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.documents.length,
            itemBuilder: (context, index) {
              final PdfDocument doc = provider.documents[index];
              return _DocumentCard(document: doc);
            },
          );
        },
      ),
    );
  }
}

/// Card individual que representa um documento PDF na lista.
class _DocumentCard extends StatelessWidget {
  final PdfDocument document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      elevation: 2.0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        // Ícone representativo do PDF
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 36),

        // Título com overflow para evitar RenderFlex overflow
        title: Text(
          document.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // Subtítulo (autor) também com proteção de overflow
        subtitle: Text(
          document.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Botão de favorito que atualiza o estado global via Provider
        trailing: IconButton(
          icon: Icon(
            document.isFavorite ? Icons.star : Icons.star_border,
            color: document.isFavorite ? Colors.amber : Colors.grey,
          ),
          tooltip:
              document.isFavorite
                  ? 'Remover dos favoritos'
                  : 'Adicionar aos favoritos',
          onPressed: () {
            // Usa listen: false para evitar rebuilds desnecessários neste callback
            context.read<PdfProvider>().toggleFavorite(document.id);
          },
        ),

        // Navega para a tela do visualizador de PDF ao tocar no item
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(document: document),
            ),
          );
        },
      ),
    );
  }
}
