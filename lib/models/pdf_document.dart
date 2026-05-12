/// Modelo que representa um documento PDF na aplicação.
class PdfDocument {
  final String id;
  final String title;
  final String author;
  final String url;

  /// Indica se o documento foi marcado como favorito pelo usuário.
  bool isFavorite;

  PdfDocument({
    required this.id,
    required this.title,
    required this.author,
    required this.url,
    this.isFavorite = false,
  });
}
