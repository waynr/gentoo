# Copyright 2008-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# True Authors: Arfrever Frehtes Taifersar Arahesis and others

EAPI="6"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Java bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/19"
KEYWORDS=""
IUSE=""

DEPEND="~dev-libs/protobuf-${PV}
	>=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7
	!<dev-libs/protobuf-3[java(-)]"

S="${WORKDIR}/protobuf-${PV}/java"

if [[ "${PV}" == "9999" ]]; then
	EGIT_CHECKOUT_DIR="${WORKDIR}/protobuf-${PV}"
fi

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	"${EPREFIX}/usr/bin/protoc" --java_out=core/src/main/java -I../src ../src/google/protobuf/descriptor.proto || die
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_compile
}

src_install() {
	JAVA_SRC_DIR="core/src/main/java" JAVA_JAR_FILENAME="protobuf.jar" java-pkg-simple_src_install
}
