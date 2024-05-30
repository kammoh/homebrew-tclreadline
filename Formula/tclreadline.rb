class Tclreadline < Formula
  desc "Makes the GNU Readline library available for interactive tcl shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://github.com/flightaware/tclreadline/archive/v2.3.8.tar.gz"
  sha256 "a64e0faed5957b8e1ac16f179948e21cdd6d3b8313590b7ab049a3192ab864fb"

  bottle do
  end

  depends_on 'tcl-tk'
  depends_on 'readline'
  depends_on 'make' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}",
                           "--with-tcl=#{Formula["tcl-tk"].opt_lib}",
                           "--with-readline-includes=#{Formula["readline"].opt_include}"

    system "make", "install" 
  end

  def caveats
    <<-EOS
    To enable readline completion in tclsh put something like this in your ~/.tclshrc

    if {$tcl_interactive} {
      set auto_path [linsert $auto_path 0 #{lib}]
      package require tclreadline
      set tclreadline::historyLength 200
      tclreadline::Loop
    }

    See https://sourceforge.net/p/tclreadline/git/ci/master/tree/sample.tclshrc
    EOS
  end

  test do
    system "echo 'set auto_path [linsert $auto_path 0 #{lib}] ; if {[package require tclreadline] eq {" + version + "} } {exit 0} else {exit 1}' | tclsh -"
  end
end
