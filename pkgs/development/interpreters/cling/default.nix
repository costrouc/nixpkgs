{ stdenv, fetchgit, fetchFromGitHub, cmake, glibc, libffi, makeWrapper, python }:

stdenv.mkDerivation {
  pname = "cling";
  version = "unstable-2018-11-20";

  clingSrc = fetchFromGitHub {
    owner = "root-project";
    repo = "cling";
    rev = "5789f5b2eb14ff8e14e6297fe3a449d0ef794f17";
    sha256 = "06l0c9p8102prhanhv8xawzq4k8g587d46aykc2y5j7rrzsbs5hs";
  };

  clangSrc = fetchgit {
    url = "http://root.cern.ch/git/clang.git";
    rev = "dd71e0397cfc8667d4c75ef5b4a1b35802608e59"; # This is the head of the cling-patches branch
    sha256 = "1ir1s4wy9683p9wrvra4xb4xqcd0amqnm4wahx1pf72zk2yxw1wh";
  };

  llvmSrc = fetchgit {
    url = "http://root.cern.ch/git/llvm.git";
    rev = "e0b472e46eb5861570497c2b9efabf96f2d4a485"; # This is the head of the cling-patches branch
    sha256 = "0yls35vyfcb14wghryss9xsin4cbpgkqckg72czh5jd2w0vjcmbx";
  };

  unpackPhase = ''
    runHook preUnpack

    cp -r "$llvmSrc/." .
    chmod u+w ./tools
    mkdir -p ./tools/cling && cp -r "$clingSrc/." ./tools/cling
    mkdir -p ./tools/clang && cp -r "$clangSrc/." ./tools/clang

    chmod -R u+w .

    runHook postUnpack
  '';

  nativeBuildInputs = [ cmake makeWrapper python ];
  buildInputs = [ libffi ];

  cmakeFlags = [
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLLVM_INSTALL_UTILS=ON"
  ];

  postInstall = ''
    wrapProgram $out/bin/cling --add-flags "-idirafter ${glibc.dev}/include"
  '';

  meta = with stdenv.lib; {
    homepage = https://root.cern.ch/cling;
    description = "An interactive C++ interpreter, built on the top of LLVM and Clang libraries";
    platforms = platforms.unix;
    license = with licenses; [ ncsa lgpl21 bsd3 bsd0 ];
    maintainers = [ maintainers.costrouc ];
  };
}
