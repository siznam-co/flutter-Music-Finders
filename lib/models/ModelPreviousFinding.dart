class PreviousFindings {
  String image;
  String title;
  String preview;

  PreviousFindings({
    this.image,
    this.title,
    this.preview,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': this.image,
      'title': this.title,
      'preview': this.preview,
    };
  }

  factory PreviousFindings.fromMap(Map<String, dynamic> map) {
    return PreviousFindings(
      image: map['image'] as String,
      title: map['title'] as String,
      preview: map['preview'] as String,
    );
  }

  @override
  String toString() {
    return 'PreviousFindings{image: $image, title: $title, preview: $preview}';
  }
}
