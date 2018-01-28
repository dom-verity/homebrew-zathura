# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class ZathuraPdfPoppler < Formula
  homepage "https://pwmt.org/projects/zathura-pdf-poppler/"
  url "https://pwmt.org/projects/zathura-pdf-poppler/download/zathura-pdf-poppler-0.2.8.tar.gz"
  version "0.2.8"
  sha256 "421d57a398d97c8264baced8743799fdec5f2cf989b34a8f42cf2277f4a9a5d4"

  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'zathura'
  depends_on 'poppler'
  depends_on 'pkg-config'

  # Apply patches from http://stackoverflow.com/a/29460237
  # patch :p0 do
  #   url "https://raw.githubusercontent.com/zegervdv/homebrew-zathura/master/zathura-pdf-poppler-config.mk.diff"
  #   sha256 "7acaaeeb5e75bf7cff864a850fc763d17a6a34dcbd3e11487d4d04a2904c8f49"
  # end

  # patch :p0 do
  #   url "https://raw.githubusercontent.com/zegervdv/homebrew-zathura/master/zathura-pdf-poppler-Makefile.diff"
  #   sha256 "a3ee7155707028806e1abb9e4bdf88bfc7bd71cebd10e6ac741285b8e26b0e05"
  # end

  def install
    inreplace "Makefile", /\$\{PREFIX\}\/bin\/zathura/, "#{Formula['zathura'].prefix}/bin/zathura"
    ENV['PREFIX'] = prefix
    ENV['PLUGINDIR'] = lib
    system "make"
    system "make install"

    # Rename pdf.dylib to pdf.so to make it work
    # mv "#{Formula['zathura'].prefix}/lib/zathura/pdf.dylib", "#{Formula['zathura'].prefix}/lib/zathura/pdf.so"
  end

  def caveats
    <<~EOS
      To enable this plugin you will need to link it in place.
      First create the plugin directory if it does not exist yet:
        $ mkdir -p $(brew --prefix zathura)/lib/zathura
      Then link the .dylib to the directory:
        $ ln -s $(brew --prefix zathura-pdf-poppler)/lib/pdf.dylib $(brew --prefix zathura)/lib/zathura/pdf.so

      More information as to why this is needed: https://github.com/zegervdv/homebrew-zathura/issues/19
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test zathura-pdf-poppler`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
