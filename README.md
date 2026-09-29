# Linux標準教科書V4改訂プロジェクト

Pandoc 用 TeX/CSS（`template.tex` 等）は `build/` に置く（network-text / admin-text と同じ後発レイアウト）。原稿はリポジトリ直下。

## ローカルビルド

```bash
docker build -t ghcr.io/lpi-japan/linux-text:local build
./build/build-pdf.sh    # tmp/linuxtext_<ver>.pdf と _no_cover.pdf
./build/build-epub.sh   # tmp/linuxtext_<ver>.epub
```

ホストに pandoc / lualatex が無い場合、スクリプトが上記イメージ内で再実行する。

ビルド時に Git の先頭コミット（12 文字、`git=<sha>`、未コミット変更時は `-dirty`）をメタデータに載せる。版面には出ない。

- PDF: `Keywords`（例: `pdfinfo tmp/linuxtext_4.0.1.pdf | grep Keywords` / `exiftool -Keywords tmp/linuxtext_4.0.1.pdf`）
- EPUB: `Description`（例: `exiftool -Description tmp/linuxtext_4.0.1.epub`）
