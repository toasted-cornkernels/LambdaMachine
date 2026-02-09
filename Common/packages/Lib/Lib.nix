{ pkgs, ... }: {
  home.packages = with pkgs; [
    # boost
    coreutils
    coursier
    edencommon
    folly
    gd
    glib
    gmp
    gobject-introspection
    gpgme
    gtk3
    harfbuzz
    id3lib
    libass
    libffi
    # libgccjit
    libheif
    librsvg
    libtool
    # llvm
    # libllvm
    lzlib
    mpfr
    netpbm
    openblas
    pango
    poppler
    readline
    tesseract
    wangle
    xapian
    zlib
  ];
}
